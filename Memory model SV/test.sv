class base_test;
  
  int pkt_count;
  
  virtual mem_interface.DRV drv_mod;
  virtual mem_interface.IN_MON in_mon_mod;
  virtual mem_interface.OUT_MON out_mon_mod;
  
  env mem_env;
  
  function new(input virtual mem_interface.DRV drv_in, input virtual  mem_interface.IN_MON in_mon_in,input virtual mem_interface.OUT_MON out_mon_in, input int no_of_pkts);
    drv_mod = drv_in;
    in_mon_mod = in_mon_in;
    out_mon_mod = out_mon_in;
    pkt_count = no_of_pkts;
  endfunction : new
  
  virtual task run();
    $display("@%0t[Test:run] Simulation started",$time);
    
    mem_env = new(drv_mod,in_mon_mod,out_mon_mod,pkt_count);
    mem_env.build();
    mem_env.run();
  endtask : run

endclass : base_test




////////////////////////////////////
class random_test extends base_test;
  
  random_packet rand_pkt;
  
  function new(input virtual mem_interface.DRV drv_in, input virtual  mem_interface.IN_MON in_mon_in,input virtual mem_interface.OUT_MON out_mon_in, 
input int no_of_pkts);
    super.new(drv_in,in_mon_in,out_mon_in,no_of_pkts);
  endfunction : new
      
  task run();
    $display("@%0t [random_test:run] simulation started",$time);
    mem_env = new(drv_mod,in_mon_mod,out_mon_mod,pkt_count);
    mem_env.build();
    rand_pkt = new();
    mem_env.gen.pkt = rand_pkt;		// B = D
    mem_env.run();
    $display("@%0t [Test:run] simulation finished",$time);
  endtask : run
  
endclass : random_test

////////////////////////////////////
class wr_rd_all_test extends base_test;
  
  wr_rd_all_packet wr_rd_pkt;
  
  function new(input virtual mem_interface.DRV drv_in, input virtual  mem_interface.IN_MON in_mon_in,input virtual mem_interface.OUT_MON out_mon_in, 
input int no_of_pkts);
    super.new(drv_in,in_mon_in,out_mon_in,no_of_pkts);
  endfunction : new
      
  task run();
    $display("@%0t [random_test:run] simulation started",$time);
    mem_env = new(drv_mod,in_mon_mod,out_mon_mod,pkt_count);
    mem_env.build();
    wr_rd_pkt = new();
    mem_env.gen.pkt = wr_rd_pkt;
    mem_env.run();
    $display("@%0t [Test:run] simulation finished",$time);
  endtask : run
  
endclass : wr_rd_all_test


///////////////////////////////////////
class altnt_wr_rd_test extends base_test;
  
  altnt_wr_rd_packet alt_wr_rd_pkt;
  
  function new(input virtual mem_interface.DRV drv_in, input virtual  mem_interface.IN_MON in_mon_in,input virtual mem_interface.OUT_MON out_mon_in, 
input int no_of_pkts);
    super.new(drv_in,in_mon_in,out_mon_in,no_of_pkts);
  endfunction : new
      
  task run();
    $display("@%0t [random_test:run] simulation started",$time);
    mem_env = new(drv_mod,in_mon_mod,out_mon_mod,pkt_count);
    mem_env.build();
    alt_wr_rd_pkt = new();
    mem_env.gen.pkt = alt_wr_rd_pkt;
    mem_env.run();
    $display("@%0t [Test:run] simulation finished",$time);
  endtask : run
  
endclass : altnt_wr_rd_test