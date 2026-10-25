module top;
  logic clk;
  
  
  initial clk=0;
  always #5 clk=~clk;
  
  fifo_if intf(clk);
  
  fifo DUT(.clk(intf.clk),
           .rst_n(intf.rst_n),
           .wr_en(intf.wr_en),
           .wdata(intf.wdata),
           .rd_en(intf.rd_en),
           .rdata(intf.rdata),
           .full(intf.full),
           .almost_full(intf.almost_full),
           .empty(intf.empty),
           .almost_empty(intf.almost_empty)
          );
  
  //============================================
  //				ASSERTIONS					
  //============================================
  
  //no write success when full
  property p_no_write_when_full;
    @(posedge clk) disable iff(!intf.rst_n)
    (intf.wr_en && intf.full)|=> $stable(DUT.counter);
  endproperty
  
  a_no_write_when_full: assert property (p_no_write_when_full)
    else $error("ASSERTION FAILED, counter changed after write when full at %0t",$time);
    
  
  property p_no_read_when_empty;
  @(posedge clk) disable iff(!intf.rst_n)
    (intf.rd_en && intf.empty && !intf.wr_en)|=> $stable(DUT.counter);
  endproperty
    
    a_no_read_when_empty: assert property (p_no_read_when_empty)
      else $error("ASSERTION FAILED, counter changed after read when empty at %0t",$time);
      
      property p_counter_bound;
        @(posedge clk) disable iff(!intf.rst_n)
        (DUT.counter>=0)&&(DUT.counter<=16);
      endproperty
      
      a_counter_bound: assert property (p_counter_bound)
        else $error("ASSERTION FAILED, counter exceeded the boundaries at %0t",$time);
        
  
  initial begin
    intf.rst_n=0;
    #14;
    intf.rst_n=1;
  end
  
  initial begin
    uvm_config_db #(virtual fifo_if)::set(null,"*","vif",intf);
    run_test("fifo_test");
  end
endmodule
    
