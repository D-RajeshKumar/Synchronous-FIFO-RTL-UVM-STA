
class fifo_txn #(int WIDTH=8) extends uvm_sequence_item;
  `uvm_object_utils(fifo_txn)
  
  rand bit wr_en;
  rand bit [7:0] wdata;
  rand bit rd_en;
  
  bit [7:0] rdata;
  bit full;
  bit almost_full;
  bit empty;
  bit almost_empty;
  
  //class registration 
    function new(string name="fifo_txn");
    super.new(name);
  endfunction
  
  constraint c1{ {wr_en,rd_en} dist{
    				2'b10:=5,
    				2'b01:=4,
    				2'b11:=1};};
  
  function string convert2string();
    string s;
    s= $sformatf("FIFO_TXN: wr_en=%0b|wdata=%0h|rd_en=%0b|rdata=%0h|full=%0b|empty=%0b|almost_full=%0b|almost_empty=%0b",wr_en,wdata,rd_en,rdata,full,empty,almost_full,almost_empty);
    return s;
  endfunction
  
endclass
