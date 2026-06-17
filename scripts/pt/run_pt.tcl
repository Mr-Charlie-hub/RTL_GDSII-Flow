# PrimeTime static timing analysis script

# [USER TO UPDATE] Set search and library paths for your environment.
set USER_SEARCH_PATH {[USER TO UPDATE]}
set TARGET_LIBRARY   {[USER TO UPDATE]}

# Configure library and design lookup paths.
set search_path    [list ./results/netlist $USER_SEARCH_PATH]
set target_library [list $TARGET_LIBRARY]
set link_path      [concat * $target_library]

# Read synthesized netlist and resolve design hierarchy.
read_verilog ./results/netlist/nbit_full_adder_syn.v
current_design nbit_full_adder
link_design nbit_full_adder

# Load constraints and extracted parasitics.
read_sdc ./results/netlist/nbit_full_adder_syn.sdc
read_parasitics ./results/spef/nbit_full_adder.spef

# Update timing graph and write setup/hold/QoR/power reports.
update_timing
report_timing -max_paths 50 > ./reports/timing/pt_setup_timing.rpt
report_timing -delay_type min -max_paths 50 > ./reports/timing/pt_hold_timing.rpt
report_qor > ./reports/qor/pt_qor.rpt
report_power > ./reports/timing/pt_power.rpt

# Export SDF for downstream verification/signoff handoff.
write_sdf ./results/sdf/nbit_full_adder.sdf
