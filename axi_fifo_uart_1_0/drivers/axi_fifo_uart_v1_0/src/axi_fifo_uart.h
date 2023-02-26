
#ifndef AXI_FIFO_UART_H
#define AXI_FIFO_UART_H

/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include <errno.h>

#define AXI_FIFO_UART_CTRL_REG_OFFSET (0u << 2);
#define AXI_FIFO_UART_IE_REG_OFFSET (1u << 2);
#define AXI_FIFO_UART_INT_E_REG_OFFSET (2u << 2);
#define AXI_FIFO_UART_INT_D_REG_OFFSET (3u << 2);
#define AXI_FIFO_UART_FLAG_REG_OFFSET (4u << 2);
#define AXI_FIFO_UART_TX_REQ_REG_OFFSET (5u << 2);
#define AXI_FIFO_UART_RX_REQ_REG_OFFSET (6u << 2);
#define AXI_FIFO_UART_TX_DATA_CNT_REG_OFFSET (7u << 2);
#define AXI_FIFO_UART_RX_DATA_CNT_REG_OFFSET (8u << 2);
#define AXI_FIFO_UART_TX_REG_OFFSET (9u << 2);
#define AXI_FIFO_UART_RX_REG_OFFSET (10u << 2);

/* AXI_FIFO_UART_CTRL_REG */
/* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26], en = [31] */
#define AXI_FIFO_UART_CTRL_PRESCALER(regVal) ((regVal)&0xFFFFu)
#define AXI_FIFO_UART_CTRL_PRESCALER_2REGVAL(value) ((value)&0xFFFFu)
#define AXI_FIFO_UART_CTRL_PARITY(regVal) (((regVal) >> 16) & 0x7u)
#define AXI_FIFO_UART_CTRL_PARITY_2REGVAL(value) (((value)&0x7u) << 16)
#define AXI_FIFO_UART_CTRL_BYTESIZE(regVal) (((regVal) >> 19) & 0xFu)
#define AXI_FIFO_UART_CTRL_BYTESIZE_2REGVAL(value) (((value)&0xFu) << 19)
#define AXI_FIFO_UART_CTRL_STOPBITS(regVal) (((regVal) >> 23) & 0x1u)
#define AXI_FIFO_UART_CTRL_STOPBITS_2REGVAL(value) (((value)&0x1u) << 23)
#define AXI_FIFO_UART_CTRL_RX_EN_MASK (1u << 24)
#define AXI_FIFO_UART_CTRL_TX_EN_MASK (1u << 25)
#define AXI_FIFO_UART_CTRL_RESET_MASK (1u << 26)
#define AXI_FIFO_UART_CTRL_EN_MASK (1u << 31)

/* AXI_FIFO_UART_IE_REG */
#define AXI_FIFO_UART_IE_RX_VALID_MASK (1u << 0)
#define AXI_FIFO_UART_IE_TX_READY_MASK (1u << 1)
#define AXI_FIFO_UART_IE_RX_REQ_MASK (1u << 2)
#define AXI_FIFO_UART_IE_TX_REQ_MASK (1u << 3)

/* AXI_FIFO_UART_FLAG_REG */
#define AXI_FIFO_UART_FLAG_RX_VALID_MASK (1u << 0)
#define AXI_FIFO_UART_FLAG_RX_PARITY_ERROR_MASK (1u << 1)
#define AXI_FIFO_UART_FLAG_RX_REQ_MASK (1u << 2)
#define AXI_FIFO_UART_FLAG_TX_READY_MASK (1u << 8)
#define AXI_FIFO_UART_FLAG_TX_REQ_MASK (1u << 9)

/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a AXI_FIFO_UART register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the AXI_FIFO_UARTdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void AXI_FIFO_UART_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define AXI_FIFO_UART_mWriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a AXI_FIFO_UART register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the AXI_FIFO_UART device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 AXI_FIFO_UART_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define AXI_FIFO_UART_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/* 0(none), 1(even), 2(odd), 3(mark), 4(space) */
typedef enum axi_fifo_uart_parity
{
    AXI_FIFO_UART_PARITY_NONE = 0,
    AXI_FIFO_UART_PARITY_EVEN = 1,
    AXI_FIFO_UART_PARITY_ODD = 2,
    AXI_FIFO_UART_PARITY_MARK = 3,
    AXI_FIFO_UART_PARITY_SPACE = 4
} axi_fifo_uart_parity_t;


/* 0(one stop), 1(two stops) */
typedef enum axi_fifo_uart_stop_bits
{
    AXI_FIFO_UART_STOP_BITS_ONE = 0,
    AXI_FIFO_UART_STOP_BITS_TWO = 1

} axi_fifo_uart_stop_bits_t;

typedef enum axi_fifo_uart_data_bits
{
    AXI_FIFO_UART_DATA_BITS_8,
    AXI_FIFO_UART_DATA_BITS_16

} axi_fifo_uart_data_bits_t;

typedef struct axi_fifo_uart_cfg_data
{
    unsigned baudrate;
    unsigned corefreq;
    axi_fifo_uart_parity_t parity;
    axi_fifo_uart_data_bits_t data_bits; // 1 <= data_bita <= 16
    axi_fifo_uart_stop_bits_t stop_bits;
} axi_fifo_uart_cfg_data_t;

int axi_fifo_uart_config(u32 uartBaseAddr, axi_fifo_uart_cfg_data_t *cfgData);
int axi_fifo_uart_read(u32 uartBaseAddr, u8 *data, unsigned length);
int axi_fifo_uart_write(u32 uartBaseAddr, u8 *data, unsigned length);

#endif // AXI_FIFO_UART_H
