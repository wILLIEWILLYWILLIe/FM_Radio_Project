# FM-Radio-FPGA-Accelerator: High-Performance Pipelined Receiver

[![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)](https://en.wikipedia.org/wiki/SystemVerilog)
[![FPGA-Flow](https://img.shields.io/badge/Flow-FPGA%20Design-green.svg)]()
[![UVM-Verified](https://img.shields.io/badge/Methodology-UVM-blueviolet.svg)]()

This repository contains a high-performance, fully pipelined Hardware (SystemVerilog) implementation of an FM Radio receiver and stereo decoder. The design has been heavily optimized for maximum throughput, pushing the synthesis clock constraint to ~90 MHz by leveraging targeted DSP block mapping and extensive pipelining.

## 📄 Project Report
The comprehensive final report detailing the architecture, optimizations, and verification results:
- [**Final Report (PDF)**](report/team_6_final_report.pdf)
- [**Project Report (Overleaf)**](https://www.overleaf.com/4431444772dtrfmgvgqkgf#eef2d9)

---

## 🚀 Quick Start & Co-Development Guide

Since the raw C-simulation data files (golden references) are ignored by git to save space, **you must generate them locally first** before running any Verilog simulations.

### 1. Load the EDA Environment
Before compiling C++ or running Cadence Xcelium tools, source the environment variables:
```bash
# From the project root
source myenv_GenusXcelium
```

### 2. Generate Golden Reference Data
1. **Unzip the compressed USRP raw data file:**
   ```bash
   cd FM_Radio/test
   unzip usrp.zip
   ```
2. **Compile and run the reference model:**
   ```bash
   cd ..
   make golden
   ```
   *This generates `.txt` data streams inside `FM_Radio/test/` necessary for the SystemVerilog testbenches.*

### 3. Verification & Simulation
We support both standard Verilog Testbenches and a full UVM environment.

#### Option A: UVM Verification (Recommended)
The UVM environment provides 100% functional coverage and automated scoreboard checking.
```bash
cd FM_Radio/imp/sim
vsim -do fm_uvm_sim.do     # GUI mode with waveforms
vsim -c -do fm_uvm_sim.do  # Command-line mode
```

#### Option B: Cadence Xcelium (Makefile)
```bash
cd FM_Radio/imp/sim
make top       # Comprehensive pipeline test
make demod     # Unit test for demodulate.sv
make deemph    # Unit test for deemphasis.sv
make fir       # Unit test for fir.sv
```

### 4. Logic Synthesis (Synplify)
To evaluate maximum clock frequency and hardware utilization:
```bash
cd FM_Radio/imp/syn
synplify_pro -batch fm_radio.prj
```
*Reports (timing, area) are generated in `rev_1/`.*

### 5. Packaging for Submission
To bundle the project into a structured archive for final submission:
```bash
# From the project root
make zip
```
*Creates `team_6_final_project.zip` containing organized `sv/`, `sim/`, `syn/`, `uvm/`, and `test/` directories.*

---

## 🏗️ Hardware Architecture & Optimizations

### 1. Streaming "Feed-Forward" Datapath
The design translates sequential C code into a **Fully Pipelined Streaming Architecture** with a throughput of 1 sample/clock.

### 2. Key Optimizations (~90 MHz Timing Closure)
*   **Pipelined Restoring Divider**: 32-stage division for the Quad-Arctan algorithm (replaces massive combinational loops).
*   **Arithmetic Right Shifts**: Replaced expensive `/ 1024` operators with `>>> 10` using the `div1024_f` function.
*   **2-Cycle FIR MAC**: Explicitly registered multiplier outputs followed by balanced adder trees.
*   **DSP Inference**: Synthesis pragmas map multiplications into dedicated DSP hardware.
*   **Input FIFO Synchronization**: A 16-deep FIFO handles USRP data burstiness and backpressure.

### 3. File Structure
*   `FM_Radio/imp/sv/`: Core RTL implementation (Top-level, FIR, Demod, De-emphasis).
*   `FM_Radio/imp/sim/`: Verification scripts and UVM environment.
*   `FM_Radio/imp/syn/`: Logic synthesis projects and timing reports.
*   `note.md`: Detailed engineering log tracking the optimization journey from 9 MHz to 90 MHz.

---

## 👥 Collaborator Notes
*   **Bit-True Accuracy**: The RTL output MUST match the C-model bit-for-bit. Check `my_uvm_scoreboard.sv` reports for any `UVM_ERROR`.
*   **Clock Constraint**: Current target is **100 MHz**. If you modify the logic, ensure the slack remains manageable (see `Section 6` of the report for timing analysis).
*   **Decimation**: Remember that the Mono/Stereo FIR filters decimate by 8. Valid signals are handled via a propagate-and-align strategy.
