interface mem_interface(input bit clk,rst);
  
  bit wr;
  bit rd;
  bit [ADDR_WIDTH - 1:0] addr;
  bit [DATA_WIDTH - 1:0] wdata;
  logic [DATA_WIDTH - 1:0] rdata;
  logic response;
  
  clocking drv_cb @ (posedge clk);
    default input #0 output #0;
    output wr,rd;
    output addr,wdata;
    input rst;
  endclocking : drv_cb
  
  clocking in_mon_cb @ (posedge clk);
    default input #0 output #0;
    input wr,rd;
    input addr,wdata,rdata;
    input response;
    input rst;
  endclocking : in_mon_cb
  
  clocking out_mon_cb @ (posedge clk);
    default input #0 output #0;
    input wr,rd;
    input addr,wdata,rdata;
    input response;
    input rst;
  endclocking : out_mon_cb
  
  modport DRV(clocking drv_cb);
    modport IN_MON(clocking in_mon_cb);
      modport OUT_MON(clocking out_mon_cb);
  
endinterface : mem_interface
  
