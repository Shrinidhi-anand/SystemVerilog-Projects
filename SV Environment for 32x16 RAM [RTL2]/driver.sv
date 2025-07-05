class driver;
  
  base_packet pkt;
  
  mailbox #(base_packet) mbox1;
  
  virtual mem_interface.DRV drv_mod;
  
  int pkt_count;
  
  covergroup memory_drv_cg;
    option.per_instance = 1;
    cp_WRITE : coverpoint pkt.wr { bins b_wr[] = {0,1}; }
    cp_READ : coverpoint pkt.rd { bins b_rd[] = {0,1}; }
    cp_DATA_IN : coverpoint pkt.wdata {bins b_data_in = {[0:32'h10000000]};}
    cp_ADDRESS : coverpoint pkt.addr {bins b_addrlow[] = {[0:7]};
      bins b_addrmid = {[7:12]};
          bins b_addrhigh[] = {[13 : MEM_SIZE - 1] };
    }
    cr_WRXRD : cross cp_WRITE,cp_READ {ignore_bins cr_wr0_rd0 = binsof(cp_WRITE) intersect {0} && binsof(cp_READ) intersect{0};
    }
  endgroup : memory_drv_cg
  
  function new(input mailbox #(base_packet) mbox_in, input virtual mem_interface.DRV mod_in);
    mbox1 = mbox_in;
    drv_mod = mod_in;
    if(drv_mod == null)
      $display("[DRIVER] FATAL Interface handle not set");
    memory_drv_cg = new();
  endfunction : new
  
  task run;
    $display("[@%0t] [DRIVER] run started",$time);
	wait(!top.rst);
	while(1)
      begin
        mbox1.get(pkt);
        pkt_count++;
        memory_drv_cg.sample();			// &&&&&&&&&&&&&&&&&&&&&&&&&&&
        drive_to_design();
      end
   endtask : run
  
  task drive_to_design();
    @(drv_mod.drv_cb);
    drv_mod.drv_cb.wr <= pkt.wr;
    drv_mod.drv_cb.rd <= pkt.rd;
    drv_mod.drv_cb.addr <= pkt.addr;
    drv_mod.drv_cb.wdata <= pkt.wdata;
    $display("[@%0t] Driven packet no : %0d",$time,pkt_count);
  endtask : drive_to_design
  
endclass : driver