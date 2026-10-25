class fifo_coverage_collector extends uvm_subscriber#(fifo_txn);
  `uvm_component_utils(fifo_coverage_collector)
  
  fifo_txn txn;
  
    covergroup cg_fifo;
   	option.per_instance=1;
    
   cg_wr: coverpoint txn.wr_en;
   cg_rd: coverpoint txn.rd_en;
   cg_full: coverpoint txn.full;
    cg_empty: coverpoint txn.empty;
    cg_af: coverpoint txn.almost_full;
    cg_ae: coverpoint txn.almost_empty;
    
    ccg_wrrd: cross cg_wr,cg_rd;
    ccg_full_wr: cross cg_full,cg_wr;  
    ccg_emp_rd: cross cg_empty,cg_rd;
    
    cpwdata: coverpoint txn.wdata{
      bins ones={8'hFF};
      bins zeros={8'h00};
      bins middle={[8'h01:8'hFE]};}
  endgroup
  
  function new(string name="fifo_coverage_collector",uvm_component parent);
    super.new(name,parent);
    cg_fifo=new();
  endfunction
  
  function void write(fifo_txn t);
    this.txn=t;
    cg_fifo.sample();
  endfunction
  
   virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV",$sformatf("Coverage Score: %0.2f%%", cg_fifo.get_coverage()), UVM_LOW)
     `uvm_info("COV",$sformatf("WR_EN RD_EN Cross Coverage: %0.2f%%", cg_fifo.ccg_wrrd.get_coverage()), UVM_LOW)
     `uvm_info("COV",$sformatf("READ WHEN EMPTY Cross Coverage: %0.2f%%", cg_fifo.ccg_emp_rd.get_coverage()), UVM_LOW)
     `uvm_info("COV",$sformatf("WRITE WHEN FULL Cross Coverage: %0.2f%%", cg_fifo.ccg_full_wr.get_coverage()), UVM_LOW)
  endfunction
  
endclass
