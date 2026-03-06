`ifndef MY_UVM_SEQUENCE_SV
`define MY_UVM_SEQUENCE_SV

class my_uvm_sequence extends uvm_sequence#(my_uvm_transaction);
    `uvm_object_utils(my_uvm_sequence)

    function new(string name = "my_uvm_sequence");
        super.new(name);
    endfunction

    virtual task body();
        my_uvm_transaction req;
        int fd_i, fd_q;
        int val_i, val_q, code_i, code_q;
        int count = 0;

        req = my_uvm_transaction::type_id::create("req");

        fd_i = $fopen(REF_I_FILE, "r");
        fd_q = $fopen(REF_Q_FILE, "r");
        
        if (fd_i == 0 || fd_q == 0) begin
            `uvm_fatal("SEQ", $sformatf("Failed to open %s or %s", REF_I_FILE, REF_Q_FILE))
        end

        `uvm_info("SEQ", $sformatf("Starting streaming of %0d samples...", TOTAL_INPUT_SAMPLES), UVM_LOW)

        while (!$feof(fd_i) && !$feof(fd_q)) begin
            code_i = $fscanf(fd_i, "%d", val_i);
            code_q = $fscanf(fd_q, "%d", val_q);
            
            if (code_i == 1 && code_q == 1) begin
                start_item(req);
                req.I_in = val_i;
                req.Q_in = val_q;
                finish_item(req);
                count++;
            end
        end

        $fclose(fd_i);
        $fclose(fd_q);

        `uvm_info("SEQ", $sformatf("Sequence complete: Drove %0d valid items", count), UVM_LOW)
    endtask

endclass

`endif
