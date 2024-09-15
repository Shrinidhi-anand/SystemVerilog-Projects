//// filename packet.sv
//***************************PACKET*********************//
class packet;
  
  rand bit rd_en,wr_en,rst;
  rand bit [DATA_WIDTH:0] data_in;
  rand logic [ADDR_WIDTH : 0]addr;
  
  logic [DATA_WIDTH : 0]data_out,data_out_monin;
  
  constraint valid {
    data_in inside { [ 0: ((2**(DATA_WIDTH+1)) - 1) ] };
    addr inside { [ 0: ((2**(ADDR_WIDTH+1)) - 1) ] };
    if(wr_en == 0)
      rd_en != 0;
    if(wr_en == 1)
      rd_en!=1;
  }
  
  virtual function void print(string s="packet");
    $display("@%0t [%s] addr = %0d data_in = %0d write = %0d read = %0d\n",$time,s,addr,data_in,wr_en,rd_en);
  endfunction
  
  virtual function void copy (packet p);
    if(p==null)
      begin
        $display("[Packet] Error null object passed to copy method\n");
      end
    else
      begin
        this.addr = p.addr;
        this.data_in = p.data_in;
        this.wr_en = p.wr_en;
        this.rd_en = p.rd_en;
      end
  endfunction
endclass



int l_addr;
bit tog;
bit l = 1;
bit m = 0;

class packet_wr_rd extends packet;
  
  constraint valid { 
    data_in inside { [ 0 : ((2**(DATA_WIDTH+1)) - 1) ] };
    addr inside { [ 0:MEM_SIZE]};
    addr == l_addr;
    /*if(wr_en == 0)
      rd_en != 0;
    if(wr_en == 1)
      rd_en != 1;*/
    wr_en == l;
    rd_en == m;
  }
        
  function void post_randomize();
      begin
        if(tog == 0)
          begin
            if(l_addr == MEM_SIZE)
              l_addr = 0;
            else
              begin 
                l = 0;
                m = 1;
                l_addr = l_addr;
                tog = ~tog;
              end
          end
        
          else
            begin
              if(l_addr == MEM_SIZE)
                l_addr = 0;
              else
                begin
              	  l = 1;
                  m = 0;
              	  l_addr = l_addr + 1;
               	  tog = ~tog;
            	end
            end
      end
  endfunction
    
  virtual function void copy (packet p);
      if (p == null)
        begin
          $display("[Packet] Error Null object passed to copy method\n");
        end
      else
        begin
          this.addr = p.addr;
          this.data_in = p.data_in;
          this.wr_en = p.wr_en;
          this.rd_en = p.rd_en;
        end
  endfunction

endclass
    


int al_addr;
bit count;
class packet_wrall_rdall extends packet;
      
      constraint valid { 
        data_in inside { [ 0:((2**(DATA_WIDTH+1)) - 1) ] };
        addr inside { [ 0:MEM_SIZE] };
        addr == al_addr;
        if ( wr_en == 0)
          rd_en != 0;
        if (wr_en == 1)
          rd_en != 1;
        if (count == 0)
        {
          wr_en == 1;
          rd_en == 0;
        }
        else
        {
          wr_en == 0;
          rd_en == 1;
        }
          }
          
          function void post_randomize();
        if(addr<MEM_SIZE)
          count = count;
        else
          count = ~count;
        
        if(addr < MEM_SIZE) 
          al_addr = al_addr + 1;
        else
          al_addr = 0;
        endfunction
        
        virtual function void copy( packet p);
          if (p == null)
        	begin
        	  $display("[Packet] Error Null object passed to copy method\n");
        	end
      	   else
        	 begin
          		this.addr = p.addr;
          		this.data_in = p.data_in;
	          	this.wr_en = p.wr_en;
          		this.rd_en = p.rd_en;
        	 end
    	 endfunction

endclass
