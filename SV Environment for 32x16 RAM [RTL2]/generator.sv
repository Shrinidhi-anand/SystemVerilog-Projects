class generator;
  
  int no_pkts;			// for keeping track while randomizing
  
  base_packet pkt,ref_pkt;
  
  mailbox #(base_packet) gen_drv_mbox;
  
  function new(input mailbox#(base_packet) mbox_in,input int packet_count = 1);
    no_pkts = packet_count;
    gen_drv_mbox = mbox_in;
    pkt = new();
  endfunction : new
  
  task run();
    $display("[@%0t] [GENERATOR] Run started \n",$time);
    //pkt = new();
    repeat(no_pkts)
      begin
        //pkt = new();
        assert(pkt.randomize());
        ref_pkt = new();
        ref_pkt.copy(pkt);
        
        //Since object creation is done only once, the mailbox pointer points to the same object each time thereby resulting in the last randomized value.
        //gen_drv_mbox.put(pkt);	
        
        gen_drv_mbox.put(ref_pkt);
        pkt.print("GEN");
      end
    
    $display("[@%0t] [GENERATOR] run ended size of mbox = %0d \n",$time,gen_drv_mbox.num());
    
  endtask : run
  
endclass : generator