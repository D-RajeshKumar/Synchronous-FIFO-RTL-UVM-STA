class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)
  
  virtual fifo_if vif;
  uvm_analysis_port #(fifo_txn) mon_ap;
  
  function new(string name="fifo_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif))
      `uvm_fatal("NO FIFO_IF","didnt get interface handle from DB");
    mon_ap = new("mon_ap",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    fifo_txn txn;
    forever begin
      @(vif.mon_cb);
      txn = fifo_txn::type_id::create("txn");
      txn.wr_en=vif.mon_cb.wr_en;
      txn.wdata=vif.mon_cb.wdata;
      txn.rd_en=vif.mon_cb.rd_en;
      
//       if(vif.mon_cb.rd_en)
      	txn.rdata=vif.mon_cb.rdata;
      
      txn.full=vif.mon_cb.full;
      txn.empty=vif.mon_cb.empty;
      txn.almost_full=vif.mon_cb.almost_full;
      txn.almost_empty=vif.mon_cb.almost_empty;
      mon_ap.write(txn);
//       `uvm_info("MON",txn.convert2string(),UVM_LOW)
    end
  endtask
endclass
