# Physical Design Stages — ICC2 Flow Notes

## Overview

Physical design is the process of converting a gate-level netlist (logical description) into a physical layout (geometric description on silicon layers). This document covers each stage of the physical design flow as performed in IC Compiler II (ICC2) during the workshop.

---

## Stage 1: Floorplanning

**Goal:** Define the physical shape and area of the chip and the locations of I/O pads.

**Key decisions made:**
- **Die area:** The total silicon area allocated for the chip (including I/O ring)
- **Core area:** The inner region where standard cells and macros are placed
- **Utilization:** The fraction of core area occupied by standard cells
- **I/O pad placement:** Pads placed at the periphery as per the pin assignment

**Outputs:**
- A DEF (Design Exchange Format) file with die/core boundary and I/O pad locations

**Relation to Figure 7 in report:**  
Figure 7 shows the floorplan in ICC2 with cells and pins placed — the core boundary is visible along with the I/O pad ring.

---

## Stage 2: Placement

**Goal:** Legally place all standard cells within the core area to minimize wirelength and congestion.

**Process:**
- The placer reads the floorplan DEF and the gate-level netlist
- It assigns each standard cell a (x, y) coordinate within the core, snapped to a placement grid aligned with power rail pitch
- The placer optimizes placement to reduce estimated wirelength (which directly impacts routing congestion and timing)

**Post-placement checks:**
- Timing was re-evaluated with estimated wire delays (Figure 10 shows slack being met at both max and min analysis)
- Power/Ground (PG) connectivity was verified — all cell VDD/VSS pins must be on a power rail

**Relation to Figures 9 and 10 in report:**  
Figure 9 shows the placed standard cells in ICC2. Figure 10 shows the timing report confirming slack is met post-placement.

---

## Stage 3: Power Planning

**Goal:** Build a robust power distribution network (PDN) that delivers stable VDD and VSS to every cell.

**Three levels of the PDN hierarchy:**

### Level 1 — Core Power Ring
- Wide VDD and VSS metal rings placed just inside the core boundary
- Connected directly to VDD and VSS I/O pads
- Carries the bulk current into the core

### Level 2 — Power Mesh
- A grid of horizontal and vertical metal straps spanning the core interior
- Connected to the core power ring at the periphery
- Distributes current from the ring into the interior of the core

### Level 3 — Standard Cell Rails
- Fine-pitch VDD and VSS lines running horizontally within each standard cell row
- Connected to the mesh above via vias
- Provide local power to individual standard cell pins

**Relation to Figure 8 in report:**  
Figure 8(a) shows the core power ring, 8(b) shows the power mesh interconnect, and 8(c) shows the standard cell VDD/VSS rails.

---

## Stage 4: Clock Tree Synthesis (CTS)

**Goal:** Insert clock buffers and inverters to distribute the clock signal with minimal skew and latency to all sequential elements.

**Why CTS is needed:**
- Without buffering, a single clock driver cannot drive the capacitive load of hundreds of flip-flop clock pins simultaneously
- Wire delay from the clock source to distant flip-flops creates clock skew (different arrival times)
- Excessive skew degrades both setup timing (at the receiving flip-flop) and hold timing (at the capturing flip-flop)

**CTS process:**
- ICC2's CTS engine analyzes all flip-flop clock pins and builds a balanced H-tree or buffered tree topology
- Buffers and inverters are sized and inserted to equalize delay from the clock source to every flip-flop
- Clock Uncertainty (modeling residual skew and jitter) is applied during timing analysis

**Targets met:**
- Minimal clock skew across the design
- Clock latency within specification
- Setup and hold margins maintained post-CTS

**Relation to Figure 11 in report:**  
Figure 11 shows the CTS result in ICC2 with the clock tree visible.

---

## Stage 5: Routing

**Goal:** Create metal interconnects to physically connect all cell pins as defined by the netlist.

**Two-phase routing process:**

### Global Routing
- Divides the layout into a coarse grid of routing tiles (G-cells)
- Assigns each net to a sequence of G-cells — a rough path through the chip
- Identifies potential congestion hotspots
- Does not assign specific metal tracks or vias

### Detail Routing
- Assigns specific metal layer tracks, wire widths, and via types for each segment
- Resolves conflicts where multiple nets want to use the same track
- Ensures all DRC (Design Rule Check) constraints are respected:
  - Minimum wire width per layer
  - Minimum wire spacing between nets
  - Via enclosure rules
  - Maximum wire length rules (antenna rules)

**Sign-off checks after routing:**
- **DRC:** No design rule violations — the layout is manufacturable
- **LVS:** Layout vs. Schematic equivalence — every connection in the physical layout matches the logical netlist

**Relation to Figure 12 in report:**  
Figure 12 shows the fully routed layout in ICC2 with all metal interconnects visible.

---

## Stage 6: GDSII Export

**Goal:** Export the verified, routed layout in GDSII format for delivery to the foundry.

**What GDSII contains:**
- Polygon shapes on each process layer (diffusion, polysilicon, metal 1–N, via 1–N, contacts)
- Cell hierarchy mirroring the logical design hierarchy
- Layer names mapped to process GDS layer numbers

**Relation to Figure 13 in report:**  
Figure 13 shows the final GDSII view of the 4-bit Full Adder layout as displayed in ICC2.

---

## Post-Routing Timing Sign-off

**Tool:** ICC2 `report_global_timing` (and optionally PrimeTime with extracted SPEF parasitics)

**Result from this design:**

```
Report : global timing
Design : full_adder
Version: V-2023.12-SP4
Date   : Sun Oct 19 09:32:33 2025

No setup violations found.
No hold violations found.
```

This output (Figure 14 in the report) confirms the design is **timing-closed** — all setup and hold constraints are met with the actual routed parasitic delays, and the design is ready for tape-out.
