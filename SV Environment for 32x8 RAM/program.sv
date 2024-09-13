//*************PROGRAM********************//
////filename program_ram.sv
program program_ram(ram_interface vif);
  test_ram test;
  test_ram_wr_rd test_wr_rd;
  test_ram_wrall_rdall test_wrall_rdall;
  
  initial
    begin
      
      $display("@%0t [PRG] Simulation started",$time);
      test = new(vif.DRV,vif.IMON,vif.OMON);
      test.run();
      $display("@%0t [PRG] Simulation finshed",$time);
      
      $display("@%0t [PRG wr_rd] Simulation started",$time);
      test_wr_rd = new(vif.DRV,vif.IMON,vif.OMON);
      test_wr_rd.run();
      $display("@%0t [PRG] Simulation finshed",$time);
      
      $display("@%0t [PRG wrall_rdall] Simulation started",$time);
      test_wrall_rdall = new(vif.DRV,vif.IMON,vif.OMON);
      test_wrall_rdall.run();
      $display("@%0t [PRG] Simulation finshed",$time);
      $finish();
    end
endprogram
