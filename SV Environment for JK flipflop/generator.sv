// Code your design here

class gtr;
int no_of_pkts;

packet pkt;										////Uncomment after writing packet code
packet ref_pkt;

mailbox #(packet) mbox1;								////Uncomment after writing packet code

function new (mailbox #(packet) mbox_in, int gen_pkts);					////Uncomment after writing packet code
	mbox1 = mbox_in;
	this.no_of_pkts = gen_pkts;
	ref_pkt = new();
endfunction : new

task run();
	int pkt_count;
	$display("@%0t [Gen:run] Generator run started",$time);
	repeat(no_of_pkts)								
	begin
		assert(ref_pkt.randomize());						////Uncomment after writing packet code
		pkt = new();
		pkt.copy(ref_pkt);
		mbox1.put(pkt);
		pkt_count = pkt_count + 1;
		pkt.print();
		$display("@%0t [Gen:run] Sent packet %0d to driver",$time,pkt_count);
	end
	$display("@%0t [Gen:run] Generator run ended",$time);
endtask

endclass
		