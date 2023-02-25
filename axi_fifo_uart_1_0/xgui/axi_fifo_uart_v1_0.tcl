# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_S00_AXI_CLK_FREQ_HZ"
  ipgui::add_param $IPINST -name "C_BAUDRATE"
  ipgui::add_param $IPINST -name "C_PARITY" -widget comboBox
  ipgui::add_param $IPINST -name "C_DATA_BITS"
  ipgui::add_param $IPINST -name "C_STOP_BITS" -widget comboBox
  ipgui::add_param $IPINST -name "C_FIFO_DEPTH" -widget comboBox

}

proc update_PARAM_VALUE.C_BAUDRATE { PARAM_VALUE.C_BAUDRATE } {
	# Procedure called to update C_BAUDRATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BAUDRATE { PARAM_VALUE.C_BAUDRATE } {
	# Procedure called to validate C_BAUDRATE
	return true
}

proc update_PARAM_VALUE.C_DATA_BITS { PARAM_VALUE.C_DATA_BITS } {
	# Procedure called to update C_DATA_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_BITS { PARAM_VALUE.C_DATA_BITS } {
	# Procedure called to validate C_DATA_BITS
	return true
}

proc update_PARAM_VALUE.C_FIFO_DEPTH { PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to update C_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FIFO_DEPTH { PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to validate C_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_PARITY { PARAM_VALUE.C_PARITY } {
	# Procedure called to update C_PARITY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PARITY { PARAM_VALUE.C_PARITY } {
	# Procedure called to validate C_PARITY
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ { PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ } {
	# Procedure called to update C_S00_AXI_CLK_FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ { PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ } {
	# Procedure called to validate C_S00_AXI_CLK_FREQ_HZ
	return true
}

proc update_PARAM_VALUE.C_STOP_BITS { PARAM_VALUE.C_STOP_BITS } {
	# Procedure called to update C_STOP_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_STOP_BITS { PARAM_VALUE.C_STOP_BITS } {
	# Procedure called to validate C_STOP_BITS
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

proc update_MODELPARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ { MODELPARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ}] ${MODELPARAM_VALUE.C_S00_AXI_CLK_FREQ_HZ}
}

proc update_MODELPARAM_VALUE.C_BAUDRATE { MODELPARAM_VALUE.C_BAUDRATE PARAM_VALUE.C_BAUDRATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BAUDRATE}] ${MODELPARAM_VALUE.C_BAUDRATE}
}

proc update_MODELPARAM_VALUE.C_PARITY { MODELPARAM_VALUE.C_PARITY PARAM_VALUE.C_PARITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PARITY}] ${MODELPARAM_VALUE.C_PARITY}
}

proc update_MODELPARAM_VALUE.C_DATA_BITS { MODELPARAM_VALUE.C_DATA_BITS PARAM_VALUE.C_DATA_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_BITS}] ${MODELPARAM_VALUE.C_DATA_BITS}
}

proc update_MODELPARAM_VALUE.C_STOP_BITS { MODELPARAM_VALUE.C_STOP_BITS PARAM_VALUE.C_STOP_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_STOP_BITS}] ${MODELPARAM_VALUE.C_STOP_BITS}
}

proc update_MODELPARAM_VALUE.C_FIFO_DEPTH { MODELPARAM_VALUE.C_FIFO_DEPTH PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_FIFO_DEPTH}
}

