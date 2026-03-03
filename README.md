# FM Radio SystemVerilog Implementation

This repository contains a high-performance, fully pipelined Hardware (SystemVerilog) implementation of an FM Radio receiver and stereo decoder. The design has been heavily optimized for maximum throughput, pushing the synthesis clock constraint to ~90 MHz by leveraging targeted DSP block mapping and extensive pipelining.

## 🚀 Quick Start & Co-Development Guide

Since the raw C-simulation data files (golden references) are ignored by git (via `.gitignore`) to save space, **you must generate them locally first** before running any Verilog simulations.

### 1. Load the EDA Environment
Before compiling C++ or running Cadence Xcelium tools, source the environment variables:
```bash
# From the project root
source myenv_GenusXcelium
```

### 2. Generate Golden Reference Data
We use a C++ model to generate the perfect "golden" outputs for all intermediate pipeline stages.

First, you must unzip the compressed USRP raw data file:
```bash
cd FM_Radio/test
unzip usrp.zip
```

Then, compile and run the reference model:
```bash
cd ..
make golden
```
> This will compile the C++ reference model and generate `.txt` data streams inside `FM_Radio/test/`. These are necessary for the SystemVerilog testbenches.

### 3. Run SystemVerilog Simulations
Change into the simulation directory and run the `make top` command to simulate the complete FM radio decoder pipeline.
```bash
cd FM_Radio/imp/sim

# Run the full top-level testbench
make top
```
> You should see `LEFT : Checked=32768 Errors=0 PASS` and `RIGHT: Checked=32768 Errors=0 PASS`.

If you want to run unit tests for specific modules, you can use:
```bash
make demod      # Tests demodulate.sv
make deemph     # Tests deemphasis.sv
make fir        # Tests fir.sv
make all        # Runs all module-level tests
```

### 4. Logic Synthesis (Synplify)
To evaluate maximum clock frequency and hardware utilization, run synthesis via Synopsys Synplify:
```bash
cd FM_Radio/imp/syn

# Run synthesis using the provided project file
synplify_pro -batch fm_radio.prj
```
> The output reports (timing, area, log) will be generated inside the `rev_1/` directory.

---

## 🏗️ Hardware Architecture & Optimizations

This design translates a sequential C-based DSP algorithm into a **Fully Pipelined Streaming Architecture** with a throughput of 1 sample/clock.

### 1. Streaming "Feed-Forward" Datapath
The design does **not** use FIFOs for inter-module communication. Instead, it relies on a localized explicit valid-chain (`valid_in` → `valid_out`). Modules gracefully wait when `valid` is inactive (such as during the 8x Decimation in the FIR filters).

### 2. Major Pipeline Optimizations
During our timing-closure push from 9.8 MHz up to 89.6 MHz, the critical path was heavily sliced. Key transformations include:
- **Pipelined Restoring Divider:** The 32-bit division in the FM Demodulator (qarctan) was unrolled from a massive combinational loop into a 32-stage pipeline.
- **Divider Elimination:** Division by 1024 (`/ (1<<BITS)`) in the De-emphasis module was replaced with purely combinational Shift-and-Add wiring (`div1024_f`) that accurately preserves C-language truncation-towards-zero behavior.
- **2-Cycle FIR MAC:** The FIR filters execute their 32-tap Dot Products using a 1-cycle DSP multiplier stage, followed by an explicitly registered Adder-Tree stage.
- **Careful DSP Allocation:** Only the most massive 32-tap decimation filters (LPR / LMR) invoke the FPGA's built-in `DSP` block multipliers (via PRAGMA configurations) to avoid exhausting total hardware resources.

### 3. File Structure
* `FM_Radio/src/`: Original C++ algorithmic implementation.
* `FM_Radio/test/`: Location where `make golden` dumps intermediate text files.
* `FM_Radio/imp/sv/`: **The core SystemVerilog hardware implementation.**
  - `fm_radio_top.sv` - Top-level module
  - `demodulate.sv` - FM Demodulator (qarctan)
  - `fir.sv` - Parameterized multiply-accumulate filter
  - `deemphasis.sv` - IIR De-emphasis filter
* `FM_Radio/imp/sim/`: Xcelium simulation Makefiles and testbenches.
* `FM_Radio/imp/syn/`: RTL logic synthesis project files and reports (`fm_radio.prj`, `rev_1/`).
* `note.md`: Historical design notes recording the optimization journey from 9 MHz to 90 MHz.

---

## 🎯 Future Work & TODOs

- [ ] **UVM Verification Environment:** Migrate the current direct-test SystemVerilog testbenches into a scalable Universal Verification Methodology (UVM) environment to improve constrained-random testing, coverage collection, and corner-case stimulation.
