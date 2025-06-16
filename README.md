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

- Fully synthesizable IEEE-754 floating-point multiplier (`fp_mult.v`)
- Fully synthesizable IEEE-754 floating-point adder (`fp_add.v`)
- FSM-driven, pipelined matrix-vector multiplierto scale the LSTM layers (`matrix_vector_mul_fp.sv`)
- Self-contained RTL—no simulation-only constructs
- Designed for educational and research prototyping

---

##    Directory Structure

### 📁 Directory Structure

```
ECE510-HW_FOR_AI/
├── challenges/                  # Course challenge submissions
│   └── Docs/
│       ├── Challenge_3_Physical_System_Differential_Equations.pdf
│       ├── challenge-4.pdf
│       └── HW_for_AI_and_ML_self_documentation.pdf
├── project/                     # Final project: LSTM Matrix Multiply RTL Offload
│   └── src/
│       ├── model/               # Python-based LSTM prediction model
│       │   ├── cli_tool/       # Command-line tools for running predictions
│       │   ├── LSTM_Model/     # Core LSTM implementation
│       │   └── trained_models/ # Pretrained models for different stocks
│       ├── RTL/                # RTL implementation (SystemVerilog)
│       ├── tb/                 # Testbench files for RTL simulation
│       ├── profile_output.txt  # Profiling output (plain text)
│       ├── snakeviz_profile.prof # SnakeViz profiler data
│       └── README.md           # Project-specific readme
└── README.md                   # Root project readme
```

