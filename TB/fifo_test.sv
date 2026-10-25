class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)
  
  fifo_env envh;
  fifo_sequence sqh;
  
  function new(string name="fifo_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = fifo_env::type_id::create("envh",this);
    sqh = fifo_sequence::type_id::create("sqh");
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    sqh.start(envh.agh.sqrh);
    phase.drop_objection(this);
  endtask
  
endclass
