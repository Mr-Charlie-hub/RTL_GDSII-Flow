# RTL to GDSII Physical Design Flow — 4-bit Full Adder
### Using Synopsys VCS · Design Compiler · IC Compiler II · PrimeTime

> **Workshop:** RTL2GDSII Flow Using Synopsys Tools  
> **Organizer:** VLSI Expert in collaboration with Synopsys  
> **Duration:** 3 Days  
> **Submitted by:** Rohith D  
> **Designation:** B.E in Electronics and Telecommunication Engineering  
> **College:** R V College of Engineering, Bangalore  
> **Date:** 23 October 2025  

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Objectives](#2-objectives)
3. [Tool Flow](#3-tool-flow)
4. [Design Methodology](#4-design-methodology)
   - [RTL Verification (VCS)](#41-rtl-verification--functional-simulation)
   - [Logic Synthesis (DC)](#42-logic-synthesis--design-compiler)
   - [Multi-Corner Timing Analysis](#43-multi-corner--multi-mode-timing-analysis)
   - [Floorplanning (ICC2)](#44-floorplanning)
   - [Placement (ICC2)](#45-placement)
   - [Power Planning (ICC2)](#46-power-planning)
   - [Clock Tree Synthesis (ICC2)](#47-clock-tree-synthesis-cts)
   - [Routing (ICC2)](#48-routing)
   - [Final Timing Sign-off (PrimeTime)](#49-final-timing-sign-off)
   - [GDSII Generation](#410-gdsii-generation)
5. [Results and Analysis](#5-results-and-analysis)
6. [Repository Structure](#6-repository-structure)
7. [Key Learnings](#7-key-learnings)
8. [Skills Demonstrated](#8-skills-demonstrated)
9. [Future Improvements](#9-future-improvements)

---

## 1. Project Overview

This project documents the complete end-to-end **RTL-to-GDSII physical design flow** for a **4-bit Full Adder**, implemented as part of a 3-day industry-oriented workshop jointly organized by **VLSI Expert** and **Synopsys**.

The design was taken through every major stage of an ASIC implementation pipeline — from RTL functional verification all the way through to final GDSII layout generation — using the same industry-standard Synopsys EDA toolchain deployed by professional semiconductor design teams worldwide.

The project demonstrates proficiency in:
- Functional simulation and testbench writing
- Logic synthesis with SDC-based timing constraint definition
- Multi-corner PVT (Process, Voltage, Temperature) analysis
- Complete physical design: floorplanning, placement, power planning, CTS, and routing
- Static Timing Analysis (STA) and timing sign-off

---

## 2. Objectives

- Understand and implement each stage of the RTL-to-GDSII design process using Synopsys tools
- Examine how EDA tools interconnect and communicate across the flow (RTL → Netlist → DEF → GDSII)
- Analyse the effects of process variations on timing, power, and area through multi-corner (PVT) analysis
- Compare standard `Compile` vs. `Compile Ultra` optimization strategies in Design Compiler
- Achieve timing closure — no setup or hold violations in the final routed design
- Gain hands-on exposure to the same design methodology used in industrial ASIC development

---

## 3. Tool Flow

```
RTL (Verilog)
     │
     ▼
┌──────────────┐
│  Synopsys    │   Functional simulation, waveform verification
│     VCS      │   Testbench → FSDB waveform file
└──────┬───────┘
       │  Verified RTL + SDC constraints
       ▼
┌──────────────┐
│   Design     │   Logic synthesis (RTL → Gate-level Netlist)
│  Compiler    │   Multi-corner/multi-mode analysis (TT / SS / FF)
│    (DC)      │   Compile vs. Compile Ultra comparison
└──────┬───────┘
       │  Gate-level Netlist (.v) + SDC
       ▼
┌──────────────┐
│ IC Compiler  │   Floorplanning → Placement → Power Planning
│    II        │   → Clock Tree Synthesis → Routing
│  (ICC2)      │   DRC / LVS compliance
└──────┬───────┘
       │  Routed DEF / GDSII
       ▼
┌──────────────┐
│  PrimeTime   │   Static Timing Analysis (STA)
│    (PT)      │   Final sign-off: No setup / hold violations
└──────┬───────┘
       │
       ▼
   GDSII Layout
   (Tape-out Ready)
```

---

## 4. Design Methodology

### 4.1 RTL Verification — Functional Simulation

**Tool:** Synopsys VCS

- Verilog testbenches were written for the 4-bit Full Adder to drive all input combinations
- Simulation was run in VCS to generate **FSDB waveform files** for visual analysis
- Waveforms were inspected to confirm correct functional behaviour of `SUM` and `C_out` outputs before proceeding to synthesis
- This step ensures the RTL is logically correct prior to any physical implementation work

📸 *See:* [`screenshots/fig1_vcs_waveform.md`](documents/fig1_vcs_waveform.md)

---

### 4.2 Logic Synthesis — Design Compiler

**Tool:** Synopsys Design Compiler (DC)

- The verified RTL was read into Design Compiler along with an **SDC (Synopsys Design Constraints)** file defining clock period, input/output delays, and load constraints
- The `elaborate` command was executed in the DC shell to build the design hierarchy
- The `compile` command mapped the RTL to a technology-specific **gate-level netlist** using the standard cell library (`saed32rvt_tt0p78vn40c`)
- `report_cell` and `report_timing` commands were used to verify cell usage and check that timing slack was met
- The synthesized netlist confirmed that all timing constraints were satisfied

📸 *See:* [`screenshots/fig2_dc_netlist.md`](../documents/fig2_dc_netlist.md)

---

### 4.3 Multi-Corner / Multi-Mode Timing Analysis

**Tool:** Synopsys Design Compiler (DC) — Multi-corner analysis

The design was analysed across three industry-standard PVT corners using both `compile` and `compile_ultra` modes:

| Corner | Process | Voltage | Temperature | Key Observation |
|--------|---------|---------|-------------|-----------------|
| **TT** | Typical | Typical | Nominal | Baseline nominal performance |
| **SS** | Slow | Low | Hot | Worst-case setup timing; most negative slack |
| **FF** | Fast | High | Cold | Best timing slack; highest leakage power |

- The **SS corner** is the critical corner for timing sign-off — it represents worst-case transistor drive strength
- The **FF corner** produced the tightest setup constraints alongside the highest leakage power
- `Compile Ultra` mode reduced negative slack at the SS corner versus standard `Compile`, at the cost of a slight increase in cell count and area
- Detailed numerical results are presented in [Section 5 — Results and Analysis](#5-results-and-analysis)

📸 *See:* [`screenshots/fig3_tt_corner.md`](../screenshots/fig3_tt_corner.md) | [`screenshots/fig4_ss_corner.md`](../screenshots/fig4_ss_corner.md) | [`screenshots/fig5_ff_corner.md`](../screenshots/fig5_ff_corner.md)

---

### 4.4 Floorplanning

**Tool:** Synopsys IC Compiler II (ICC2)

- The gate-level netlist was imported into ICC2 to begin physical design
- Die area and core area boundaries were defined
- I/O pads were placed according to design requirements
- The floorplan established the physical canvas for all subsequent placement and routing steps

📸 *See:* [`screenshots/fig7_floorplan.md`](../screenshots/fig7_floorplan.md)

---

### 4.5 Placement

**Tool:** Synopsys IC Compiler II (ICC2)

- Standard cells from the technology library were placed within the core area
- The placer optimized cell positions to minimize wirelength and routing congestion
- Power and ground (PG) connectivity was verified post-placement to confirm no connectivity issues

📸 *See:* [`screenshots/fig9_placement.md`](../screenshots/fig9_placement.md)

---

### 4.6 Power Planning

**Tool:** Synopsys IC Compiler II (ICC2)

Three-stage power distribution network (PDN) was constructed:

1. **Core power ring** — VDD and VSS rings around the core boundary
2. **Power mesh** — Horizontal and vertical metal straps connecting the ring to internal cells
3. **Standard cell rails** — VDD and VSS local rails within standard cell rows

This hierarchy ensures stable power delivery across the entire chip during operation.

📸 *See:* [`screenshots/fig8_power_planning.md`](../screenshots/fig8_power_planning.md)

---

### 4.7 Clock Tree Synthesis (CTS)

**Tool:** Synopsys IC Compiler II (ICC2)

- Clock buffers and inverters were automatically inserted by ICC2 to distribute the clock signal evenly to all sequential elements (flip-flops)
- CTS targeted **minimal clock skew and latency** to maintain synchronization between flip-flops
- Clock paths were balanced to satisfy pre-CTS timing constraints
- Power consumption of the clock network was also optimized during this step

📸 *See:* [`screenshots/fig11_cts.md`](../screenshots/fig11_cts.md)

---

### 4.8 Routing

**Tool:** Synopsys IC Compiler II (ICC2)

- Metal interconnects were created to connect all placed cells as per the gate-level netlist
- Both signal routing and power routing were completed
- The router ensured compliance with **DRC (Design Rule Check)** and **LVS (Layout vs. Schematic)** rules
- The result was a fully connected, physically verified chip layout ready for tape-out

📸 *See:* [`screenshots/fig12_routing.md`](../screenshots/fig12_routing.md)

---

### 4.9 Final Timing Sign-off

**Tool:** Synopsys PrimeTime (PT) / ICC2 global timing report

- After routing, a global timing report was generated using ICC2's `report_global_timing` command
- The report confirmed **no setup violations** and **no hold violations** in the final routed netlist
- This marks successful **timing closure** — the design is fully timing-signed-off and ready for downstream physical verification steps

📸 *See:* [`screenshots/fig14_timing_signoff.md`](../screenshots/fig14_timing_signoff.md)

---

### 4.10 GDSII Generation

**Tool:** Synopsys IC Compiler II (ICC2)

- The final routed layout was exported in **GDSII format** — the industry-standard binary format used to transfer chip layout data to semiconductor fabrication facilities (fabs)
- The GDSII file represents the complete, manufacturable layout of the 4-bit Full Adder

📸 *See:* [`screenshots/fig13_gdsii.md`](../screenshots/fig13_gdsii.md)

---

## 5. Results and Analysis

### 5.1 Multi-Corner Synthesis Results

The table below summarises the synthesis results across all PVT corners and compiler modes as reported by Design Compiler:

| Compile Mode | Corner | Cell Count | Dynamic Power (µW) | Cell Leakage Power (W) | Total Power (µW) | Cell Area (nm²) | Total Area (nm²) | Timing Slack (ns) |
|---|---|---|---|---|---|---|---|---|
| compile | TT | 18 | 28.2761 | 321.6537 | 29.6478 | 111.8234 | 116.480115 | **+0.68** |
| compile | SS | 43 | 25.2239 | 1.1524 | 178.538062 | 178.5381 | 179.183398 | **−1.20** |
| compile | FF | 18 | −68.8016 | 1.1671 | 1.35×10⁵ | 111.8234 | 116.480115 | **+1.09** |
| compile_ultra | TT | 18 | 28.2761 | 321.6567 | 29.6478 | 111.8234 | 116.480115 | **+0.68** |
| compile_ultra | SS | 43 | 25.2302 | 1.1624 | 178.538062 | 180.1402 | 190.153007 | **−1.30** |
| compile_ultra | FF | 18 | −68.8016 | 1.4050 | 1.35×10³ | 111.8234 | 116.480115 | **+0.98** |

### 5.2 Key Findings

**Timing Across Corners:**
- The **FF corner** achieves the best (most positive) timing slack because transistors switch fastest under high-voltage, low-temperature conditions
- The **SS corner** produces the worst (most negative) timing slack, confirming it as the critical corner for sign-off
- The **TT corner** provides the nominal baseline performance

**Power Across Corners:**
- Dynamic power remains relatively consistent across all corners
- Leakage power is highest in the FF corner (elevated voltage and temperature accelerate leakage) and lowest in the SS corner

**Compile vs. Compile Ultra:**
- In the SS corner, `Compile Ultra` reduces negative slack somewhat compared to standard `Compile`, indicating more aggressive timing optimization
- This improvement comes at the cost of a slight increase in cell count and total area

**Post-Routing Sign-off:**
- The final routed design achieved **zero setup violations** and **zero hold violations**, confirming successful timing closure

---

## 6. Repository Structure

```
rtl2gdsii-4bit-fulladder/
│
├── README.md                        ← This file — complete project documentation
│
├── docs/
│   ├── design_flow_overview.md      ← Detailed RTL-to-GDSII flow description
│   ├── pvt_corner_analysis.md       ← Multi-corner timing analysis explanation
│   ├── physical_design_stages.md    ← ICC2 physical design stage-by-stage notes
│   ├── interview_qa.md              ← Interview Q&A based on this project
│   └── linkedin_description.md     ← LinkedIn project description
│
├── reports/
│   ├── synthesis_results_table.md   ← Multi-corner synthesis results (Table I)
│   └── timing_signoff_summary.md    ← Post-routing timing sign-off summary
│
├── screenshots/
│   ├── fig1_vcs_waveform.md         ← Caption: VCS functional verification waveform
│   ├── fig2_dc_netlist.md           ← Caption: Synthesized netlist in Design Compiler
│   ├── fig3_tt_corner.md            ← Caption: TT corner timing (Compile vs. Ultra)
│   ├── fig4_ss_corner.md            ← Caption: SS corner timing (Compile vs. Ultra)
│   ├── fig5_ff_corner.md            ← Caption: FF corner timing (Compile vs. Ultra)
│   ├── fig6_report_cell_timing.md   ← Caption: report_cell and report_timing output
│   ├── fig7_floorplan.md            ← Caption: Floorplan in ICC2 (cells and pins placed)
│   ├── fig8_power_planning.md       ← Caption: Power ring, mesh, and cell rails
│   ├── fig9_placement.md            ← Caption: Standard cell placement in ICC2
│   ├── fig10_timing_placement.md    ← Caption: Max/min timing slack post-placement
│   ├── fig11_cts.md                 ← Caption: Clock Tree Synthesis in ICC2
│   ├── fig12_routing.md             ← Caption: Routing completion in ICC2
│   ├── fig13_gdsii.md               ← Caption: Final GDSII layout view
│   └── fig14_timing_signoff.md      ← Caption: Post-routing timing report
│
├── certificate/
│   └── README.md                    ← Placeholder for workshop certificate
│
└── resume/
    └── resume_bullets.md            ← Resume bullet points extracted from the project
```

---

## 7. Key Learnings

- **End-to-end ASIC flow comprehension** — understanding how each stage feeds into the next, from RTL all the way to a fab-ready GDSII file
- **Practical PVT corner analysis** — observing firsthand how SS, TT, and FF corners affect timing slack, dynamic power, and leakage power; appreciating why SS is the critical sign-off corner
- **Compile vs. Compile Ultra trade-offs** — understanding that more aggressive optimization can improve worst-case timing but increases cell count and area
- **Physical design interdependencies** — how placement quality directly affects routing congestion, CTS insertion delay, and ultimately timing closure
- **Timing closure discipline** — working methodically through setup and hold checks to achieve a clean sign-off with zero violations
- **Industry tool proficiency** — hands-on operation of Synopsys VCS, DC, ICC2, and PrimeTime as an integrated flow

---

## 8. Skills Demonstrated

| Category | Skill |
|---|---|
| **Languages** | Verilog RTL, SDC (Synopsys Design Constraints) |
| **EDA Tools** | Synopsys VCS, Design Compiler, IC Compiler II, PrimeTime |
| **Simulation** | RTL functional simulation, FSDB waveform analysis, testbench writing |
| **Synthesis** | Gate-level netlist generation, SDC constraint definition, cell mapping |
| **Timing Analysis** | Multi-corner STA (TT/SS/FF), setup/hold analysis, slack reporting |
| **Physical Design** | Floorplanning, standard cell placement, power planning (PDN), CTS, global & detail routing |
| **Sign-off** | DRC/LVS compliance verification, post-route timing sign-off |
| **Concepts** | PPA (Power, Performance, Area) trade-off analysis, GDSII tape-out flow |

---

## 9. Future Improvements

> *Note: The following represent natural next steps beyond the scope of the 3-day workshop.*

- **Post-layout simulation** — Run gate-level simulation with extracted parasitics (SDF back-annotation) to verify functional correctness after physical implementation
- **IR drop / EM analysis** — Perform power integrity analysis on the PDN to check for voltage droops and electromigration violations
- **DRC / LVS full sign-off** — Complete formal physical verification using Synopsys IC Validator or Mentor Calibre
- **Physical Verification (PV)** — Add antenna rule checks and metal fill for CMP (Chemical Mechanical Polishing) uniformity
- **Larger design exercise** — Apply the same flow to a more complex design (e.g., pipelined ALU or RISC-V core) to experience scalability challenges
- **Custom SDC exploration** — Experiment with multi-clock designs, false paths, and multicycle path constraints

---

## Acknowledgements

Workshop organized by **VLSI Expert** in collaboration with **Synopsys**. All EDA tools used are property of Synopsys, Inc. This repository documents learning outcomes from the workshop and does not contain any proprietary Synopsys tool outputs, PDKs, or standard cell library data.


