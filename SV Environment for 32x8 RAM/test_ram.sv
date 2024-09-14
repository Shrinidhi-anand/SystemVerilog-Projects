//********************TEST******************//
////filename test_ram.sv
class test_ram;
  int no_of_pkts = 40;
  virtual ram_interface.DRV vif_drv;
  virtual ram_interface.IMON vif_imon;
  virtual ram_interface.OMON vif_omon;
  
  env_ram env;
  
  function new (input virtual ram_interface.DRV drv, input virtual ram_interface.IMON imon, input virtual ram_interface.OMON omon);
    vif_drv = drv;
    vif_imon = imon;
    vif_omon = omon;
  endfunction
  
  virtual task run();
    $display("@%0t[Test:run] simulation started",$time);
    
    env = new(vif_drv,vif_imon,vif_omon,no_of_pkts);
    env.build();
    env.run();
    $display("Packets = %0d",no_of_pkts);
    $display("@%0t [Test:run] simulation finished",$time);
  endtask
endclass
        

class test_ram_wr_rd extends test_ram;
  packet_wr_rd pkt_wr_rd;
  
  function new(input virtual ram_interface.DRV drv, input virtual ram_interface.IMON imon, input virtual ram_interface.OMON omon);
    super.new(drv,imon,omon);
  endfunction
  
  virtual task run();
    $display("@%0t [Test:wr_rd : run] Simulation started",$time);
    $display("Packets = %0d",super.no_of_pkts);
    
    env = new(vif_drv,vif_imon,vif_omon,super.no_of_pkts);
    env.build();
    pkt_wr_rd = new();
    env.gen.ref_pkt = pkt_wr_rd;
    env.run();
    $display("@%0t [Test-wr_rd : run] Simulation finished",$time);
  endtask
endclass
        
class test_ram_wrall_rdall extends test_ram;
  packet_wrall_rdall pkt_wrall_rdall;
  
  function new(input virtual ram_interface.DRV drv, input virtual ram_interface.IMON imon, input virtual ram_interface.OMON omon);
    super.new(drv,imon,omon);
  endfunction
  
  virtual task run();
    $display("@%0t [Test - wr_all rdall : run] Simulation Started",$time);
    $display("Packets = %0d",super.no_of_pkts);
    env = new(vif_drv,vif_imon,vif_omon,super.no_of_pkts);
    env.build();
    
    pkt_wrall_rdall = new();
    env.gen.ref_pkt = pkt_wrall_rdall;
    env.run();
    $display("@%0t [Test-wrall_rdall : run] simulation finished",$time);
  endtask 
endclass
