// =============================================================
// Synchronous FIFO with active-low reset for FM Radio project
// =============================================================

module fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 16
) (
    input  logic                   clk,
    input  logic                   rst_n,   // Active-low reset
    input  logic                   wr_en,
    input  logic [DATA_WIDTH-1:0]  din,
    output logic                   full,
    input  logic                   rd_en,
    output logic [DATA_WIDTH-1:0]  dout,
    output logic                   empty,
    output logic [$clog2(DEPTH):0] count
);

    localparam ADDR_BITS = $clog2(DEPTH);
    
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_BITS-1:0]  wr_ptr, rd_ptr;
    logic [ADDR_BITS:0]    fifo_count;

    assign full  = (fifo_count == DEPTH);
    assign empty = (fifo_count == 0);
    assign count = fifo_count;

    // Write Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr      <= wr_ptr + 1'b1;
        end
    end

    // Read Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= '0;
            dout   <= '0;
        end else if (rd_en && !empty) begin
            dout   <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Status Counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_count <= '0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_count <= fifo_count + 1'b1;
                2'b01: fifo_count <= fifo_count - 1'b1;
                default: ; // Do nothing
            endcase
        end
    end

endmodule
