# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_FREQ_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_PRESCALE" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_FREQ_HZ { PARAM_VALUE.C_FREQ_HZ } {
	# Procedure called to update C_FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FREQ_HZ { PARAM_VALUE.C_FREQ_HZ } {
	# Procedure called to validate C_FREQ_HZ
	return true
}

proc update_PARAM_VALUE.C_PRESCALE { PARAM_VALUE.C_PRESCALE } {
	# Procedure called to update C_PRESCALE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PRESCALE { PARAM_VALUE.C_PRESCALE } {
	# Procedure called to validate C_PRESCALE
	return true
}


proc update_MODELPARAM_VALUE.C_PRESCALE { MODELPARAM_VALUE.C_PRESCALE PARAM_VALUE.C_PRESCALE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PRESCALE}] ${MODELPARAM_VALUE.C_PRESCALE}
}

proc update_MODELPARAM_VALUE.C_FREQ_HZ { MODELPARAM_VALUE.C_FREQ_HZ PARAM_VALUE.C_FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FREQ_HZ}] ${MODELPARAM_VALUE.C_FREQ_HZ}
}

