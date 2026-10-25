class fifo_sequence extends uvm_sequence #(fifo_txn);
  `uvm_object_utils(fifo_sequence)
  
  fifo_txn txn;
  int num_txns=50;
  int FULL=16;
  
  function new(string name="fifo_sequence");
    super.new(name);
  endfunction
  
  task body();
//     /single write and single read test cases
    //single write
    `uvm_info(get_type_name(),"SINGLE WRITE",UVM_LOW)
    txn = fifo_txn::type_id::create("txn");
    start_item(txn);
    txn.wr_en=1;
    txn.rd_en=0;
    txn.wdata=8'h2A;
    finish_item(txn);
    
//     idle
    txn = fifo_txn::type_id::create("txn");
    start_item(txn);
    txn.wr_en=0;txn.rd_en=0;
    finish_item(txn);

    //single read
    `uvm_info(get_type_name(),"SINGLE READ",UVM_LOW)
    txn = fifo_txn::type_id::create("txn");
    start_item(txn);
    txn.wr_en=0;
    txn.rd_en=1;
    finish_item(txn);
    
    //corner tests
    `uvm_info(get_type_name(),"CORNER CASE 'hFF",UVM_LOW)
    txn = fifo_txn::type_id::create("txn");
    start_item(txn);
    txn.wr_en=1;
    txn.rd_en=0;
    txn.wdata=8'hFF;
    finish_item(txn);
    
    `uvm_info(get_type_name(),"CORNER CASE 'h00",UVM_LOW)
    txn = fifo_txn::type_id::create("txn");
    start_item(txn);
    txn.wr_en=1;
    txn.rd_en=0;
    txn.wdata=8'h00;
    finish_item(txn);
    
    //all writes to check the fifo overflow
    `uvm_info(get_type_name(),"FIFO FILLING",UVM_LOW)
    for(int i=0;i<=FULL+2;i++)begin
    txn= fifo_txn::type_id::create("txn");
      start_item(txn);
      txn.wr_en=1;
      txn.rd_en=0;
      txn.wdata=i[7:0];
      finish_item(txn);
    end
    
     //all writes to check the fifo overflow
    `uvm_info(get_type_name(),"FIFO DRAINING TO EMPTY",UVM_LOW)
    for(int i=0;i<=FULL+2;i++)begin
    txn= fifo_txn::type_id::create("txn");
      start_item(txn);
      txn.wr_en=0;
      txn.rd_en=1;
      finish_item(txn);
    end
    
        //constrained random cases
    `uvm_info(get_type_name(),"RANDOM CASES",UVM_LOW)
    repeat(num_txns)begin
      txn= fifo_txn::type_id::create("txn");
      start_item(txn);
      assert(txn.randomize());
      finish_item(txn);
    end
    
    //stress cases
    `uvm_info(get_type_name(),"STRESS CASES",UVM_LOW)
    repeat(num_txns)begin
      txn = fifo_txn::type_id::create("txn");
      start_item(txn);
      txn.c1.constraint_mode(0);
      assert(txn.randomize());
      finish_item(txn);
    end
    
    
  endtask
endclass
