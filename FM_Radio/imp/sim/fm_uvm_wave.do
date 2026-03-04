onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {UVM Top-Level Testbench}
add wave -noupdate /my_uvm_tb/clock
add wave -noupdate /my_uvm_tb/reset

add wave -noupdate -divider {FM Radio Interfaces}
add wave -noupdate -color {Orange} -format Logic /my_uvm_tb/vif/valid_in
add wave -noupdate -color {Orange} -format Analog-Step -height 74 -max 1024 -min -1024 -radix decimal /my_uvm_tb/vif/I_in
add wave -noupdate -color {Orange} -format Analog-Step -height 74 -max 1024 -min -1024 -radix decimal /my_uvm_tb/vif/Q_in

add wave -noupdate -divider {Outputs}
add wave -noupdate -color {Gold} -format Logic /my_uvm_tb/vif/valid_out
add wave -noupdate -color {Gold} -format Analog-Step -height 74 -max 32768 -min -32768 -radix decimal /my_uvm_tb/vif/left_out
add wave -noupdate -color {Gold} -format Analog-Step -height 74 -max 32768 -min -32768 -radix decimal /my_uvm_tb/vif/right_out

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
