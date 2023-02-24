

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "auto_param_example_ip" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR" "C_S00_AXI_CLK_FREQ_HZ" "C_NUM_PIN_OF_AUTO_WIDTH_PORT" 
}
