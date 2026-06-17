# Multi-Corner and Multi-Mode PVT Analysis

## What is PVT Analysis?

PVT stands for **Process, Voltage, Temperature** — the three primary sources of variation that cause a manufactured chip to behave differently from the ideal simulation model.

| Variable | Source of Variation | Effect |
|---|---|---|
| **Process (P)** | Manufacturing variation (doping concentration, gate oxide thickness, transistor geometry) | Transistors are faster (Fast) or slower (Slow) than the nominal model |
| **Voltage (V)** | Supply voltage variation (IR drop, regulator tolerance) | Higher voltage → faster switching; lower voltage → slower switching |
| **Temperature (T)** | Operating environment (junction heating, ambient temperature) | In standard CMOS, higher temperature generally slows transistors |

A **PVT corner** is a specific combination of these three variables that represents a bound on the design space.

---

## The Three Corners Analysed

### TT — Typical-Typical

- **Process:** Typical (nominal transistor parameters)
- **Voltage:** Nominal supply
- **Temperature:** Nominal (room temperature)
- **Role:** Baseline reference. Used to assess nominal power consumption and performance.
- **Timing result (this design):** Slack = +0.68 ns (met)

### SS — Slow-Slow

- **Process:** Slow (transistors have lower drive strength than nominal)
- **Voltage:** Low (below nominal — worst case for voltage)
- **Temperature:** High (hot — worst case for temperature in CMOS)
- **Role:** **Primary sign-off corner for setup timing.** If the design meets setup timing at SS, it will meet setup timing under all realistic conditions.
- **Timing result (this design):** Slack = −1.20 ns (not met with standard compile)
- **Note:** Negative slack at the SS corner is common in tightly constrained designs. It is addressed through timing optimization (`compile_ultra`) or constraint relaxation.

### FF — Fast-Fast

- **Process:** Fast (transistors have higher drive strength than nominal)
- **Voltage:** High (above nominal)
- **Temperature:** Low (cold)
- **Role:** Best-case setup timing, but **worst-case for hold timing** and leakage power. Hold timing must be checked at FF to ensure that fast data arrival doesn't cause hold violations.
- **Timing result (this design):** Slack = +1.09 ns for setup (met)

---

## Compile vs. Compile Ultra

Design Compiler offers two primary synthesis optimization modes:

### `compile`
- Standard synthesis and optimization pass
- Balances runtime and quality of results
- Suitable for initial exploration and designs with relaxed constraints

### `compile_ultra`
- More aggressive timing-driven optimization
- Explores a larger solution space, including logic restructuring and cell sizing
- Generally produces better timing results, particularly on critical paths
- Trade-off: higher cell count and area in some cases, and longer runtime

### Observed Impact at SS Corner

| Mode | Cell Count | Total Area (nm²) | Timing Slack (ns) |
|---|---|---|---|
| compile | 43 | 179.183398 | −1.20 |
| compile_ultra | 43 | 190.153007 | −1.30 |

> **Observation from this project:** At the SS corner, `compile_ultra` did not improve timing over standard `compile` for this specific design — the slack became slightly more negative (−1.30 vs. −1.20). This illustrates that `compile_ultra` does not always guarantee better timing; the improvement depends on the specific design topology and available optimization headroom.

---

## Summary Table — Full Multi-Corner Results

*(Reproduced from workshop Table I)*

| Compile Mode | Corner | Cell Count | Dynamic Power (µW) | Cell Leakage Power (W) | Total Power (µW) | Cell Area (nm²) | Total Area (nm²) | Timing Slack (ns) |
|---|---|---|---|---|---|---|---|---|
| compile | TT | 18 | 28.2761 | 321.6537 | 29.6478 | 111.8234 | 116.480115 | +0.68 |
| compile | SS | 43 | 25.2239 | 1.1524 | 178.538062 | 178.5381 | 179.183398 | −1.20 |
| compile | FF | 18 | −68.8016 | 1.1671 | 1.35×10⁵ | 111.8234 | 116.480115 | +1.09 |
| compile_ultra | TT | 18 | 28.2761 | 321.6567 | 29.6478 | 111.8234 | 116.480115 | +0.68 |
| compile_ultra | SS | 43 | 25.2302 | 1.1624 | 178.538062 | 180.1402 | 190.153007 | −1.30 |
| compile_ultra | FF | 18 | −68.8016 | 1.4050 | 1.35×10³ | 111.8234 | 116.480115 | +0.98 |

---

## Key Takeaways

1. The **SS corner is the critical sign-off corner** — it reveals the worst-case setup timing behaviour
2. The **FF corner reveals leakage power concerns** — leakage is highest at fast process and high voltage
3. **Dynamic power** is relatively insensitive to PVT corner compared to leakage power
4. **`Compile Ultra` is not a guaranteed improvement** — it depends on the design's optimization headroom
5. Running multi-corner analysis is essential industrial practice — shipping a design that only works at TT but fails at SS would result in a non-functional chip in some manufacturing lots
