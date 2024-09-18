////filename driver.sv
class driver;
  packet pkt;
  
  mailbox #(packet) mbox;
  
  virtual ram_interface.DRV vif_drv;
  
  int no_of_pkts_rcvd;
  int wr_pkt,rd_pkt;
  
  covergroup ram_drv_cg;
    cp_WRITE : coverpoint pkt.wr_en { bins b_wr[] = {0,1}; }
    cp_READ : coverpoint pkt.rd_en { bins b_rd[] = {0,1}; }
    cp_DATA_IN : coverpoint pkt.data_in {bins b_data_in = {[0:255]};}
    cp_ADDRESS : coverpoint pkt.addr {
      bins b_addrlow[] = {[0:10]};
      bins b_addrmid = {[11:MEM_SIZE - 10] };
      bins b_addrhigh[] = {[MEM_SIZE - 10+1 : MEM_SIZE] };
    }
    cr_WRXRD : cross cp_WRITE,cp_READ {
      ignore_bins cr_wr0_rd0 = binsof(cp_WRITE) intersect {0} && binsof(cp_READ) intersect{0};
      illegal_bins cr_wr1_rd1 = binsof(cp_WRITE) intersect{1} && binsof(cp_READ) intersect{1};
    }
  endgroup
  
  function new (input mailbox #(packet) mbox_in,input virtual ram_interface.DRV vif_in);
    mbox = mbox_in;
    vif_drv = vif_in;
    if(vif_drv == null)
      $display("[DRIVER] FATAL Interface handle not set");
    ram_drv_cg = new;
    
  endfunction
  
  virtual task run;
    $display("@%0t [DRIVER] run started\n",$time);
	wait(!ram_top.rst);
	while(1)
      begin
        mbox.get(pkt);
        no_of_pkts_rcvd++;
        ram_drv_cg.sample();
        drive_to_design();
      end
   endtask
	
   task drive_to_design();	 
     @(vif_drv.drv_cb);
     vif_drv.drv_cb.wr_en <= pkt.wr_en;
     vif_drv.drv_cb.rd_en <= pkt.rd_en;
     vif_drv.drv_cb.addr <= pkt.addr;
     vif_drv.drv_cb.data_in <= pkt.data_in;
     
     if(pkt.wr_en == 1 && pkt.rd_en == 0)
       begin
         $display("@%0t [DRIVER] Write operation pkt no = %0d addr = %0d data = %0d write = %0d read = %0d\n",$time,no_of_pkts_rcvd,pkt.addr,pkt.data_in,pkt.wr_en,pkt.rd_en);
         wr_pkt = wr_pkt + 1;
       end
     else if(pkt.wr_en == 0 & pkt.rd_en == 1)
       begin
         $display("@%0t [DRIVER] Read operation pkt no = %0d addr = %0d data = %0d write = %0d read = %0d\n",$time,no_of_pkts_rcvd,pkt.addr,pkt.data_in,pkt.wr_en,pkt.rd_en);
         rd_pkt = rd_pkt + 1;
       end
   endtask
endclass
