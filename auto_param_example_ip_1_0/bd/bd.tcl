
proc init { cellpath otherInfo } {                                                                   
    bd::send_msg -of $cellpath -type INFO -msg_id 0 -text ": init ip auto_param example."
	set cell_handle [get_bd_cells $cellpath]                                                                 
	set all_busif [get_bd_intf_pins $cellpath/*]		                                                     
	set axi_standard_param_list [list ID_WIDTH AWUSER_WIDTH ARUSER_WIDTH WUSER_WIDTH RUSER_WIDTH BUSER_WIDTH]
	set full_sbusif_list [list  ]

    # set auto param
    set paramList "C_NUM_PIN_OF_AUTO_WIDTH_PORT C_S00_AXI_CLK_FREQ_HZ"
    bd::mark_propagate_only $cell_handle $paramList
                                               
	foreach busif $all_busif {                                                                               
		if { [string equal -nocase [get_property MODE $busif] "slave"] == 1 } {                            
			set busif_param_list [list]                                                                      
			set busif_name [get_property NAME $busif]					                                     
			if { [lsearch -exact -nocase $full_sbusif_list $busif_name ] == -1 } {					         
			    continue                                                                                     
			}                                                                                                
			foreach tparam $axi_standard_param_list {                                                        
				lappend busif_param_list "C_${busif_name}_${tparam}"                                       
			}                                                                                                
			bd::mark_propagate_only $cell_handle $busif_param_list			                                 
		}		                                                                                             
	}                                                                                                        
}


proc pre_propagate {cellpath otherInfo } {                                                           
                                                                                                             
	set cell_handle [get_bd_cells $cellpath]                                                                 
	set all_busif [get_bd_intf_pins $cellpath/*]		                                                     
	set axi_standard_param_list [list ID_WIDTH AWUSER_WIDTH ARUSER_WIDTH WUSER_WIDTH RUSER_WIDTH BUSER_WIDTH]
	                                                                                                         
	foreach busif $all_busif {	                                                                             
		if { [string equal -nocase [get_property CONFIG.PROTOCOL $busif] "AXI4"] != 1 } {                  
			continue                                                                                         
		}                                                                                                    
		if { [string equal -nocase [get_property MODE $busif] "master"] != 1 } {                           
			continue                                                                                         
		}			                                                                                         
		                                                                                                     
		set busif_name [get_property NAME $busif]			                                                 
		foreach tparam $axi_standard_param_list {		                                                     
			set busif_param_name "C_${busif_name}_${tparam}"			                                     
			                                                                                                 
			set val_on_cell_intf_pin [get_property CONFIG.${tparam} $busif]                                  
			set val_on_cell [get_property CONFIG.${busif_param_name} $cell_handle]                           
			                                                                                                 
			if { [string equal -nocase $val_on_cell_intf_pin $val_on_cell] != 1 } {                          
				if { $val_on_cell != "" } {                                                                  
					set_property CONFIG.${tparam} $val_on_cell $busif                                        
				}                                                                                            
			}			                                                                                     
		}		                                                                                             
	}                                                                                                        
}


proc propagate {cellpath otherInfo } {                                                               
                                                                                                             
	set cell_handle [get_bd_cells $cellpath]                                                                 
	set all_busif [get_bd_intf_pins $cellpath/*]		                                                     
	set axi_standard_param_list [list ID_WIDTH AWUSER_WIDTH ARUSER_WIDTH WUSER_WIDTH RUSER_WIDTH BUSER_WIDTH]
	                                                                                                         
	foreach busif $all_busif {                                                                               
		if { [string equal -nocase [get_property CONFIG.PROTOCOL $busif] "AXI4"] != 1 } {                  
			continue                                                                                         
		}                                                                                                    
		if { [string equal -nocase [get_property MODE $busif] "slave"] != 1 } {                            
			continue                                                                                         
		}			                                                                                         
	                                                                                                         
		set busif_name [get_property NAME $busif]		                                                     
		foreach tparam $axi_standard_param_list {			                                                 
			set busif_param_name "C_${busif_name}_${tparam}"			                                     
                                                                                                             
			set val_on_cell_intf_pin [get_property CONFIG.${tparam} $busif]                                  
			set val_on_cell [get_property CONFIG.${busif_param_name} $cell_handle]                           
			                                                                                                 
			if { [string equal -nocase $val_on_cell_intf_pin $val_on_cell] != 1 } {                          
				#override property of bd_interface_net to bd_cell -- only for slaves.  May check for supported values..
				if { $val_on_cell_intf_pin != "" } {                                                         
					set_property CONFIG.${busif_param_name} $val_on_cell_intf_pin $cell_handle               
				}                                                                                            
			}                                                                                                
		}		                                                                                             
	}                                                                                                        
}

proc post_propagate { cellName dictArg } {
    bd::send_msg -of $cellName -type INFO -msg_id 0 -text ": post_propagate ip auto_param example."
    set ip [get_bd_cells $cellName]

    set auto_width_portPin [get_bd_pins ${cellName}/auto_width_port]
    set auto_width_portPinDriver [find_bd_objs -thru_hier -relation connected_to $auto_width_portPin]

    if { [string length $auto_width_portPinDriver] > 0 } {

       # Update C_NUM_INTR_INPUTS:
       # - Check for propagated PortWidth property
       # - Check for vector ports and pins on driver
       # - Assume single port or pin if properties LEFT and RIGHT are empty
       set width [get_property CONFIG.PortWidth $auto_width_portPin]
       set max_width [expr 32]
       if { [string length $width] > 0 && $width != 0 } {
          if {$width <= $max_width} {
             set_property CONFIG.C_NUM_PIN_OF_AUTO_WIDTH_PORT $width $ip
          }
       } elseif { [string length $width] == 0 } {
          set left  [get_property LEFT  $auto_width_portPinDriver]
          set right [get_property RIGHT $auto_width_portPinDriver]
          if { [string length $left] > 0 && [string length $right] > 0 } {
             set width [expr ($left > $right) ? $left - $right + 1 : $right - $left + 1]
          } else {
             set width 1
          }
          if {$width <=  $max_width} {
             set_property CONFIG.C_NUM_PIN_OF_AUTO_WIDTH_PORT $width $ip
          }
       }
    }
    
    # update clock param
    set clk_pin [get_bd_pins $cellName/s00_axi_aclk]
    set freq_hz [get_property CONFIG.FREQ_HZ $clk_pin]
    
    set_property CONFIG.C_S00_AXI_CLK_FREQ_HZ [expr $freq_hz / 1.0] $ip
}