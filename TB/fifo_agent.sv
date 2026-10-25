class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)
  
  fifo_sequencer sqrh;
  fifo_driver drvh;
  fifo_monitor monh;
  
  function new(string name="fifo_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqrh = fifo_sequencer::type_id::create("sqrh",this);
    drvh = fifo_driver::type_id::create("drvh",this);
    monh = fifo_monitor::type_id::create("monh",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drvh.seq_item_port.connect(sqrh.seq_item_export);
  endfunction
endclass
