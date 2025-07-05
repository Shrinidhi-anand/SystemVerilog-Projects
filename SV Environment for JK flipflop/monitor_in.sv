// Code your design here

class monitorin;

int no_of_pkts = 1;
//logic exp;										////Declared in pkt only
packet pkt;
virtual jkif.IMON vif_monin;
mailbox #(packet) mbox2;

function new (input mailbox #(packet) mbox_in, input virtual jkif.IMON vif_in);
	mbox2 = mbox_in;
	vif_monin = vif_in;
endfunction

task run();
	$display("@%0t [MONIN] Input Monitor run started",$time);
	pkt = new();
	while(1)
	begin 		
		@(vif_monin.imon_cb);
		//pkt = new();
		pkt.jk = vif_monin.imon_cb.jk;
		
		if(top.rst)
		begin
			pkt.exp=0;
		end
		else
		begin
			case(vif_monin.imon_cb.jk)
			2'b00:pkt.exp=pkt.exp;
			2'b01:pkt.exp=0;
			2'b10:pkt.exp=1;
			2'b11:pkt.exp=~pkt.exp;
			default:pkt.exp=0;
			endcase
		end
		$display("@%0t 		 [MONIN:run] pkt no %0d rst = %0d jk = %b exp = %0d",$time,no_of_pkts,top.rst,pkt.jk,pkt.exp);
		
		mbox2.put(pkt);
		no_of_pkts++;
	end
	
	$display("@%0t [MONIN] Input Monitor run ended",$time);
	
endtask

endclass