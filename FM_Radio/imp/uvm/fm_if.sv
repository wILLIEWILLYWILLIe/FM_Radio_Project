`ifndef FM_IF_SV
`define FM_IF_SV

interface fm_if (
    input logic clock,
    input logic reset
);
    import fir_pkg::*;

    // Input interface
    logic                            valid_in;
    logic                            in_full;    // Added for backpressure
    logic signed [WIDTH-1:0]         I_in;
    logic signed [WIDTH-1:0]         Q_in;

    // Output interface
    logic                            valid_out;
    logic signed [WIDTH-1:0]         left_out;
    logic signed [WIDTH-1:0]         right_out;

    modport driver (
        input  clock, reset, in_full,
        output valid_in, I_in, Q_in
    );

    modport monitor (
        input clock, reset,
        input valid_out, left_out, right_out
    );

endinterface

`endif
