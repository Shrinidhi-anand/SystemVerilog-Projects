// Code your testbench here
// or browse Examples
`include "memory_parameter.sv"
`include "mem_interface.sv"
`include "memory_rtl.sv"

`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "in_monitor.sv"
`include "out_monitor.sv"
`include "scoreboard.sv"

`include "env.sv"
`include "test.sv"

module top;

  bit clk;
  bit rst;
  
  int pkt_cnt = 40;
  
  random_test rand_tst;
  wr_rd_all_test wr_rd_all_tst;
  altnt_wr_rd_test alt_wr_rd_tst;

  initial
    begin
      forever #5 clk = ~clk;
    end

  initial
    begin
      rand_tst = new(vif.DRV,vif.IN_MON,vif.OUT_MON,pkt_cnt);
      wr_rd_all_tst = new(vif.DRV,vif.IN_MON,vif.OUT_MON,pkt_cnt);
      alt_wr_rd_tst = new(vif.DRV,vif.IN_MON,vif.OUT_MON,pkt_cnt);
      rst = 1;
      #40;
      rst = 0;
      
      #20;
      $display("*************************************************");
      $display("[TOP] Running Randomized test case");
      rand_tst.run();		// Running "all signals randomized" test case
      
//       #20;		 
//       $display("*************************************************");
//       $display("[TOP] Running wr all rd all test case");
//       wr_rd_all_tst.run();	// Running wr 16 and rd 16 locations test case
      
//       #20;		 
//       $display("*************************************************");
//       $display("[TOP] Running alternating wr rd test case");
//       alt_wr_rd_tst.run();	// Running wr 16 and rd 16 locations test case
      
    end
  
  initial
    begin
      $dumpvars(0,top);
      $dumpfile("waveform.vcd");
      #1000;
      $finish();
    end
  
  mem_interface vif(clk,rst);
  
  memory_rtl DUV(.clk(clk),.reset(rst),.wr(vif.wr),.rd(vif.rd),.addr(vif.addr),.wdata(vif.wdata),.rdata(vif.rdata),.response(vif.response));

endmodule : top