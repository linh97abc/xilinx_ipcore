# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_NUM_PIN_OF_AUTO_WIDTH_PORT"
  ipgui::add_param $IPINST -name "C_S00_AXI_CLK_FREQ_HZ"

}

proc update_PARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT { PARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT } {
	# Procedure called to update C_NUM_PIN_OF_AUTO_WIDTH_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT { PARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT } {
	# Procedure called to validate C_NUM_PIN_OF_AUTO_WIDTH_PORT
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ { PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ } {
	# Procedure called to update C_S00_AXI_CLK_FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ { PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ } {
	# Procedure called to validate C_S00_AXI_CLK_FREQ_HZ
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT { MODELPARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT PARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT}] ${MODELPARAM_VALUE.C_NUM_PIN_OF_AUTO_WIDTH_PORT}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ { MODELPARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ}] ${MODELPARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ}
}

