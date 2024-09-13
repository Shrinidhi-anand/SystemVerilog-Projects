////filename top.sv
module ram_top;
  
  //`include "ram_parameter.sv"
  bit clk,rst;
  
  initial
    begin
      clk = 0;
      forever #5 clk = ~clk;
    end
  
  initial
    begin
      $display("***********RESETing RAM************");
      @(posedge clk)
      rst <= 1;
      @(posedge clk)
      rst <= 0;
    end
  
  ram_interface ram_if(clk,rst);
  ram ram_duv(.clk(clk),.rst(rst),.data_in(ram_if.data_in),.rd_en(ram_if.rd_en),.wr_en(ram_if.wr_en),.addr(ram_if.addr),.data_out(ram_if.data_out));
  
  program_ram pgb(ram_if);
  
endmodule
