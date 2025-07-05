// Code your design here

class monitorout;

virtual jkif.OMON vif;
mailbox #(packet) mbox3;

int no_of_pkts = 1;

packet pkt;

function new(input mailbox #(packet) mbox_in, input virtual jkif.OMON vif_in);
	mbox3 = mbox_in;
	vif = vif_in;
endfunction

task run();
	$display("@%0t [MONOUT] Output monitor run started",$time);
	//@(vif.omon_cb);
	pkt = new;
	while(1)
	begin
		@(vif.omon_cb);
		//pkt = new;
		pkt.jk = vif.omon_cb.jk;
		pkt.q = vif.omon_cb.q;
		$display("@%0t 		[MONOUT:run] pkt no %0d rst = %0d jk = %b q = %d",$time,no_of_pkts,top.rst,pkt.jk,pkt.q);
		no_of_pkts++;
		mbox3.put(pkt);
	end
	$display("@%0t [MONOUT] Output monitor run ended",$time);
endtask 

endclass