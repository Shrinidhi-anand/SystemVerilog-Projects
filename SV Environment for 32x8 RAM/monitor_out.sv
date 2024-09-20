//**********OMON***************//
////filename monitor_out.sv     
class monitor_out;
  
  int no_of_pkts_rcvd;
  packet pkt;
  
  virtual ram_interface.OMON vif;
  mailbox #(packet) mbox;
  
  covergroup ram_omon_cg;
    cp_DATA_OUT : coverpoint pkt.data_out { bins b_data_out = { [ 0:255] }; }
  endgroup
  
  function new ( input mailbox #(packet) mbox_in, input virtual ram_interface.OMON vif_in);
    
    mbox = mbox_in;
    vif = vif_in;
    ram_omon_cg = new();
  endfunction
  
  task run();
    $display("@%0t [MONOUT] Run started\n",$time);
    @(vif.omon_cb);
    while(1)
      begin
        @(vif.omon_cb);
        pkt = new;
        pkt.addr = vif.omon_cb.addr;
        pkt.data_out = vif.omon_cb.data_out;
        if(vif.omon_cb.addr != 5'dx)
          no_of_pkts_rcvd++;
        $display("@%0t [MONOUT] Packet no = %0d to scb with addr = %0d data_out = %0d",$time,no_of_pkts_rcvd,vif.omon_cb.addr,vif.omon_cb.data_out);
        mbox.put(pkt);
        ram_omon_cg.sample();
      end
    $display("@%0t [MONOUT] run ended \n",$time);
  endtask
endclass
