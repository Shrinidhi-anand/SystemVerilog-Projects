// Code your design here

interface jkif( input logic clk,logic rst);
bit [1:0]jk;
logic q;

clocking drv_cb@(posedge clk);
	default input #0 output #0;
	output jk;
	input rst;
endclocking

clocking imon_cb@(posedge clk);
	default input #0 output #0;
	input jk;
	input rst;
endclocking

clocking omon_cb@(posedge clk);
	default input #0 output #0;
	input jk,q;
	input rst;
endclocking

modport DRV (clocking drv_cb);
modport IMON (clocking imon_cb);
modport OMON (clocking omon_cb);

endinterface