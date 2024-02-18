# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "opAdd" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opAddi" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opDisplay" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opHalt" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opLd" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opNOP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opSTR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opSub" -parent ${Page_0}
  ipgui::add_param $IPINST -name "opSubi" -parent ${Page_0}


}

proc update_PARAM_VALUE.opAdd { PARAM_VALUE.opAdd } {
	# Procedure called to update opAdd when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opAdd { PARAM_VALUE.opAdd } {
	# Procedure called to validate opAdd
	return true
}

proc update_PARAM_VALUE.opAddi { PARAM_VALUE.opAddi } {
	# Procedure called to update opAddi when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opAddi { PARAM_VALUE.opAddi } {
	# Procedure called to validate opAddi
	return true
}

proc update_PARAM_VALUE.opDisplay { PARAM_VALUE.opDisplay } {
	# Procedure called to update opDisplay when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opDisplay { PARAM_VALUE.opDisplay } {
	# Procedure called to validate opDisplay
	return true
}

proc update_PARAM_VALUE.opHalt { PARAM_VALUE.opHalt } {
	# Procedure called to update opHalt when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opHalt { PARAM_VALUE.opHalt } {
	# Procedure called to validate opHalt
	return true
}

proc update_PARAM_VALUE.opLd { PARAM_VALUE.opLd } {
	# Procedure called to update opLd when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opLd { PARAM_VALUE.opLd } {
	# Procedure called to validate opLd
	return true
}

proc update_PARAM_VALUE.opNOP { PARAM_VALUE.opNOP } {
	# Procedure called to update opNOP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opNOP { PARAM_VALUE.opNOP } {
	# Procedure called to validate opNOP
	return true
}

proc update_PARAM_VALUE.opSTR { PARAM_VALUE.opSTR } {
	# Procedure called to update opSTR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opSTR { PARAM_VALUE.opSTR } {
	# Procedure called to validate opSTR
	return true
}

proc update_PARAM_VALUE.opSub { PARAM_VALUE.opSub } {
	# Procedure called to update opSub when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opSub { PARAM_VALUE.opSub } {
	# Procedure called to validate opSub
	return true
}

proc update_PARAM_VALUE.opSubi { PARAM_VALUE.opSubi } {
	# Procedure called to update opSubi when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.opSubi { PARAM_VALUE.opSubi } {
	# Procedure called to validate opSubi
	return true
}


proc update_MODELPARAM_VALUE.opLd { MODELPARAM_VALUE.opLd PARAM_VALUE.opLd } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opLd}] ${MODELPARAM_VALUE.opLd}
}

proc update_MODELPARAM_VALUE.opSub { MODELPARAM_VALUE.opSub PARAM_VALUE.opSub } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opSub}] ${MODELPARAM_VALUE.opSub}
}

proc update_MODELPARAM_VALUE.opAdd { MODELPARAM_VALUE.opAdd PARAM_VALUE.opAdd } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opAdd}] ${MODELPARAM_VALUE.opAdd}
}

proc update_MODELPARAM_VALUE.opDisplay { MODELPARAM_VALUE.opDisplay PARAM_VALUE.opDisplay } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opDisplay}] ${MODELPARAM_VALUE.opDisplay}
}

proc update_MODELPARAM_VALUE.opAddi { MODELPARAM_VALUE.opAddi PARAM_VALUE.opAddi } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opAddi}] ${MODELPARAM_VALUE.opAddi}
}

proc update_MODELPARAM_VALUE.opSubi { MODELPARAM_VALUE.opSubi PARAM_VALUE.opSubi } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opSubi}] ${MODELPARAM_VALUE.opSubi}
}

proc update_MODELPARAM_VALUE.opHalt { MODELPARAM_VALUE.opHalt PARAM_VALUE.opHalt } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opHalt}] ${MODELPARAM_VALUE.opHalt}
}

proc update_MODELPARAM_VALUE.opSTR { MODELPARAM_VALUE.opSTR PARAM_VALUE.opSTR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opSTR}] ${MODELPARAM_VALUE.opSTR}
}

proc update_MODELPARAM_VALUE.opNOP { MODELPARAM_VALUE.opNOP PARAM_VALUE.opNOP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.opNOP}] ${MODELPARAM_VALUE.opNOP}
}

