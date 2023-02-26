

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "axi_fifo_uart" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR" "C_S00_AXI_CLK_FREQ_HZ" "C_BAUDRATE" "C_PARITY" "C_DATA_BITS" "C_STOP_BITS" "C_FIFO_DEPTH"

}
