// =============================================================
// multiply.sv — Fixed-point multiplier
// Matches C: output = DEQUANTIZE(x * y)
// Two-process: always_comb + always_ff
// =============================================================

module multiply import fir_pkg::*; (
    input  logic                            clk,
    input  logic                            rst_n,
    input  logic                            valid_in,
    input  logic signed [WIDTH-1:0]         x_in,
    input  logic signed [WIDTH-1:0]         y_in,
    output logic                            valid_out,
    output logic signed [WIDTH-1:0]         out
);

    // Combinational
    logic signed [WIDTH*2-1:0] next_out;
    logic signed [WIDTH-1:0] next_out_p2;
    logic valid_in_p1;

    //--------------------pipline1---------------------------
    logic signed [WIDTH*2-1:0] next_out_p1;
    assign next_out = int'(x_in) * int'(y_in);
    //--------------------pipline2---------------------------
    assign next_out_p2 = WIDTH'(fir_pkg::div1024_f(next_out_p1));

    // Sequential
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out       <= '0;
            valid_out <= 1'b0;
            next_out_p1 <= '0;
            valid_in_p1 <= 1'b0;
        end else begin
            valid_out <= 1'b0;
            valid_in_p1 <= valid_in;
            next_out_p1 <= next_out;

            if (valid_in_p1) begin
                out       <= next_out_p2;
                valid_out <= 1'b1;
            end
        end
    end

endmodule
