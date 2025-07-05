class out_monitor;
  
  mailbox #(base_packet) mbox3;
  int no_pkts = 1,rd_pkts,wr_pkts;
  virtual mem_interface.OUT_MON out_mon_mod;
  base_packet pkt;
  
  covergroup mem_omon_cg;
    cp_DATA_OUT : coverpoint pkt.rdata { bins b_data_out = { [ 0:255] }; }
    cp_RESPONSE : coverpoint pkt.rdata { bins b_rdata = { 0,1 }; }
  endgroup : mem_omon_cg
  
  function new(input mailbox #(base_packet) mbox_in, input virtual mem_interface.OUT_MON mod_in);
    mbox3 = mbox_in;
    out_mon_mod = mod_in;
    mem_omon_cg = new();
  endfunction : new
  
  task run();
    $display("[@%0t] [OMON] Run started\n",$time);
    @(out_mon_mod.out_mon_cb);
    while(1)
      begin
        @(out_mon_mod.out_mon_cb);
        pkt = new;
        pkt.wr = out_mon_mod.out_mon_cb.wr;
        pkt.rd = out_mon_mod.out_mon_cb.rd;
        pkt.addr = out_mon_mod.out_mon_cb.addr;
        
        
        if(out_mon_mod.out_mon_cb.rd == 1 && out_mon_mod.out_mon_cb.wr == 0)
          begin
            pkt.rdata = out_mon_mod.out_mon_cb.rdata;
            $display("[@%0t] [MONOUT READ] Packet no = %0d to scb with\t\taddr = 0x%h\t\tread_data = 0x%h", $time, no_pkts, out_mon_mod.out_mon_cb.addr, out_mon_mod.out_mon_cb.rdata);
            rd_pkts++;  
          end

            
        else if(out_mon_mod.out_mon_cb.rd == 0 && out_mon_mod.out_mon_cb.wr == 1)
          begin
            pkt.wdata = out_mon_mod.out_mon_cb.wdata;
            pkt.response = out_mon_mod.out_mon_cb.response;
            $display("[@%0t] [MONOUT WRITE] Packet no =%0d to scb with\t\taddr = 0x%h\t\twdata = 0x%h\t\tresponse = %0d", $time, no_pkts, out_mon_mod.out_mon_cb.addr, out_mon_mod.out_mon_cb.wdata, out_mon_mod.out_mon_cb.response);
            wr_pkts++;  
          end
        
        else if(out_mon_mod.out_mon_cb.rd == 0 && out_mon_mod.out_mon_cb.wr == 0)
          begin
            $display("[@%0t] [MONOUT] No Operations being performed",$time);
          end
        
        else if(out_mon_mod.out_mon_cb.rd == 1 && out_mon_mod.out_mon_cb.wr == 1)
          begin
            pkt.wdata = out_mon_mod.out_mon_cb.wdata;
            pkt.response = out_mon_mod.out_mon_cb.response;
            pkt.rdata = out_mon_mod.out_mon_cb.rdata;
            wr_pkts++;
            rd_pkts++;
            $display("[@%0t] [MONOUT WRITE & READ] Packet no =%0d to scb with\t\taddr = 0x%h\t\twdata = 0x%h\t\tresponse = %0d\t\trdata = 0x%0h", $time, no_pkts, out_mon_mod.out_mon_cb.addr, out_mon_mod.out_mon_cb.wdata, out_mon_mod.out_mon_cb.response,out_mon_mod.out_mon_cb.rdata);
          end
        
        no_pkts++;
        mbox3.put(pkt);  
        mem_omon_cg.sample();			//&&&&&&&&&&&&&&&&&&&&&&&&&&&&
      end
    $display("[@%0t] [OMON] Writes : %0d\t\t Reads : %0d", $time, wr_pkts, rd_pkts);
    $display("[@%0t] [OMON] Run ended \n",$time);
  endtask
  
endclass : out_monitor 