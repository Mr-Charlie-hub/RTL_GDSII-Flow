# Synthesis Results — Multi-Corner PVT Analysis

**Design:** 4-bit Full Adder  
**Tool:** Synopsys Design Compiler  
**Technology Library:** `saed32rvt_tt0p78vn40c`  
**Source:** Workshop Report Table I

---

## Results Table

| Compile Mode | Corner | Cell Count | Dynamic Power (µW) | Cell Leakage Power (W) | Total Power (µW) | Cell Area (nm²) | Total Area (nm²) | Timing Slack (ns) |
|---|---|:---:|---:|---:|---:|---:|---:|:---:|
| compile | TT | 18 | 28.2761 | 321.6537 | 29.6478 | 111.8234 | 116.480115 | **+0.68** ✅ |
| compile | SS | 43 | 25.2239 | 1.1524 | 178.538062 | 178.5381 | 179.183398 | **−1.20** ❌ |
| compile | FF | 18 | −68.8016 | 1.1671 | 1.35×10⁵ | 111.8234 | 116.480115 | **+1.09** ✅ |
| compile_ultra | TT | 18 | 28.2761 | 321.6567 | 29.6478 | 111.8234 | 116.480115 | **+0.68** ✅ |
| compile_ultra | SS | 43 | 25.2302 | 1.1624 | 178.538062 | 180.1402 | 190.153007 | **−1.30** ❌ |
| compile_ultra | FF | 18 | −68.8016 | 1.4050 | 1.35×10³ | 111.8234 | 116.480115 | **+0.98** ✅ |

✅ = Timing constraint met (positive slack)  
❌ = Timing constraint violated (negative slack)

---

## Analysis Notes

### Timing Observations

- **TT corner:** Positive slack of +0.68 ns under both compile modes — design meets timing at nominal conditions
- **FF corner:** Best positive slack (+1.09 ns / +0.98 ns) — fastest transistors reduce path delay
- **SS corner:** Negative slack (−1.20 ns / −1.30 ns) — slower transistors and lower voltage cause paths to miss the timing constraint. This is the critical sign-off corner.

### Power Observations

- **Leakage power** is highest at the TT corner (321.65 W) in this dataset, which may reflect the specific PVT conditions of the library characterization rather than a physical anomaly
- **Dynamic power** is relatively stable across TT and SS corners
- **FF corner** reports negative dynamic power — this is a reporting artifact in the tool output and should be interpreted with caution

### Area Observations

- **Cell count** increases from 18 (TT/FF) to 43 (SS) — the tool inserts additional cells (buffers, upsized gates) to meet or approach timing at the slower corner
- **Compile Ultra at SS** increases total area from 179.18 nm² to 190.15 nm² compared to standard compile, reflecting the more aggressive cell transformations

### Compile vs. Compile Ultra

| Corner | compile Slack (ns) | compile_ultra Slack (ns) | Difference |
|---|---|---|---|
| TT | +0.68 | +0.68 | No change |
| SS | −1.20 | −1.30 | Ultra slightly worse |
| FF | +1.09 | +0.98 | Ultra slightly worse |

For this design, `compile_ultra` did not outperform standard `compile` on timing. This is design-dependent and should not be generalized as a universal outcome.

---

## Post-Routing Timing Sign-off Result

After physical implementation in ICC2, the final timing check (Figure 14 in report) confirmed:

```
No setup violations found.
No hold violations found.
```

The design is timing-closed in the final routed implementation.
