# =============================================================
# ModelSim/QuestaSim script for UVM Simulation
# =============================================================
# Run from imp/sim/ directory
# Usage (Batch): vsim -c -do fm_uvm_sim.do
# Usage (GUI):   vsim -do fm_uvm_sim.do
# =============================================================

# Set custom UVM installation path (Mentor ModelSim specific if needed)
# setenv UVM_HOME /path/to/uvm/src

vlib work

# Compile standard packages
vlog -sv ../sv/fir_pkg.sv
vlog -sv ../sv/qarctan.sv

# Compile DUT files
vlog -sv ../sv/fir.sv
vlog -sv ../sv/demodulate.sv
vlog -sv ../sv/multiply.sv
vlog -sv ../sv/deemphasis.sv
vlog -sv ../sv/gain.sv
vlog -sv ../sv/add_sub.sv
vlog -sv ../sv/fm_radio_top.sv

# Compile UVM package and testbench
vlog -sv +incdir+../uvm ../uvm/my_uvm_pkg.sv
vlog -sv ../uvm/fm_if.sv
vlog -sv ../uvm/my_uvm_tb.sv

# Load simulation
# Note: we add +UVM_TESTNAME directly in the initialization or via TCL run step
vsim -voptargs="+acc" work.my_uvm_tb +UVM_TESTNAME=my_uvm_test +UVM_VERBOSITY=UVM_LOW

# Check if running in batch mode
if {[batch_mode]} {
    puts "Running in batch mode..."
} else {
    puts "Loading waveforms..."
    do fm_uvm_wave.do
}

# Run
run -all
