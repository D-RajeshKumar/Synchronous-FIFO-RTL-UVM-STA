interface fifo_if #(parameter DEPTH=16,parameter WIDTH=8)
  (input logic clk);
  logic rst_n;
  
  logic wr_en;
  logic [WIDTH-1:0] wdata;
  
  logic rd_en;
  logic [WIDTH-1:0] rdata;
  
  logic full;
  logic empty;
  logic almost_full;
  logic almost_empty;
  
  clocking drv_cb@(posedge clk);
    default input #1 output #1;
    //write signals
    output wr_en;
    output wdata;
    input full;
    input almost_full;
    
    //read signals
    output rd_en;
    input rdata;
    input empty;
    input almost_empty;
  endclocking
  
  clocking mon_cb@(posedge clk);
    default input #1 output #1;
    input wr_en;
    input wdata;
    input full;
    input almost_full;
    input rd_en;
    input rdata;
    input empty;
    input almost_empty;
  endclocking
  
endinterface
