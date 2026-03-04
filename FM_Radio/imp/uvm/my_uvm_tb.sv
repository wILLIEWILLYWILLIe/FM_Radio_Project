`timescale 1ns/1ps

import uvm_pkg::*;
import my_uvm_pkg::*;
import fir_pkg::*;
import qarctan_pkg::*;

module my_uvm_tb;

    logic clock;
    logic reset;

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // 100 MHz
    end

    // Active-low reset: assert then deassert
    initial begin
        reset = 0;   // Assert reset (active low for rst_n)
        #100;
        reset = 1;   // Deassert reset
    end

    // Interface
    fm_if vif(clock, reset);

    // DUT
    fm_radio_top dut (
        .clk        (vif.clock),
        .rst_n      (vif.reset),
        
        // Input
        .valid_in   (vif.valid_in),
        .I_in       (vif.I_in),
        .Q_in       (vif.Q_in),
        
        // Output
        .valid_out  (vif.valid_out),
        .left_out   (vif.left_out),
        .right_out  (vif.right_out)
    );

    initial begin
        // Pass virtual interface to UVM environment
        uvm_config_db#(virtual fm_if)::set(uvm_root::get(), "*", "vif", vif);
        // Start UVM test
        run_test("my_uvm_test");
    end

endmodule
