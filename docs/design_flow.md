# ASIC Design Flow

## 1) Synthesis
- Input: `rtl/nbit_full_adder.v`, `constraints/nbit_full_adder.sdc`
- Tool: Synopsys Design Compiler
- Output: synthesized netlist and synthesis reports

## 2) Floorplanning
- Input: synthesized netlist, technology data
- Tool: Synopsys ICC2
- Output: floorplan database, utilization report

## 3) Placement
- Input: initialized floorplan
- Tool: Synopsys ICC2
- Output: placed design and QoR report

## 4) Clock Tree Synthesis (CTS)
- Input: placed design with clock definitions
- Tool: Synopsys ICC2
- Output: post-CTS database and clock tree report

## 5) Routing
- Input: post-CTS design
- Tool: Synopsys ICC2
- Output: routed DEF/GDSII and post-route reports

## 6) Timing Analysis
- Input: synthesized netlist, constraints, extracted parasitics
- Tool: Synopsys PrimeTime
- Output: setup/hold timing reports, power report, QoR report

## 7) GDSII Generation
- Final physical database export for manufacturing handoff.
- Replace run-specific values with **[USER TO UPDATE]** where needed.
