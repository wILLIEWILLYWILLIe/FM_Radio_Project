`ifndef MY_UVM_SCOREBOARD_SV
`define MY_UVM_SCOREBOARD_SV

class my_uvm_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_uvm_scoreboard)

    uvm_analysis_imp #(my_uvm_transaction, my_uvm_scoreboard) sb_export;

    localparam int N_OUT = TOTAL_OUTPUT_SAMPLES;
    logic signed [WIDTH-1:0] gold_left  [0:N_OUT-1];
    logic signed [WIDTH-1:0] gold_right [0:N_OUT-1];

    int test_count = 0;
    int error_l_count = 0;
    int error_r_count = 0;

    // ---- Functional Coverage ----
    logic signed [WIDTH-1:0] cov_left;
    logic signed [WIDTH-1:0] cov_right;

    covergroup cg_audio_out;
        option.per_instance = 1;

        cp_left: coverpoint cov_left {
            bins negative = {[$:-1]};
            bins zero     = {0};
            bins positive = {[1:$]};
        }
        cp_right: coverpoint cov_right {
            bins negative = {[$:-1]};
            bins zero     = {0};
            bins positive = {[1:$]};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_audio_out = new();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        int fd_l, fd_r, status_l, status_r, val, idx;
        super.connect_phase(phase);

        // Read left expected golden values
        fd_l = $fopen(REF_LEFT_FILE, "r");
        if (fd_l == 0) `uvm_fatal("SCB", "Could not open out_left.txt")
        idx=0; while(!$feof(fd_l) && idx<N_OUT) begin status_l=$fscanf(fd_l,"%d\n",val); if(status_l==1) begin gold_left[idx]=val; idx++; end end
        $fclose(fd_l);
        `uvm_info("SCB", $sformatf("Loaded %0d left golden samples", idx), UVM_LOW)

        // Read right expected golden values
        fd_r = $fopen(REF_RIGHT_FILE, "r");
        if (fd_r == 0) `uvm_fatal("SCB", "Could not open out_right.txt")
        idx=0; while(!$feof(fd_r) && idx<N_OUT) begin status_r=$fscanf(fd_r,"%d\n",val); if(status_r==1) begin gold_right[idx]=val; idx++; end end
        $fclose(fd_r);
        `uvm_info("SCB", $sformatf("Loaded %0d right golden samples", idx), UVM_LOW)
    endfunction

    virtual function void write(my_uvm_transaction tr);
        logic signed [WIDTH-1:0] exp_l = gold_left[test_count];
        logic signed [WIDTH-1:0] exp_r = gold_right[test_count];

        if (tr.left_out !== exp_l) begin
            if (error_l_count < 10)
                `uvm_error("SCB_L", $sformatf("L MISMATCH @%0d: got %0d, expected %0d", test_count, tr.left_out, exp_l))
            error_l_count++;
        end

        if (tr.right_out !== exp_r) begin
            if (error_r_count < 10)
                `uvm_error("SCB_R", $sformatf("R MISMATCH @%0d: got %0d, expected %0d", test_count, tr.right_out, exp_r))
            error_r_count++;
        end

        // Coverage sampling
        cov_left  = tr.left_out;
        cov_right = tr.right_out;
        cg_audio_out.sample();

        test_count++;
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCB", "===========================================", UVM_NONE)
        `uvm_info("SCB", $sformatf("LEFT  : Checked=%0d Errors=%0d %s", test_count, error_l_count, (error_l_count==0)?"PASS":"FAIL"), UVM_NONE)
        `uvm_info("SCB", $sformatf("RIGHT : Checked=%0d Errors=%0d %s", test_count, error_r_count, (error_r_count==0)?"PASS":"FAIL"), UVM_NONE)
        if (error_l_count == 0 && error_r_count == 0 && test_count == N_OUT) begin
            `uvm_info("SCB", "ALL TESTS PASSED SUCCESSFULLY!", UVM_NONE)
        end else begin
            `uvm_error("SCB", "SIMULATION FAILED OR INCOMPLETE DATA")
        end
        `uvm_info("SCB", "===========================================", UVM_NONE)

        // Coverage report
        `uvm_info("SCB", $sformatf("Audio Output Coverage: %.1f%%", cg_audio_out.get_coverage()), UVM_NONE)
    endfunction

endclass

`endif
