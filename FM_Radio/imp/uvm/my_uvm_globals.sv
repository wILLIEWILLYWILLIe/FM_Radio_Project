`ifndef MY_UVM_GLOBALS_SV
`define MY_UVM_GLOBALS_SV

// =========================================================================
// Global Configuration and Parameters for FM Radio UVM Testbench
// =========================================================================

`timescale 1ns/1ps

// parameter string REF_I_FILE     = "../../test/in_I.txt";
// parameter string REF_Q_FILE     = "../../test/in_Q.txt";
// parameter string REF_LEFT_FILE  = "../../test/out_left.txt";
// parameter string REF_RIGHT_FILE = "../../test/out_right.txt";
// parameter int TOTAL_INPUT_SAMPLES  = 262144;
// parameter int TOTAL_OUTPUT_SAMPLES = 32768;

parameter string REF_I_FILE     = "../test/in_I.txt";
parameter string REF_Q_FILE     = "../test/in_Q.txt";
parameter string REF_LEFT_FILE  = "../test/out_left.txt";
parameter string REF_RIGHT_FILE = "../test/out_right.txt";

parameter int TOTAL_INPUT_SAMPLES  = 262144;
parameter int TOTAL_OUTPUT_SAMPLES = 32768;

`endif
