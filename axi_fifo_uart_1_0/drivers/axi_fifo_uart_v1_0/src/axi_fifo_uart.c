

/***************************** Include Files *******************************/
#include "axi_fifo_uart.h"

/************************** Function Definitions ***************************/
int axi_fifo_uart_config(u32 uartBaseAddr, axi_fifo_uart_cfg_data_t *cfgData)
{
    unsigned prescale = cfgData->corefreq/cfgData->baudrate;
    unsigned data_bits = (cfgData->data_bits == AXI_FIFO_UART_DATA_BITS_16)? 16: 8;

    u32 cfgRegVal = AXI_FIFO_UART_CTRL_PRESCALER_2REGVAL(prescale) |
        AXI_FIFO_UART_CTRL_PARITY_2REGVAL(cfgData->parity) |
        AXI_FIFO_UART_CTRL_BYTESIZE_2REGVAL(cfgData->data_bits) |
        AXI_FIFO_UART_CTRL_STOPBITS_2REGVAL(cfgData->stop_bits) |
        AXI_FIFO_UART_CTRL_RX_EN_MASK |
        AXI_FIFO_UART_CTRL_TX_EN_MASK |
        AXI_FIFO_UART_CTRL_RESET_MASK;

    AXI_FIFO_UART_mWriteReg(uartBaseAddr, AXI_FIFO_UART_CTRL_REG_OFFSET, 
        cfgRegVal
        );
    
    AXI_FIFO_UART_mWriteReg(uartBaseAddr, AXI_FIFO_UART_CTRL_REG_OFFSET, 
        cfgRegVal | AXI_FIFO_UART_CTRL_EN_MASK
        );
}

int axi_fifo_uart_read(u32 uartBaseAddr, u8 *data, unsigned length)
{
    unsigned i = 0;
    u32 regVal = AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_CTRL_REG_OFFSET);
    unsigned data_bits = AXI_FIFO_UART_CTRL_BYTESIZE(regVal);

    if (data_bits > 8)
    {
        u16 recvdata;

        length &= ~1u;

        while(i < length)
        {
            u32 flag = AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_FLAG_REG_OFFSET);
            if (!(flag & AXI_FIFO_UART_FLAG_RX_VALID_MASK))
            {
                break;
            }

            if (!(flag & AXI_FIFO_UART_FLAG_RX_PARITY_ERROR_MASK))
            {
                AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_RX_REG_OFFSET);
                continue;
            }

            recvdata = AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_RX_REG_OFFSET);
            pdata[i] = recvdata & 0xFFu
            pdata[i + 1] = (recvdata >> 8) & 0xFFu;

            i += 2;
        }
    }
    else
    {
        while(i < length)
        {
            u32 flag = AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_FLAG_REG_OFFSET);
            if (!(flag & AXI_FIFO_UART_FLAG_RX_VALID_MASK))
            {
                break;
            }

            if (!(flag & AXI_FIFO_UART_FLAG_RX_PARITY_ERROR_MASK))
            {
                AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_RX_REG_OFFSET);
                continue;
            }

            data[i] = AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_RX_REG_OFFSET);
            i += 1;
        }

    }
    
    return i;
}

int axi_fifo_uart_write(u32 uartBaseAddr, u8 *data, unsigned length)
{
    unsigned i;
    u32 regVal = AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_CTRL_REG_OFFSET);
    unsigned data_bits = AXI_FIFO_UART_CTRL_BYTESIZE(regVal);

    if (data_bits > 8)
    {
        u16 senddata;

        length &= ~1u;

        for(i = 0; i < length; i += 2)
        {
            if (
                !(AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_FLAG_REG_OFFSET) & 
                AXI_FIFO_UART_FLAG_TX_READY_MASK))
            {
                break;
            }

            senddata = ((u16)pdata[i + 1] << 8) | (u16)pdata[i];
            AXI_FIFO_UART_mWriteReg(uartBaseAddr, AXI_FIFO_UART_TX_REG_OFFSET, senddata);

        }
    }
    else
    {
        for(i = 0; i < length; i++)
        {
            if (
                !(AXI_FIFO_UART_mReadReg(uartBaseAddr, AXI_FIFO_UART_FLAG_REG_OFFSET) & 
                AXI_FIFO_UART_FLAG_TX_READY_MASK))
            {
                break;
            }

            AXI_FIFO_UART_mWriteReg(uartBaseAddr, AXI_FIFO_UART_TX_REG_OFFSET, data[i]);
        }

    }
    
    return i;
}
