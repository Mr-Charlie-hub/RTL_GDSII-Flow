# RTL-to-GDSII Design Flow — Detailed Overview

## Introduction

The RTL-to-GDSII flow is the end-to-end process by which a digital circuit described in hardware description language (HDL) is converted into a physical layout file that a semiconductor fabrication facility (fab) can manufacture onto silicon.

This document describes each stage of the flow as implemented during the workshop for the 4-bit Full Adder design.

---

## Stage 1: RTL Design and Functional Verification

**Tool:** Synopsys VCS

**What happens:**  
The starting point is a Verilog RTL description of the 4-bit Full Adder. Before any physical implementation work can begin, the RTL must be proven functionally correct through simulation.

**Activities performed:**
- Testbenches were written to exercise the full adder across a range of input combinations
- VCS compiled the RTL and testbench, and ran the simulation
- Output waveforms were captured in an FSDB (Fast Signal Database) file
- The waveforms were inspected to confirm that `SUM[3:0]` and `C_out` matched the expected truth table for a 4-bit full adder across all tested input vectors

**Why it matters:**  
Any functional bug caught here is trivial to fix in RTL. The same bug discovered post-synthesis or post-layout would require expensive re-synthesis or re-layout work.

---

## Stage 2: Logic Synthesis

**Tool:** Synopsys Design Compiler (DC)

**What happens:**  
The verified RTL is translated (synthesized) into a technology-mapped gate-level netlist — a network of standard cells (logic gates, flip-flops, buffers) from the target technology library.

**Activities performed:**
- The RTL source files were read into the DC shell
- An SDC (Synopsys Design Constraints) file was provided, specifying the clock period, input delays, output delays, and load constraints
- The `elaborate` command built the design hierarchy
- The `compile` command performed technology mapping against the standard cell library (`saed32rvt_tt0p78vn40c`)
- `report_cell` verified which cells were used in the mapped netlist
- `report_timing` confirmed that setup timing slack was positive (constraints met)

**Key output:**  
A gate-level netlist (`.v`) and an updated SDC file, which serve as inputs to the physical design flow.

**Optimization modes compared:**
- `compile` — standard optimization pass
- `compile_ultra` — more aggressive timing-driven optimization; can improve worst-case paths at the cost of higher cell count and area

---

## Stage 3: Multi-Corner and Multi-Mode Analysis

**Tool:** Synopsys Design Compiler (DC)

**What happens:**  
Real silicon does not operate at a single fixed set of conditions. Process variation (from manufacturing), supply voltage variation (from IR drop or regulator tolerance), and temperature variation (from operating environment) all affect transistor behaviour.

**Three PVT corners analysed:**

| Corner | Description | Effect on Timing |
|--------|-------------|-----------------|
| TT (Typical-Typical) | Nominal process, nominal voltage, room temperature | Baseline reference |
| SS (Slow-Slow) | Slow process, low voltage, high temperature | Slowest transistors — worst setup timing |
| FF (Fast-Fast) | Fast process, high voltage, low temperature | Fastest transistors — best setup, worst leakage |

**Why the SS corner matters most:**  
The SS corner represents the worst-case scenario for setup timing. If a design meets timing at SS, it will meet timing under all realistic operating conditions. This is why SS is the primary sign-off corner in most design flows.

**What was observed:**
- At the SS corner, the design showed negative timing slack, indicating that with standard `compile`, some timing paths did not meet the target clock period under worst-case conditions
- Switching to `compile_ultra` at the SS corner reduced (but did not fully eliminate) the negative slack, demonstrating the power of more aggressive optimization
- Cell count and area increased slightly under `compile_ultra` at the SS corner

---

## Stage 4: Physical Design — Floorplanning

**Tool:** Synopsys IC Compiler II (ICC2)

**What happens:**  
The gate-level netlist enters the physical design domain. The first step is floorplanning — defining the physical boundaries of the chip and specifying where major blocks and I/O pads will be located.

**Activities performed:**
- Die area and core area were defined
- I/O pads were placed at the periphery of the die as per design requirements
- The ratio of core area to die area (utilization) was set

**Why it matters:**  
A good floorplan reduces congestion in placement and routing, and minimizes the length of critical timing paths.

---

## Stage 5: Physical Design — Placement

**Tool:** Synopsys IC Compiler II (ICC2)

**What happens:**  
Standard cells are legally placed within the core area, with each cell snapped to a placement row aligned with the power rails.

**Activities performed:**
- ICC2's placer arranged the standard cells to minimize wirelength and routing congestion
- Post-placement, timing was checked (Figure 10 in the report shows slack met at both max and min analysis types)
- Power/Ground (PG) connectivity was verified — all cells were confirmed to be correctly connected to VDD and VSS

---

## Stage 6: Physical Design — Power Planning

**Tool:** Synopsys IC Compiler II (ICC2)

**What happens:**  
A power distribution network (PDN) is constructed to deliver stable VDD and VSS to every cell in the design.

**Three-level PDN hierarchy:**
1. **Core power ring** — Wide VDD and VSS rings around the core boundary, connected directly to I/O power pads
2. **Power mesh** — Horizontal and vertical metal straps spanning the core, connecting the ring to the interior
3. **Standard cell rails** — Fine-pitch VDD and VSS rails running within each standard cell row, connected to the mesh above

**Why it matters:**  
Insufficient power planning leads to IR drop (voltage sag) and electromigration failures. A well-designed PDN ensures every cell sees a supply voltage within its specified operating range.

---

## Stage 7: Physical Design — Clock Tree Synthesis (CTS)

**Tool:** Synopsys IC Compiler II (ICC2)

**What happens:**  
Clock signals must arrive at all flip-flops with minimal skew (timing difference between arrivals at different flip-flops). CTS inserts a balanced tree of buffers and inverters to achieve this.

**Activities performed:**
- ICC2's CTS engine inserted clock buffers and inverters to create a balanced clock distribution tree
- Clock skew and clock latency were minimized
- Timing constraints (setup and hold) were re-checked post-CTS

**Why it matters:**  
Excessive clock skew degrades setup and hold timing margins. CTS is essential for any synchronous design to function correctly at the target clock frequency.

---

## Stage 8: Physical Design — Routing

**Tool:** Synopsys IC Compiler II (ICC2)

**What happens:**  
Metal wires (interconnects) are laid out on the available metal layers to connect all cell pins as defined by the netlist.

**Activities performed:**
- Global routing established approximate routes for each net
- Detail routing assigned specific metal tracks and vias
- Both signal nets and power/ground nets were routed
- DRC (Design Rule Check) compliance was ensured — all wires observe minimum spacing, minimum width, and via enclosure rules
- LVS (Layout vs. Schematic) equivalence was maintained — the physical connectivity matches the logical netlist

**Output:**  
A fully routed layout ready for timing sign-off and GDSII export.

---

## Stage 9: Timing Sign-off

**Tool:** Synopsys PrimeTime (PT) / ICC2 report_global_timing

**What happens:**  
After routing, parasitic resistance and capacitance values of all metal wires are known. A final Static Timing Analysis (STA) is run with these extracted parasitics to verify that the design meets all timing constraints.

**Result:**
- **No setup violations found**
- **No hold violations found**

This confirms the design is **timing-closed** and ready for tape-out.

---

## Stage 10: GDSII Generation

**Tool:** Synopsys IC Compiler II (ICC2)

**What happens:**  
The final routed layout is exported to **GDSII format** (Graphic Design System II) — the binary file format used to transfer physical layout data to semiconductor fabrication facilities.

The GDSII file contains:
- All polygon shapes representing transistors, metal wires, vias, and contacts on every layer
- Layer information mapping each shape to its process layer
- Cell hierarchy of the design

The GDSII file, combined with a completed DRC/LVS sign-off, constitutes the **tape-out package** — the deliverable sent to the foundry for manufacturing.

---

## Summary

| Stage | Tool | Input | Output |
|---|---|---|---|
| RTL Simulation | VCS | Verilog RTL + Testbench | FSDB waveforms |
| Logic Synthesis | Design Compiler | RTL + SDC | Gate-level netlist |
| Multi-corner Analysis | Design Compiler | Netlist + SDC | Timing/power/area reports |
| Floorplanning | ICC2 | Gate-level netlist + LEF/DEF | Floorplan DEF |
| Placement | ICC2 | Floorplan DEF | Placed DEF |
| Power Planning | ICC2 | Placed DEF | PDN DEF |
| CTS | ICC2 | PDN DEF | CTS DEF |
| Routing | ICC2 | CTS DEF | Routed DEF |
| Timing Sign-off | PrimeTime / ICC2 | Routed DEF + SPEF | STA reports |
| GDSII Export | ICC2 | Routed DEF | GDSII file |
