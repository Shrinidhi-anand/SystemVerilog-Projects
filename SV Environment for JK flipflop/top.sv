// Code your design here

module top();
bit [1:0]jk;
logic clk;
logic rst;
logic q;

initial
begin
	clk = 0;
	forever #10 clk = ~clk;
end

initial
begin
	rst = 1;
	repeat(5)
	begin
		@(posedge clk);
	end
	rst = 0;
end

jkif vif(clk,rst);
JKFF J1(.jk(vif.jk),.rst(rst),.clk(clk),.q(vif.q));
pgm P1(vif);

endmodule