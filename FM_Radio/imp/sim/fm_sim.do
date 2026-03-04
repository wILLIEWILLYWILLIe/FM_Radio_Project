# =============================================================
# ModelSim/QuestaSim simulation script for FM Radio Top Testbench
# =============================================================
# Run from imp/sim/ directory
# Usage (GUI):   vsim -do fm_sim.do
# Usage (Batch): vsim -c -do fm_sim.do
# =============================================================

# Create work library
vlib work

# Compile packages first
vlog -sv ../sv/fir_pkg.sv
vlog -sv ../sv/qarctan.sv

# Compile IP / Leaf modules
vlog -sv ../sv/fir.sv
vlog -sv ../sv/demodulate.sv
vlog -sv ../sv/multiply.sv
vlog -sv ../sv/deemphasis.sv
vlog -sv ../sv/gain.sv
vlog -sv ../sv/add_sub.sv

# Compile Top and Testbench
vlog -sv ../sv/fm_radio_top.sv
vlog -sv ../sv/fm_radio_top_tb.sv

# Load simulation
vsim -voptargs="+acc" work.fm_radio_top_tb

# Log all signals (for waveform viewing)
if {[batch_mode]} {
    puts "Running in batch mode, skipping waveform setup."
} else {
    log -r /*
}

# Run simulation
run -all
