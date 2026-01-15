# BPR-ONC Analysis (Endeavour Segment)
This study is going to be published by Lingchao He, Meng Wei, GuangyuXu. 

Tools and workflows for analyzing **Ocean Networks Canada (ONC) bottom pressure recorder (BPR)** time series at the Endeavour Segment (Juan de Fuca Ridge), building **differential pressure (ΔP)** products to suppress common-mode oceanographic variability, and comparing ΔP with **seismicity**, **near-bottom currents**, and **temperature** to evaluate candidate inflation–deflation transients.

> This repository is designed to support reproducible figure generation for a manuscript-style workflow (methods → processing → plots → export).

---

## Project goals

1. **Ingest ONC BPR time series** for multiple stations (commonly: North, MEF, South, Mothra; with **East as a reference** station when available).
2. Apply standard preprocessing (QC, gap handling, de-meaning / de-trending as needed).
3. **Filter** pressure and auxiliary time series to emphasize subtidal variability (e.g., Godin or equivalent low-pass).
4. Construct **differential pressure**:
   - Example: `ΔP_station = P_station − P_East` (after aligning time bases and removing offsets).
5. Quantify and visualize **seismicity** around MEF:
   - daily counts above a period-specific **magnitude of completeness (Mc)**
   - time–depth distributions
6. Compare ΔP against:
   - **temperature** (vent-fluid and/or bottom water thermistors)
   - **near-bottom currents** (e.g., ADCP meridional velocity)
   - optional: regional ocean model outputs (SSH/steric/current) for oceanographic correction context

---


