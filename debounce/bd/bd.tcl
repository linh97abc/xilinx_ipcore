
proc init { cellpath otherInfo } {                                                                   
   bd::send_msg -of $cellpath -type INFO -msg_id 0 -text ": init ip debounce."
	set cell_handle [get_bd_cells $cellpath]

   # set auto param
   set paramList "C_FREQ_CLK_SAMPLE_HZ C_DWIDTH"
   bd::mark_propagate_only $cell_handle $paramList                                                                                                      
}


proc pre_propagate {cellpath otherInfo } {                                                           
   bd::send_msg -of $cellpath -type INFO -msg_id 0 -text ": pre_propagate ip debounce"                                                                                                                                                                                                             
}


proc propagate {cellpath otherInfo } {                                                               
   bd::send_msg -of $cellpath -type INFO -msg_id 0 -text ": propagate ip debounce"                                                                                                                                                                                                           
}

proc post_propagate { cellName dictArg } {
   bd::send_msg -of $cellName -type INFO -msg_id 0 -text ": post_propagate ip debounce"
   set ip [get_bd_cells $cellName]

   set auto_width_portPin [get_bd_pins ${cellName}/l_gpio_i]
   set auto_width_portPinDriver [find_bd_objs -thru_hier -relation connected_to $auto_width_portPin]

   if { [string length $auto_width_portPinDriver] > 0 } {

      # Update C_NUM_INTR_INPUTS:
      # - Check for propagated PortWidth property
      # - Check for vector ports and pins on driver
      # - Assume single port or pin if properties LEFT and RIGHT are empty
      set width [get_property CONFIG.PortWidth $auto_width_portPin]
      
      if { [string length $width] > 0 && $width != 0 } {
         set_property CONFIG.C_DWIDTH $width $ip
         
      } elseif { [string length $width] == 0 } {
         set left  [get_property LEFT  $auto_width_portPinDriver]
         set right [get_property RIGHT $auto_width_portPinDriver]
         if { [string length $left] > 0 && [string length $right] > 0 } {
            set width [expr ($left > $right) ? $left - $right + 1 : $right - $left + 1]
         } else {
            set width 1
         }
         
         set_property CONFIG.C_DWIDTH $width $ip
         
      }
   } else {

      set debouncePort [get_bd_intf_pins $cellName/DEBOUNCE]
      set debouncePortDriver [find_bd_objs -thru_hier -relation connected_to $debouncePort]

      if { [string length $debouncePortDriver] > 0 } {
         set gpio_i_Driver [get_bd_pins -of  $debouncePortDriver -filter {DIR == I}]
         set left  [get_property LEFT  $gpio_i_Driver]
         set right [get_property RIGHT $gpio_i_Driver]

         if { [string length $left] > 0 && [string length $right] > 0 } {
            
            set width [expr ($left > $right) ? $left - $right + 1 : $right - $left + 1]
         } else {
            
            set width 1
         }
         
         set_property CONFIG.C_DWIDTH $width $ip
         
      }
   }

	# set li_portPin [get_bd_pins ${cellName}/l_gpio_o]
    # set li_portPinDriver [find_bd_objs -thru_hier -relation connected_to $li_portPin]
    
	# if { [string length $auto_width_portPinDriver] > 0 } {
	# 	set_property CONFIG.C_TRIMODE 1
	# } else {
	# 	set_property CONFIG.C_TRIMODE 0
	# }

   # update clock param
   set clk_pin [get_bd_pins $cellName/sample_clk]
   set clk_pin_driver [find_bd_objs -thru_hier -relation connected_to $clk_pin]
   set freq_hz [get_property CONFIG.FREQ_HZ $clk_pin_driver]
   
   if { [string length $freq_hz] > 0 } {
      
      set_property CONFIG.C_FREQ_CLK_SAMPLE_HZ [expr $freq_hz / 1.0] $ip
   } else {
      bd::send_msg -of $cellName -type ERROR -msg_id 1 -text ": post_propagate can't set C_FREQ_CLK_SAMPLE_HZ"
   }
   
}