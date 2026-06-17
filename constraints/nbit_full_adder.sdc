# Synopsys Design Constraints for nbit_full_adder
# [USER TO UPDATE] Replace each placeholder before running the flow.

set CLK_PORT        cin
set CLK_PERIOD_NS   {[USER TO UPDATE]}
set INPUT_DELAY_NS  {[USER TO UPDATE]}
set OUTPUT_DELAY_NS {[USER TO UPDATE]}
set DRIVE_CELL      {[USER TO UPDATE]}
set OUTPUT_LOAD     {[USER TO UPDATE]}

create_clock -name clk_virtual -period $CLK_PERIOD_NS [get_ports $CLK_PORT]
set_input_delay  $INPUT_DELAY_NS  -clock clk_virtual [all_inputs]
set_output_delay $OUTPUT_DELAY_NS -clock clk_virtual [all_outputs]
set_driving_cell -lib_cell $DRIVE_CELL [all_inputs]
set_load $OUTPUT_LOAD [all_outputs]
