`ifndef MY_UVM_DRIVER_SV
`define MY_UVM_DRIVER_SV

class my_uvm_driver extends uvm_driver#(my_uvm_transaction);
    `uvm_component_utils(my_uvm_driver)

    virtual fm_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fm_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", $sformatf("virtual interface must be set for: %s.vif", get_full_name()))
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.valid_in <= 0;
        vif.I_in     <= 0;
        vif.Q_in     <= 0;

        `uvm_info("DRV", "Waiting for reset deassertion", UVM_LOW)
        wait(vif.reset === 0);
        @(posedge vif.clock);
        wait(vif.reset === 1);
        `uvm_info("DRV", "Reset deasserted, starting drive loop", UVM_LOW)

        // Wait a few cycles before blasting data
        repeat(5) @(posedge vif.clock);

        forever begin
            seq_item_port.get_next_item(req);
            
            // Drive precisely on clock edges
            @(negedge vif.clock);
            vif.valid_in <= 1;
            vif.I_in     <= req.I_in;
            vif.Q_in     <= req.Q_in;
            
            @(posedge vif.clock);
            #1;
            vif.valid_in <= 0; // Strobe style, or leave high if consecutive
                               // Wait actually fm_radio_top_tb holds valid_in=1 as long as sequence is valid, 
                               // but strobing high per transaction is safest if we run 1 transaction per cycle
            
            seq_item_port.item_done();
        end
    endtask

endclass

`endif
