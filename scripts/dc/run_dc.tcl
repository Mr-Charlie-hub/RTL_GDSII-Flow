# Design Compiler synthesis script for parameterized N-bit full adder

# [USER TO UPDATE] Configure search paths and technology libraries.
set USER_SEARCH_PATH {[USER TO UPDATE]}
set TARGET_LIBRARY   {[USER TO UPDATE]}

# Define where DC should look for RTL/constraints/libs.
set_app_var search_path [list ./rtl ./constraints $USER_SEARCH_PATH]
set_app_var target_library [list $TARGET_LIBRARY]
set_app_var link_library   [concat * $target_library]

# Read RTL, set top module, and resolve references.
read_verilog ./rtl/nbit_full_adder.v
current_design nbit_full_adder
link

# Read timing and IO constraints.
source ./constraints/nbit_full_adder.sdc

# Check design consistency and run high-effort synthesis.
check_design
compile_ultra

# Write synthesized design databases and constraints.
write -format ddc     -hierarchy -output ./results/netlist/nbit_full_adder.ddc
write -format verilog -hierarchy -output ./results/netlist/nbit_full_adder_syn.v
write_sdc ./results/netlist/nbit_full_adder_syn.sdc

# Export key QoR reports for synthesis stage review.
report_qor    > ./reports/synthesis/dc_qor.rpt
report_area   > ./reports/synthesis/dc_area.rpt
report_power  > ./reports/synthesis/dc_power.rpt
report_timing > ./reports/synthesis/dc_timing.rpt
