`ifndef MY_UVM_TRANSACTION_SV
`define MY_UVM_TRANSACTION_SV

class my_uvm_transaction extends uvm_sequence_item;

    // Input data for one FM inference sample
    rand logic signed [WIDTH-1:0] I_in;
    rand logic signed [WIDTH-1:0] Q_in;

    // Output data (captured by monitor)
    logic signed [WIDTH-1:0]      left_out;
    logic signed [WIDTH-1:0]      right_out;

    `uvm_object_utils_begin(my_uvm_transaction)
        `uvm_field_int(I_in, UVM_ALL_ON)
        `uvm_field_int(Q_in, UVM_ALL_ON)
        `uvm_field_int(left_out, UVM_ALL_ON)
        `uvm_field_int(right_out, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "my_uvm_transaction");
        super.new(name);
    endfunction

    // Convert to string for debugging
    virtual function string str();
        return $sformatf("I: %0d, Q: %0d, L: %0d, R: %0d", I_in, Q_in, left_out, right_out);
    endfunction

endclass

`endif
