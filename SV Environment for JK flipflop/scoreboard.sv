// Code your design here

class scoreboard;

int packet_count = 1;

mailbox #(packet) mbox2;
mailbox #(packet) mbox3;
packet imon_pkt;
packet omon_pkt;
int monin_cnt;
int monout_cnt;
int total_count = 1;

bit [9:0]match;
bit [9:0]mismatch;
bit [9:0]blackhole;
event compare_pkt;

function new(input mailbox #(packet) mbox2_in, input mailbox #(packet) mbox3_in);
	mbox2 = mbox2_in;
	mbox3 = mbox3_in;
endfunction

task run();
	$display("@%0t [SCB] Scoreboard run started",$time);
	imon_pkt = new();
	omon_pkt = new();
	fork
	begin
		while(1)
		begin
			monin_cnt++;
			mbox2.get(imon_pkt);
			$display("@%0t [SCB:MONIN] packet %0d received. jk = %b exp = %d",$time,monin_cnt,imon_pkt.jk,imon_pkt.exp);
			-> compare_pkt;
		end
	end
	begin
		while(1)
		begin
			monout_cnt++;
			mbox3.get(omon_pkt);
			$display("@%0t [SCB:MONOUT] packet = %0d recieved. jk = %b q = %0d",$time,monout_cnt,omon_pkt.jk,omon_pkt.q);
			
			@(compare_pkt);
			if(imon_pkt.exp == omon_pkt.q && imon_pkt.jk == omon_pkt.jk)
			begin
				$display("[SCB] Pass exp = %0d q = %0d",imon_pkt.exp,omon_pkt.q);
				match = match+1;
			end
			else if(imon_pkt.exp != omon_pkt.q)
			begin
				$display("[SCB] Fail exp = %0d q = %0d",imon_pkt.exp,omon_pkt.q);
				mismatch = mismatch+1;
			end
			else
			begin
				$display("[SCB] Fail reason unknown exp = %0d q = %0d",imon_pkt.exp,omon_pkt.q);
				blackhole = blackhole+1;
			end
			
			$display("[SCB] FINAL RESULT \tMATCH = %0d\tMISMATCH = %0d\tBLACKHOLE = %0d",match,mismatch,blackhole);
			total_count++;
		end
	end
	join
endtask

endclass
			