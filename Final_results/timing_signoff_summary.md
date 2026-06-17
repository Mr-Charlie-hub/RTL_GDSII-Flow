# Post-Routing Timing Sign-off Summary

**Design:** 4-bit Full Adder (full_adder)  
**Tool:** Synopsys IC Compiler II — `report_global_timing`  
**Tool Version:** V-2023.12-SP4  
**Date Run:** Sun Oct 19 09:32:33 2025  

---

## Sign-off Result

```
Report : global timing
         -format { narrow }
Design : full_adder
Version: V-2023.12-SP4
Date   : Sun Oct 19 09:32:33 2025

No setup violations found.

No hold violations found.
```

**Status: TIMING CLOSED ✅**

---

## Interpretation

| Check | Result | Meaning |
|---|---|---|
| Setup (max timing) | PASS — No violations | All data paths settle before the capturing clock edge |
| Hold (min timing) | PASS — No violations | No data path is so fast that it creates a hold violation at the next flip-flop |

---

## Context

This report was generated after the full physical design flow (floorplanning → placement → power planning → CTS → routing) was completed in ICC2. At this stage, the design has actual routed wire parasitics (resistance and capacitance from metal interconnects), making this a high-confidence timing estimate.

A clean sign-off report at this stage — with no setup violations and no hold violations — confirms that:

1. The design will function correctly at the target clock frequency under the analyzed timing conditions
2. The design is ready for downstream physical verification (DRC/LVS full sign-off, GDSII export)
3. The tape-out package can be prepared

---

## Notes

- This sign-off was performed using ICC2's internal STA engine via `report_global_timing`
- In a full industrial flow, this result would typically also be cross-checked using Synopsys PrimeTime with an extracted SPEF (Standard Parasitic Exchange Format) file for the highest-accuracy sign-off
- The tool also reported **10 nets with Max Trans violations** and **10 Max Trans violations** prior to sign-off (visible in Figure 14 of the original report), which would normally require additional investigation in a production flow

---

*Source: Figure 14 — "Report of the timing after routing" in the workshop submission report.*
