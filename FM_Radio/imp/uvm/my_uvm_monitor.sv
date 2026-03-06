`ifndef MY_UVM_MONITOR_SV
`define MY_UVM_MONITOR_SV

class my_uvm_monitor extends uvm_monitor;
    `uvm_component_utils(my_uvm_monitor)

    virtual fm_if vif;
    uvm_analysis_port#(my_uvm_transaction) mon_ap;

    int cycles_waited = 0;
    int items_captured = 0;
    int first_out_cycle = -1;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
        if(!uvm_config_db#(virtual fm_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", $sformatf("virtual interface must be set for: %s.vif", get_full_name()))
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        my_uvm_transaction tr;

        `uvm_info("MON", "Waiting for reset deassertion", UVM_LOW)
        wait(vif.reset === 0);
        @(posedge vif.clock);
        wait(vif.reset === 1);
        `uvm_info("MON", "Reset deasserted, starting capture loop", UVM_LOW)

        forever begin
            @(posedge vif.clock);
            cycles_waited++;
            
            // Capture when output is valid
            if (vif.valid_out) begin
                if (first_out_cycle == -1) begin
                    first_out_cycle = cycles_waited;
                    `uvm_info("MON", $sformatf("First valid_out received at cycle %0d", cycles_waited), UVM_LOW)
                end
                
                tr = my_uvm_transaction::type_id::create("tr");
                tr.left_out  = vif.left_out;
                tr.right_out = vif.right_out;
                mon_ap.write(tr);

                items_captured++;
                if (items_captured % 5000 == 0) begin
                    `uvm_info("MON", $sformatf("Captured %0d audio samples...", items_captured), UVM_LOW)
                end
            end
        end
    endtask

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("MON", "--- PERFORMANCE SUMMARY ---", UVM_NONE)
        `uvm_info("MON", $sformatf("First Valid Output Cycle: %0d", first_out_cycle), UVM_NONE)
        `uvm_info("MON", $sformatf("Total Samples Captured:   %0d", items_captured), UVM_NONE)
        `uvm_info("MON", $sformatf("Total Simulation Cycles:  %0d", cycles_waited), UVM_NONE)
        `uvm_info("MON", "---------------------------", UVM_NONE)
    endfunction

endclass

`endif
