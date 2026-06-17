# ICC2 physical design script for nbit_full_adder

# [USER TO UPDATE] Fill in technology/cell library references.
set REFERENCE_LIB   [list {[USER TO UPDATE]}]
set TECH_FILE       {[USER TO UPDATE]}
set CORE_UTIL       {[USER TO UPDATE]}
set CORE_OFFSET     {[USER TO UPDATE]}

# Create ICC2 library and load synthesized netlist + constraints.
create_lib nbit_full_adder_lib -technology $TECH_FILE -ref_libs $REFERENCE_LIB
read_verilog ./results/netlist/nbit_full_adder_syn.v
read_sdc ./results/netlist/nbit_full_adder_syn.sdc
link_block

# Build initial floorplan and capture utilization snapshot.
initialize_floorplan -core_utilization $CORE_UTIL -core_offset $CORE_OFFSET
create_placement -floorplan
report_utilization > ./reports/floorplanning/floorplan_utilization.rpt

# Place standard cells and optimize placement QoR.
place_opt
report_qor > ./reports/placement/place_qor.rpt

# Synthesize and optimize the clock tree.
clock_opt
report_clock_tree > ./reports/cts/clock_tree.rpt

# Perform routing and capture post-route timing/power.
route_auto
route_opt
report_timing > ./reports/routing/post_route_timing.rpt
report_power  > ./reports/routing/post_route_power.rpt

# Export physical implementation outputs.
write_def ./results/def/nbit_full_adder.def
write_gds -hierarchy -output ./results/gds/nbit_full_adder.gds
