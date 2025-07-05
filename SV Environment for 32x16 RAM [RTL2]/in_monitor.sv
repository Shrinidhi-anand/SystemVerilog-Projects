class in_monitor;
  
  virtual mem_interface.IN_MON in_mon_mod;
  mailbox #(base_packet)  mbox2;
  base_packet pkt;
  int no_pkts = 1,rd_pkts,wr_pkts;
  int i;
  
  bit [DATA_WIDTH - 1:0] ass_a [*];
  
  function new(input mailbox #(base_packet) mbox_in, input virtual mem_interface.IN_MON mod_in);
    mbox2 = mbox_in;
    in_mon_mod = mod_in;
  endfunction : new
  
  task run();
    $display("[@%0t] [IMON] run started",$time);
    
    if(top.rst)
      begin
        for(i = 0;i<16;i++)
          begin
            ass_a[i] = 32'bz;
          end
      end
    
    wait(!top.rst);
    while(1)
      begin
        @(in_mon_mod.in_mon_cb);
        pkt = new;
        pkt.wr = in_mon_mod.in_mon_cb.wr;
        pkt.rd = in_mon_mod.in_mon_cb.rd;
        pkt.addr = in_mon_mod.in_mon_cb.addr;
        pkt.wdata = in_mon_mod.in_mon_cb.wdata;
        
        if(in_mon_mod.in_mon_cb.wr == 1 && in_mon_mod.in_mon_cb.rd == 0)
          begin  
            ass_a [in_mon_mod.in_mon_cb.addr] = in_mon_mod.in_mon_cb.wdata;
            pkt.response = 1;
            wr_pkts++;
            $display("[@%0t] [MONIN WRITE] Packet no = %0d to scb with\t\taddr = 0x%h\t\twdata = 0x%h\t\tresponse = %0d", $time,no_pkts, in_mon_mod.in_mon_cb.addr, in_mon_mod.in_mon_cb.wdata,pkt.response);
          end
        
        else if(in_mon_mod.in_mon_cb.wr == 0 && in_mon_mod.in_mon_cb.rd == 1)
          begin
            rd_pkts++;
            if(ass_a.exists(in_mon_mod.in_mon_cb.addr))
              begin
                pkt.rdata = ass_a[in_mon_mod.in_mon_cb.addr];
              end
            else
              begin
                pkt.rdata = 32'h0;
              end
            $display("[@%0t] [MONIN READ] Packet no = %0d to scb with \t\taddr = 0x%h\t\tref_rdata = 0x%h ",$time,no_pkts,in_mon_mod.in_mon_cb.addr,pkt.rdata);
          end
        
        else if(in_mon_mod.in_mon_cb.wr == 0 && in_mon_mod.in_mon_cb.rd == 0)
          begin
            $display("[@%0t] [MONIN] No Operations being performed ",$time);
          end
        
        else if(in_mon_mod.in_mon_cb.wr == 1 && in_mon_mod.in_mon_cb.rd == 1)
          begin
            wr_pkts++;
            rd_pkts++;
            // READING HERE
            if(ass_a.exists(in_mon_mod.in_mon_cb.addr))
              begin
                pkt.rdata = ass_a[in_mon_mod.in_mon_cb.addr];
              end
            else
              begin
                pkt.rdata = 32'h0;
              end
            // WRITING HERE
            ass_a [in_mon_mod.in_mon_cb.addr] = in_mon_mod.in_mon_cb.wdata;
            pkt.response = 1;
            $display("[@%0t] [MONIN WRITE & READ] Packet no = %0d to scb with\t\taddr = 0x%h\t\twdata = 0x%h\t\tresponse = %0d\t\trdata = 0x%0h", $time,no_pkts, in_mon_mod.in_mon_cb.addr, in_mon_mod.in_mon_cb.wdata,pkt.response,pkt.rdata);
          end
        if(pkt.wr == 0 && pkt.rd == 0 && pkt.addr == 0 && pkt.wdata == 0)
          $display("[@%0t] [MONIN] TRASH PACKET",$time);
        else
          begin
            mbox2.put(pkt);
            no_pkts++;
          end
      end 
    $display("[@%0t] [IN_MONITOR] run ended\n",$time);
  endtask : run
  
endclass : in_monitor