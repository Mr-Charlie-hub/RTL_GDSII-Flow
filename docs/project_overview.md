# Project Overview: Parameterized N-bit Full Adder RTL-to-GDSII Flow

This repository demonstrates an end-to-end ASIC implementation flow for a parameterized N-bit Full Adder using Synopsys Design Compiler (DC), IC Compiler II (ICC2), and PrimeTime (PT).

The objective is to transform synthesizable RTL into foundry-ready physical outputs while tracking quality-of-results (QoR) across area, power, timing, and utilization.

## Flow Stages

1. **RTL Design**: Implement configurable N-bit adder logic in Verilog.
2. **Synthesis (DC)**: Map RTL to standard cells and generate gate-level netlist.
3. **Floorplanning (ICC2)**: Define core boundaries, utilization targets, and macro/IO strategy.
4. **Placement (ICC2)**: Place standard cells and optimize for congestion/timing.
5. **Clock Tree Synthesis (ICC2)**: Build balanced clock distribution for skew and latency control.
6. **Routing (ICC2)**: Complete global/detail routing and close physical constraints.
7. **Timing Signoff (PT)**: Perform setup/hold and QoR analysis with extracted parasitics.
8. **Tapeout Outputs**: Deliver GDSII, DEF, SDF, SPEF, and final reports.

All project-specific values are intentionally represented as **[USER TO UPDATE]** placeholders.
