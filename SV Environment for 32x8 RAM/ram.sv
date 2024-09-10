//***********************DESIGN*******************//
module ram ( clk,rst,data_in,rd_en,wr_en,addr,data_out);
  
  input clk,rst,rd_en,wr_en;
  input [DATA_WIDTH:0] data_in;
  input [ADDR_WIDTH:0]addr;
  output logic [DATA_WIDTH:0]data_out;
  integer i;
  logic [DATA_WIDTH:0]mem[MEM_SIZE:0];
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          for(i=0;i<=MEM_SIZE;i=i+1)
            mem[i] <= 8'dx;
        end
      else if(wr_en == 1)
        mem[addr] <= data_in;
    end
  
  always@(posedge clk)
    begin
      if(rst)
        data_out <= 8'dx;
      else if(rd_en == 1)
        data_out <= mem[addr];
      else
        data_out <= 8'dx;
    end
endmodule
