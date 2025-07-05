// Code your design here

module JKFF (jk,rst,clk,q);
input [1:0]jk;
input clk,rst;
output reg q;

always@(posedge clk)
begin
	if(!rst)
	begin
		case(jk)
			2'b00: q <= q;
			2'b01: q <= 0;
			2'b10: q <= 1;
			2'b11: q <= ~q;
			default: q <= 0;	
		endcase
	end
	else
	begin
		q <= 0;
	end
end

endmodule	