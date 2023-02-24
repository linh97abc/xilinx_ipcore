
proc init { cellpath otherInfo } {                                                                   
   bd::send_msg -of $cellpath -type INFO -msg_id 0 -text ": init ip clock_prescaler."
	set cell_handle [get_bd_cells $cellpath]

   # set auto param
   set paramList "C_FREQ_HZ"
   bd::mark_propagate_only $cell_handle $paramList                                                                                                      
}


proc pre_propagate {cellpath otherInfo } {                                                           
                                                                                                                                                                                                        
}


proc propagate {cellpath otherInfo } {                                                               
    bd::send_msg -of $cellpath -type INFO -msg_id 0 -text ": propagate ip debounce"
   set ip [get_bd_cells $cellpath]


   # update clock param
   set clk_pin [get_bd_pins $cellpath/aclk]
   set clk_out_pin [get_bd_pins $cellpath/out_clk]
   set freq_hz [get_property CONFIG.FREQ_HZ $clk_pin]

   set prescale [get_property CONFIG.C_PRESCALE $ip]
   set check_prescale [expr $prescale % 2]

   if { [expr $check_prescale] > 0 } {
        bd::send_msg -of $cellpath -type ERROR -msg_id 1 -text ": C_PRESCALE % 2 != 0"
        return
   }

   set outFreq_hz [expr $freq_hz / $prescale]

   if { [string length $freq_hz] > 0 } {
      set_property CONFIG.C_FREQ_HZ [expr $outFreq_hz] $ip
      set_property CONFIG.FREQ_HZ [expr $outFreq_hz] $clk_out_pin
   } else {
      bd::send_msg -of $cellpath -type ERROR -msg_id 1 -text ": post_propagate can't set C_FREQ_CLK_SAMPLE_HZ"
   }                                                                                                                                                                                                     
}
