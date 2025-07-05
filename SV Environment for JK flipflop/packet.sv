// Code your design here

class packet;

rand bit [1:0]jk;
logic q;
logic exp;

virtual function void print();
	$display("@%0t [Packet] jk = %b q = %0d",$time,jk,q);
endfunction

virtual function copy(packet p);
	if(p == null)
	begin
		$display("Null object passed");
	end
	else
	begin
		this.jk = p.jk;
		this.q = p.q;
	end
endfunction

endclass