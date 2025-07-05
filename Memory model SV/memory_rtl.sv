//Synchronous write read memory

module memory_rtl (clk,reset,wr,rd,addr,wdata,rdata,response);

input   clk,reset;
input   wr;			// for write wr=1;
input   rd;			// for read  rd=1;
input   [ADDR_WIDTH-1:0] addr;
input   [DATA_WIDTH-1:0] wdata;
output  [DATA_WIDTH-1:0] rdata;
output response;

wire    [DATA_WIDTH-1:0] rdata;
reg     [DATA_WIDTH-1:0] mem [MEM_SIZE];
reg     [DATA_WIDTH-1:0] data_out;

reg response ;		//Provides response to master on successful write
reg out_enable;		//controls when to pass read data on rdata pin

//if rd=0 rdata should be in high impedance state
//if rd=1 rdata should be content of memory with given address
assign rdata = out_enable  ? data_out : 'bz;

//asynchronous reset and synchronous write
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        for(int i=0;i<MEM_SIZE;i++)
            mem[i] <= 'b0;
	end
    else if(wr ) begin
        mem[addr] <= wdata ;
        response <=1'b1;
     end
      else response <=1'b0;
end//end_of_write

//Synchronous Read
always @(posedge clk )
begin
  if(rd==1) begin
	  data_out <= mem[addr[3:0]] ;
          out_enable <= 1'b1;
   end
   else   out_enable <= 1'b0; 
end//end_of_read

endmodule

