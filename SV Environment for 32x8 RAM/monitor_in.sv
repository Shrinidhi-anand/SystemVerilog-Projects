//**********IMON***************//
////filename monitor_in.sv     
class monitor_in;
  int no_of_pkts_rcvd;
  logic [DATA_WIDTH:0]ass_a[*];
  packet pkt;
  virtual ram_interface.IMON vif;
  mailbox #(packet) mbox;
  
  int wr_no_of_pkts;
  int rd_no_of_pkts;
  
  function new(input mailbox #(packet) mbox_in,input virtual ram_interface.IMON vif_in);
    mbox = mbox_in;
    vif = vif_in;
    if(this.vif == null)
      $display("[MONIN] Interface handle not set");
  endfunction
  
  task run();
    $display("@%0t [MONIN] run started\n",$time);
    
    while(1)
      begin
        @(vif.imon_cb);
        pkt = new;
        pkt.addr = vif.imon_cb.addr;
        pkt.data_in = vif.imon_cb.data_in;
        pkt.wr_en = vif.imon_cb.wr_en;
        pkt.rd_en = vif.imon_cb.rd_en;
        
        if(vif.imon_cb.wr_en == 1 && vif.imon_cb.rd_en == 0)
          begin  
            ass_a [ pkt.addr ] = vif.imon_cb.data_in;
            wr_no_of_pkts++;
            $display("@%0t [MONIN WRITE] Packet no = %0d to scb with addr = %0d data_in = %0d",$time,no_of_pkts_rcvd,vif.imon_cb.addr,ass_a[pkt.addr]);								//same as vif.imon_cb.data_in
            $display("********************");           		end
        
        else if(vif.imon_cb.wr_en == 0 && vif.imon_cb.rd_en == 1)
          begin
            rd_no_of_pkts++;
            if(ass_a.exists(pkt.addr))
              begin
                pkt.data_out_monin = ass_a[pkt.addr];
              end
            $display("@%0t [MONIN READ] Packet no = %0d to scb with addr = %0d data_out_monin = %0d ",$time,no_of_pkts_rcvd,vif.imon_cb.addr,pkt.data_out_monin);
            $display("************************");
          end
        mbox.put(pkt);
        no_of_pkts_rcvd++;
      end
    $display("@%0t [MONIN] run ended\n",$time);
  endtask
endclass
