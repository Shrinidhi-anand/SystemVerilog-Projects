class env;
  
  virtual mem_interface.DRV drv_mod;
  virtual mem_interface.IN_MON in_mon_mod;
  virtual mem_interface.OUT_MON out_mon_mod;
  int pkt_count;
  
  mailbox #(base_packet) gen_drv_mbox;
  mailbox #(base_packet) in_mon_scb_mbox;
  mailbox #(base_packet) out_mon_scb_mbox;
  
  generator gen;
  driver drv;
  in_monitor in_mon;
  out_monitor out_mon;
  scoreboard scb;
  
  function new(input virtual mem_interface.DRV drv_in, input virtual  mem_interface.IN_MON in_mon_in,input virtual mem_interface.OUT_MON out_mon_in, input int no_of_pkts);
    drv_mod = drv_in;
    in_mon_mod = in_mon_in;
    out_mon_mod = out_mon_in;
    pkt_count = no_of_pkts;
  endfunction : new
  
  task build();
    $display("[Env:build] Environment build started");
    gen_drv_mbox = new;
    in_mon_scb_mbox = new;
    out_mon_scb_mbox = new();
    
    gen = new(gen_drv_mbox,pkt_count);
    drv = new(gen_drv_mbox, drv_mod);
    in_mon = new(in_mon_scb_mbox,in_mon_mod);
    out_mon = new(out_mon_scb_mbox,out_mon_mod);
    scb = new(in_mon_scb_mbox , out_mon_scb_mbox, pkt_count);
    $display("[Env:build] Environment build ended");
  endtask
  
  task run();
    $display("@%0t [Env : run] Simulation started",$time);
//     gen.run();
    fork
      gen.run();
      drv.run();						//&&&&&&&&&&&&&
      in_mon.run();						//&&&&&&&&&&&&&
      out_mon.run();					//&&&&&&&&&&&&&
      scb.run();						//&&&&&&&&&&&&&
//       wait(pkt_count == scb.no_pkts);	//&&&&&&&&&&&&
    join_none;  
    wait(pkt_count == scb.no_pkts);
    
    $display("@%0t [Env ; run] Simulation finished",$time); 
    scb.final_report(); 
  endtask : run
         
  //SCOREBOARD LOGIC
    
endclass : env
  