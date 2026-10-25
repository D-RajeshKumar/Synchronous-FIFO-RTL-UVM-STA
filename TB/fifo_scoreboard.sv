class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  
  uvm_analysis_imp#(fifo_txn,fifo_scoreboard) actual_imp;
  
  bit [7:0] expected_q[$];
  bit [7:0] mem_model[$];
  bit [7:0] expected;
  
  int pass_cnt,fail_cnt,total;
  
  function new(string name="fifo_scoreboard",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    actual_imp = new("actual_imp",this);
  endfunction
  
  function void write(fifo_txn txn);
	bit full_model,empty_model;
    
    if(txn.rd_en)begin
    if(expected_q.size()>0)begin
      total++;
      expected = expected_q.pop_front();
      if(expected == txn.rdata)begin
        `uvm_info(get_type_name(),$sformatf("[SB MATCH] expected=%0h | actual=%0h",expected,txn.rdata),UVM_LOW)
        pass_cnt++;
      end
        else begin
          `uvm_error(get_type_name(),$sformatf("[SB MISMATCH] expected=%0h | actual=%0h",expected,txn.rdata))
          fail_cnt++;
        end
    end
    end
      full_model = (mem_model.size()==16);
      empty_model = (mem_model.size()==0);
      
      if(txn.wr_en && !txn.full)
        mem_model.push_back(txn.wdata);
      if(txn.rd_en && !txn.empty)
        expected_q.push_back(mem_model.pop_front());
  endfunction
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("TOTAL CASES=%0d | PASS=%0d | FAIL=%0d",total,pass_cnt,fail_cnt),UVM_LOW)
  endfunction

endclass
