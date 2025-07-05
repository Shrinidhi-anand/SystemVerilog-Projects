// Code your design here

class envjk;

/*										////NOT REQUIRED SINCE WE ARE USING FILELIST.TXT HERE
`include "packetjk.sv"
`include "generatorjk.sv"
`include "driverjk.sv"
`include "monitor_injk.sv"
`include "monitor_outjk.sv"
`include "scoreboardjk.sv"
*/

virtual jkif.DRV vif_drv;
virtual jkif.IMON vif_imon;
virtual jkif.OMON vif_omon;
int no_of_pkts;

										
gtr gen;								////Uncomment after writing generator
driver drv;									////Uncomment after writing driver
monitorin monin;								////Uncomment after writing input monitor
monitorout monout;								////Uncomment after writing output monitor
scoreboard scb;								////Uncomment after writing scoreboard


mailbox #(packet) gen_drv_mbox;							////Uncomment after packet.sv file
mailbox #(packet) monin_scb_mbox;
mailbox #(packet) monout_scb_mbox;


function new(input virtual jkif.DRV drv, input virtual jkif.IMON imon, input virtual jkif.OMON omon, input int no_of_pkts);
	vif_drv = drv;
	vif_imon = imon;
	vif_omon = omon;
	this.no_of_pkts = no_of_pkts;
endfunction

task build();
	$display("@%0t [Env:build] Environment build started",$time);
	gen_drv_mbox = new();							////Uncomment after writing all components
	monin_scb_mbox = new();
	monout_scb_mbox = new();
	gen = new(gen_drv_mbox,no_of_pkts);
	drv = new(gen_drv_mbox,vif_drv);
	monin = new(monin_scb_mbox, vif_imon);
	monout = new(monout_scb_mbox, vif_omon);
	scb = new(monin_scb_mbox, monout_scb_mbox);
	
	$display("@%0t [Env:build] Environment build ended",$time);
endtask

task run();
	$display("@%0t [Env:run] Environment run started",$time);
	
	gen.run();								////Uncomment after writing all components
	fork
		drv.run();
		monin.run();
		monout.run();
		scb.run();
		wait(no_of_pkts == scb.total_count-1);				////We have used count = 1 initially itself in the two monitor blocks and scoreboard (for display statement 												convenience) Hence -1 for the exit condition
		
	join_any
	disable fork;
	
	$display("@%0t [Env:run] Environment run finished",$time);
	final_result();
endtask


task final_result();								////Uncomment after writing all components
	$display("Total packets sent to DUV = %0d",no_of_pkts);
	$display("Matches = %0d",scb.match);
	$display("Mismatch = %0d",scb.mismatch);
	$display("Unknown = %0d",scb.blackhole);

	if(scb.match == no_of_pkts && scb.mismatch == 0)
	begin
		$display("**************************");
		$display("**********PASS************");
		$display("**************************");
	end	
	else
	begin
		$display("**************************");
		$display("**********FAIL************");
		$display("**************************");
	end
endtask


endclass









	
