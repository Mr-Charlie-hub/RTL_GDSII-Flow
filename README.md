# RTL_GDSII-Flow: Parameterized N-bit Full Adder (ASIC Implementation)

This repository presents a complete **RTL-to-GDSII ASIC implementation flow** for a parameterized N-bit Full Adder using **Synopsys Design Compiler, ICC2, and PrimeTime**.

It is structured as a portfolio-quality project for recruiters and VLSI hiring managers to review practical execution of front-end and back-end digital ASIC implementation.

---

## Project Overview

The project demonstrates how synthesizable RTL is transformed into physical design outputs through standard ASIC implementation stages:

- RTL Design (parameterized Verilog)
- Logic Synthesis (DC)
- Floorplanning (ICC2)
- Placement (ICC2)
- Clock Tree Synthesis (ICC2)
- Routing (ICC2)
- Static Timing Analysis (PrimeTime)
- GDSII generation and signoff collateral export

See detailed overview in:
- `/home/runner/work/RTL_GDSII-Flow/RTL_GDSII-Flow/docs/project_overview.md`
- `/home/runner/work/RTL_GDSII-Flow/RTL_GDSII-Flow/docs/design_flow.md`

---

## Repository Structure

```text
RTL_GDSII-Flow/
├── README.md
├── rtl/
│   └── nbit_full_adder.v
├── constraints/
│   └── nbit_full_adder.sdc
├── scripts/
│   ├── dc/
│   │   └── run_dc.tcl
│   ├── icc2/
│   │   └── run_icc2.tcl
│   └── pt/
│       └── run_pt.tcl
├── flow/
│   ├── synthesis/
│   ├── floorplanning/
│   ├── placement/
│   ├── cts/
│   ├── routing/
│   └── signoff/
├── reports/
│   ├── synthesis/
│   ├── floorplanning/
│   ├── placement/
│   ├── cts/
│   ├── routing/
│   ├── timing/
│   ├── qor/
│   └── templates/
│       ├── area_report_template.md
│       ├── power_report_template.md
│       ├── timing_report_template.md
│       ├── utilization_report_template.md
│       └── qor_report_template.md
├── results/
│   ├── netlist/
│   ├── def/
│   ├── gds/
│   ├── sdf/
│   └── spef/
└── docs/
    ├── project_overview.md
    └── design_flow.md
```

---

## Design Flow (RTL to GDSII)

1. **Synthesis**: Compile RTL into gate-level netlist and generate area/power/timing reports.
2. **Floorplanning**: Initialize die/core and utilization targets.
3. **Placement**: Place cells and optimize timing/congestion.
4. **Clock Tree Synthesis**: Build and optimize clock distribution network.
5. **Routing**: Route signal/clock nets and fix post-route violations.
6. **Timing Analysis**: Run PrimeTime setup/hold and QoR analysis.
7. **GDSII Generation**: Export final physical layout and signoff artifacts.

---

## Synopsys Script Entry Points

- DC: `/home/runner/work/RTL_GDSII-Flow/RTL_GDSII-Flow/scripts/dc/run_dc.tcl`
- ICC2: `/home/runner/work/RTL_GDSII-Flow/RTL_GDSII-Flow/scripts/icc2/run_icc2.tcl`
- PrimeTime: `/home/runner/work/RTL_GDSII-Flow/RTL_GDSII-Flow/scripts/pt/run_pt.tcl`

Each script includes inline comments and explicit **[USER TO UPDATE]** fields for environment-specific values.

---

## Report and Result Placeholders

Use the templates in `reports/templates/` to record:
- Area
- Power
- Timing
- Utilization
- QoR

Required user-updated placeholders include:
- Timing values: **[USER TO UPDATE]**
- Area values: **[USER TO UPDATE]**
- Power values: **[USER TO UPDATE]**
- Screenshots/figures: **[USER TO UPDATE]**
- Final achieved metrics: **[USER TO UPDATE]**

---

## Skills Demonstrated

- ASIC RTL Design (parameterized Verilog)
- ASIC Physical Design (floorplanning, placement, CTS, routing)
- Static Timing Analysis and QoR interpretation
- Synopsys Tool Flow: Design Compiler, ICC2, PrimeTime
- Report-driven optimization mindset for implementation closure

---

## Project Learnings (Portfolio)

- Built a structured and scalable RTL-to-GDSII flow for a reusable arithmetic block.
- Learned stage-wise dependencies between logical synthesis and physical implementation.
- Practiced timing closure methodology across pre-layout and post-route analysis.
- Established a documentation and reporting format suitable for team review and hiring evaluation.
- Added reusable script and report templates to accelerate future ASIC blocks.

---

## User Update Checklist

- [ ] Replace all **[USER TO UPDATE]** entries in SDC/TCL/report templates.
- [ ] Add tool logs and generated reports under the corresponding `reports/*` folders.
- [ ] Add final implementation outputs under `results/*` folders.
- [ ] Insert project screenshots/plots in `docs/` and reference them here.
- [ ] Summarize final QoR metrics in this README using **[USER TO UPDATE]** placeholders until validated.
