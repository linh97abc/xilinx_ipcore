# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_DEBOUNCE_TIME" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_DWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_FREQ_CLK_SAMPLE_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TRIMODE" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_DEBOUNCE_TIME { PARAM_VALUE.C_DEBOUNCE_TIME } {
	# Procedure called to update C_DEBOUNCE_TIME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DEBOUNCE_TIME { PARAM_VALUE.C_DEBOUNCE_TIME } {
	# Procedure called to validate C_DEBOUNCE_TIME
	return true
}

proc update_PARAM_VALUE.C_DWIDTH { PARAM_VALUE.C_DWIDTH } {
	# Procedure called to update C_DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DWIDTH { PARAM_VALUE.C_DWIDTH } {
	# Procedure called to validate C_DWIDTH
	return true
}

proc update_PARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ { PARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ } {
	# Procedure called to update C_FREQ_CLK_SAMPLE_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ { PARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ } {
	# Procedure called to validate C_FREQ_CLK_SAMPLE_HZ
	return true
}

proc update_PARAM_VALUE.C_TRIMODE { PARAM_VALUE.C_TRIMODE } {
	# Procedure called to update C_TRIMODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TRIMODE { PARAM_VALUE.C_TRIMODE } {
	# Procedure called to validate C_TRIMODE
	return true
}


proc update_MODELPARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ { MODELPARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ PARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ}] ${MODELPARAM_VALUE.C_FREQ_CLK_SAMPLE_HZ}
}

proc update_MODELPARAM_VALUE.C_DWIDTH { MODELPARAM_VALUE.C_DWIDTH PARAM_VALUE.C_DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DWIDTH}] ${MODELPARAM_VALUE.C_DWIDTH}
}

proc update_MODELPARAM_VALUE.C_TRIMODE { MODELPARAM_VALUE.C_TRIMODE PARAM_VALUE.C_TRIMODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TRIMODE}] ${MODELPARAM_VALUE.C_TRIMODE}
}

proc update_MODELPARAM_VALUE.C_DEBOUNCE_TIME { MODELPARAM_VALUE.C_DEBOUNCE_TIME PARAM_VALUE.C_DEBOUNCE_TIME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DEBOUNCE_TIME}] ${MODELPARAM_VALUE.C_DEBOUNCE_TIME}
}

