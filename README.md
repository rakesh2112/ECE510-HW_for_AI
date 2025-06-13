# ECE510-HW_for_AI
The purpose of this repo is to track my weekly progress and document my research and implementations
#    LSTM Hardware Acceleration using Synthesizable Floating Point RTL

> Offloading LSTM matrix-vector multiplications (Wx·x and Wh·h) to custom-built, synthesizable IEEE-754 compliant SystemVerilog modules.

---

##   Project Overview

This project identifies and offloads the most computationally intensive part of an LSTM model — the **matrix-vector multiplications** — into **synthesizable SystemVerilog RTL** modules.

The core idea is to:
- Profile the LSTM using `cProfile` and `snakeviz`
- Extract bottlenecks (Wx·x, Wh·h)
- Re-implement them as IEEE-754 compliant `fp_add` and `fp_mult` blocks
- Combine them in a pipelined, FSM-controlled `matrix_vector_mul_fp` module
- Simulate and compare performance with NumPy-based model

---

##     Why This Project?

LSTM models, especially when deployed on edge devices or FPGAs, face computational bottlenecks in matrix operations. This project demonstrates:
- Custom RTL design without external IPs
- Realistic co-design for ML acceleration
- Full integration between Python profiling + RTL execution

---

##    Features

- ✅ Fully synthesizable IEEE-754 floating-point multiplier (`fp_mult.v`)
- ✅ Fully synthesizable IEEE-754 floating-point adder (`fp_add.v`)
- ✅ FSM-driven, pipelined matrix-vector multiplier (`matrix_vector_mul_fp.sv`)
- ✅ NumPy-compatible `.mem` file format interface
- ✅ Self-contained RTL—no simulation-only constructs
- ✅ Designed for educational and research prototyping

---

##    Directory Structure

```bash
├── fp_add.v                   # Floating point adder (synthesizable)
├── fp_mult.v                  # Floating point multiplier (synthesizable)
├── matrix_vector_mul_fp.sv    # RTL Matrix-vector multiplier using fp_add/fp_mult
├── tb_matrix_mul.sv           # Testbench (optional)
├── data/
│   ├── input_vector.mem       # IEEE-754 vector
│   └── input_matrix.mem       # IEEE-754 matrix
├── scripts/
│   └── numpy_to_mem.py        # Script to convert NumPy arrays to .mem
├── README.md
└── LSTM_RTL_Offload_Report.docx
