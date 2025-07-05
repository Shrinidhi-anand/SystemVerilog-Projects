// Code your design here

//`include "envjk.sv"
class jktest;

int no_of_pkts = 10;

virtual jkif.DRV vif_drv;
virtual jkif.IMON vif_imon;
virtual jkif.OMON vif_omon;

envjk env;											////Uncomment after writing env code

function new (input virtual jkif.DRV drv,input virtual jkif.IMON imon,input virtual jkif.OMON omon);
	vif_drv = drv;
	vif_imon = imon;
	vif_omon = omon;
endfunction : new


virtual task run();										////Uncomment after writing env code
	$display("@%0t [Test:run] Simulation started",$time);
	env = new(vif_drv,vif_imon,vif_omon,no_of_pkts);
	env.build();
	env.run();
												//// $display("@%0t testing access rst = %0d",$time,top.rst); - WORKS
	$display("@%0t Packets = %0d",$time,no_of_pkts);
	$display("@%0t [Test:run] Simulation finished",$time);
endtask


endclass
	