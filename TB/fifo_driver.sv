class fifo_driver extends uvm_driver #(fifo_txn);
  `uvm_component_utils(fifo_driver)
  
  virtual fifo_if vif;
  
  function new(string name="fifo_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this,"","vif",vif))
       `uvm_fatal("NO VIF","didnt get vif from database");
  endfunction
  
  task run_phase(uvm_phase phase);
    fifo_txn txn;
    forever begin
    seq_item_port.get_next_item(txn);
    drive(txn);
    seq_item_port.item_done();
    end
  endtask
  
  task drive(fifo_txn txn);
    vif.drv_cb.wr_en<=txn.wr_en;
    vif.drv_cb.wdata<=txn.wdata;
    vif.drv_cb.rd_en<=txn.rd_en;
//     `uvm_info("DRV",txn.convert2string(),UVM_LOW)
    @(vif.drv_cb);
  endtask
endclass
