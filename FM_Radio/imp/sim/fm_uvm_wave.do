onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {UVM Top-Level Testbench}
add wave -noupdate -radix hex /my_uvm_tb/clock
add wave -noupdate -radix hex /my_uvm_tb/reset

add wave -noupdate -divider {System Input FIFO}
add wave -noupdate -color {Cyan} -format Logic /my_uvm_tb/dut/u_input_fifo/wr_en
add wave -noupdate -color {Cyan} -format Logic /my_uvm_tb/dut/u_input_fifo/full
add wave -noupdate -color {Cyan} -format Logic /my_uvm_tb/dut/u_input_fifo/rd_en
add wave -noupdate -color {Cyan} -format Logic /my_uvm_tb/dut/u_input_fifo/empty
add wave -noupdate -color {Cyan} -radix hex /my_uvm_tb/dut/u_input_fifo/count

add wave -noupdate -divider {FM Radio Interfaces (IO)}
add wave -noupdate -color {Orange} -format Logic /my_uvm_tb/vif/valid_in
add wave -noupdate -color {Orange} -radix hex /my_uvm_tb/vif/I_in
add wave -noupdate -color {Orange} -radix hex /my_uvm_tb/vif/Q_in
add wave -noupdate -color {Orange} -format Logic /my_uvm_tb/vif/in_full

add wave -noupdate -divider {FM Radio Outputs}
add wave -noupdate -color {Gold} -format Logic /my_uvm_tb/vif/valid_out
add wave -noupdate -color {Gold} -radix hex /my_uvm_tb/vif/left_out
add wave -noupdate -color {Gold} -radix hex /my_uvm_tb/vif/right_out

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1000 ns}
