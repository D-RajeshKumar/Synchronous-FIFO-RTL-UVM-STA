module fifo #(parameter DEPTH=16,
        parameter WIDTH=8,
        parameter ADDR_WIDTH=$clog2(DEPTH),
        parameter ALMOST_FULL_THRES=DEPTH-1,
        parameter ALMOST_EMPTY_THRES=1
        )
        (
            input wire clk,
            input wire rst_n,
            //for write
            input wire wr_en,
            input wire [WIDTH-1:0] wdata,
            //for read
            input wire rd_en,
            output reg [WIDTH-1:0] rdata,
            //for flags
            output wire full,
            output wire empty,
            output wire almost_full,
            output wire almost_empty
        );
        //memory buffer with depth and width
        reg [WIDTH-1:0] mem [0:DEPTH-1];
        //pointers for address accessing
        reg [ADDR_WIDTH-1:0] wptr;
        reg [ADDR_WIDTH-1:0] rptr;
        //optional counter
        reg [ADDR_WIDTH:0] counter;


        //write logic
        always@(posedge clk or negedge rst_n)begin
            if(!rst_n)begin
                wptr<=0;
            end
            else if(wr_en && (~full))begin
                mem[wptr]<=wdata;
                wptr<=wptr+1'b1;
            end
        end

        //read logic
        always@(posedge clk or negedge rst_n)begin
            if(!rst_n)begin
                rptr<=0;
                rdata<=0;
            end
            else if(rd_en && (~empty))begin
                rdata<=mem[rptr];
                rptr<=rptr+1'b1;
            end
        end

        //COUNTER LOGIC
        always@(posedge clk or negedge rst_n)begin
            if(!rst_n)begin
                counter<='0;
            end
            else begin
                case({(wr_en && !full),(rd_en && !empty)})
                2'b10: counter<=counter+1'b1;
                2'b01: counter<=counter-1'b1;
                2'b11: counter<=counter;  
                default: counter<=counter;
                endcase
            end
        end
        //FLAGS
        assign full = (counter == DEPTH);
        assign empty=(counter == 0);

        assign almost_full = (counter>=ALMOST_FULL_THRES);
        assign almost_empty = (counter<=ALMOST_EMPTY_THRES);

endmodule
