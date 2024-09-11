// Code your design here

`include ram_parameter.sv"

interface ram_interface(input bit clk,rst);
  logic rd_en,wr_en;
  logic [DATA_WIDTH : 0]data_in;
  logic [ADDR_WIDTH:0] addr;
  logic [DATA_WIDTH:0] data_out;
  
  clocking drv_cb@(posedge clk);
    default input #0 output #0;
    output rd_en,wr_en,data_in,addr;
    input rst;
  endclocking
  
  clocking imon_cb@(posedge clk);
    default input #0 output #0;
    input wr_en,rd_en,data_in,addr,rst;
  endclocking
  
  clocking omon_cb @(posedge clk);
    default input #0 output #0;
    input rd_en,data_out,addr,rst;
  endclocking
  
  modport DRV(clocking drv_cb);
    modport IMON(clocking imon_cb);
      modport OMON(clocking omon_cb);
        endinterface
 
