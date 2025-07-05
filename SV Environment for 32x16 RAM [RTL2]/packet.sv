class base_packet;
  
  rand logic wr;
  rand logic rd;
  rand logic [ADDR_WIDTH - 1:0] addr;
  rand logic [DATA_WIDTH - 1:0] wdata;
  
  logic [DATA_WIDTH - 1:0] rdata;
  logic response;
  
  int count ;
  bit [ADDR_WIDTH - 1 : 0] addr_temp;
  bit [DATA_WIDTH - 1 : 0] wdata_temp;
  
  task print(input string call);
    $display("\n||||||||| Print packet called from [%0s] |||||||||",call);
    $display("|\t\t wr = %0d\t\t\t\t |",wr);
    $display("|\t\t rd = %0d\t\t\t\t |",rd);
    $display("|\t\t addr = 0x%h\t\t\t |",addr);
    $display("|\t\t wdata = 0x%h\t\t |",wdata);
    $display("|\t\t rdata = 0x%h\t\t |",rdata);
    $display("|\t\t response = %0d\t\t\t |",response);
    $display("||||||||||||||||||||||||||||||||||||||||||||||||||");
  endtask : print
  
  virtual function void copy (base_packet p);
    if(p == null)
      begin
        $display("[base_packet] Error null object passed to copy method\n");
      end
    else
      begin
        this.addr = p.addr;
        this.wr = p.wr;
        this.rd = p.rd;
        this.wdata = p.wdata;
        this.rdata = p.rdata;
        this.response = p.response;
      end
  endfunction : copy
  
endclass : base_packet



////////////////////////////////////////
class random_packet extends base_packet;
  
//   //TO CHECK WORKING OF NON REPETITION OF addr and wdata
//   constraint c420 {
//     addr inside {0,1};
//     wdata inside {32'h420,32'h840};
//   }  
  
  constraint C69 {
    addr != addr_temp;
    wdata != wdata_temp;               
  }

  function void pre_randomize();
    if(count != 0)
      begin
        addr_temp = addr;
        wdata_temp = wdata;  
      end      
  endfunction : pre_randomize
  
//   virtual function void copy (base_packet p);
//     if(p == null)
//       begin
//         $display("[random_packet] Error Null object passed to copy method\n"); 
//       end
//     else
//       begin
//         this.addr = p.addr;
//         this.wr = p.wr;
//         this.rd = p.rd;
//         this.wdata = p.wdata;
//         this.rdata = p.rdata;
//         this.response = p.response;
//       end
//   endfunction : copy
  
endclass : random_packet


///////////////////////////////////////////
class wr_rd_all_packet extends base_packet;
  
  bit i = 1;		// wr variable for PR
  bit [3:0] j = 0;		// ADDRESS VARIABLE for PR
  
  constraint C1 {	wr == i; 	}
  constraint C2 {   wr != rd; 	}
  constraint c3 { addr == j;  }
  
  function void post_randomize();
    count = count+1;
    j = j+1;
    if(count%16 == 0)
      i = ~i;
  endfunction : post_randomize
  
  virtual function void copy (base_packet p);
    if(p == null)
      begin
        $display("[random_packet] Error Null object passed to copy method\n"); 
      end
    else
      begin
        this.addr = p.addr;
        this.wr = p.wr;
        this.rd = p.rd;
        this.wdata = p.wdata;
        this.rdata = p.rdata;
        this.response = p.response;
      end
  endfunction : copy
  
endclass : wr_rd_all_packet



//////////////////////////////////////////////////////
class altnt_wr_rd_packet extends base_packet;
  
  bit i = 1;			// wr variable for PR
  bit [3:0] j = 0;		// ADDRESS VARIABLE for PR
  int count;			// FOR PR callback operations
  
  constraint C1 {	wr == i; 	rd == ~i; }
  constraint c2 {   addr == j;  }
  
  function void post_randomize();  
    i = ~i;
    count++;
    if(count%2 == 0)
      j = j+1;
  endfunction : post_randomize
  
  virtual function void copy (base_packet p);
    if(p == null)
      begin
        $display("[random_packet] Error Null object passed to copy method\n"); 
      end
    else
      begin
        this.addr = p.addr;
        this.wr = p.wr;
        this.rd = p.rd;
        this.wdata = p.wdata;
        this.rdata = p.rdata;
        this.response = p.response;
      end
  endfunction : copy
  
endclass : altnt_wr_rd_packet
