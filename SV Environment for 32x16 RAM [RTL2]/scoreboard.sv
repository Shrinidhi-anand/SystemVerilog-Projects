class scoreboard;
  
  mailbox #(base_packet) mbox_in;
  mailbox #(base_packet) mbox_out;
  base_packet imon_pkt;
  base_packet omon_pkt;
  
  int match;
  int miss;
  int mismatch;
  int sync_issue;
  int unknown;
  
  int imon_pkts;
  int omon_pkts;
  int wr_pkts;
  int rd_pkts;
  int missed_rd_pkts;
  int wr_rd_pkts;
  int idle_pkts;
  int no_pkts;
  int target_count;
  
  event compare_pkt;
  event final_report_event;
  
  function new(input mailbox #(base_packet) in_mbx, input mailbox #(base_packet) out_mbx, input int count);
    mbox_in = in_mbx;
    mbox_out = out_mbx;
    target_count = count;
  endfunction : new
  
  task run();
    $display("@%0t [SCB] Run started\n",$time);
    imon_pkt = new();
    omon_pkt = new();
    
    fork
      
      B1 : 
      begin
        while(1)
          begin
            #1;
            mbox_in.get(imon_pkt);
            imon_pkts++;
            $display("[@%0t] [SCB] Received imon_pkt no : %0d",$time,imon_pkts);
            //imon_pkt.print("SCB");
            -> compare_pkt;
          end
      end
      
      B2 :
      begin
        while(1)
          begin
            #1;
            mbox_out.get(omon_pkt);
            omon_pkts++;
            $display("[@%0t] [SCB] Received omon_pkt no : %0d",$time,omon_pkts);
            //omon_pkt.print("SCB");
            @ compare_pkt;
            comparer();
          end
      end
      
//       B3 :
//       begin
//         @(final_report_event);
//         final_report();
//       end
    
    join 
  endtask : run
  
  task comparer();
    #1;
    // WRITE MATCH CONDITION
    if(imon_pkt.wdata == omon_pkt.wdata == 1 && imon_pkt.wr == omon_pkt.wr == 1 && imon_pkt.addr == omon_pkt.addr && imon_pkt.response == omon_pkt.response == 1 && omon_pkt.rd == 0)
      begin
        $display("[@%0t] [SCB] PASS!!     addr = 0x%0h\tIMON wdata = 0x%0h\tDUV wdata = 0x%0h\tresponse = %0d",$time,omon_pkt.addr,imon_pkt.wdata,omon_pkt.wdata,omon_pkt.response);
        match = match+1;
        wr_pkts++;
        $display("[@%0t] [SCB] **************** WR MATCH ****************",$time);
      end
    
    // READ MATCH CONDITION
    else if(imon_pkt.rd == omon_pkt.rd == 1 && imon_pkt.rdata == omon_pkt.rdata && imon_pkt.addr == omon_pkt.addr && omon_pkt.rdata != 32'h0 && omon_pkt.wr == 0)
      begin
        $display("[@%0t] [SCB] PASS!!     addr = 0x%0h\tIMON rdata = 0x%0h\tDUV rdata = 0x%0h", $time,imon_pkt.addr,imon_pkt.rdata,omon_pkt.rdata);
        match = match+1;
        rd_pkts++;
        $display("[@%0t] [SCB] **************** RD MATCH ****************",$time);
      end
    
    // READ AND WRITE MATCHES
    else if(imon_pkt.rd == omon_pkt.rd == 1 && imon_pkt.wr == omon_pkt.wr == 1 && imon_pkt.rdata == omon_pkt.rdata && imon_pkt.wdata == omon_pkt.wdata && imon_pkt.addr == omon_pkt.addr && imon_pkt.response == omon_pkt.response == 1)
      begin
        wr_rd_pkts++;
        match = match+1;
        $display("[@%0t] [SCB] PASS!!     addr = 0x%0h\tIMON wdata = 0x%0h\tDUV wdata = 0x%0h\tresponse = %0d\tIMON rdata = 0x%0h\t\tDUV rdata = 0x%0h",$time,omon_pkt.addr,imon_pkt.wdata,omon_pkt.wdata,omon_pkt.response,imon_pkt.rdata,omon_pkt.rdata);
        $display("[@%0t] [SCB] **************** WR RD MATCH ****************",$time);
      end
    
    //IDLE MATCH
    else if(imon_pkt.rd == 0 && omon_pkt.rd == 0 && imon_pkt.wr == 0 && omon_pkt.wr == 0)
      begin
        idle_pkts++;
        match = match+1;
        $display("[@%0t] [SCB] No Operation is being perfomed",$time);
      end

    // MISS CONDITION
    else if( (imon_pkt.rdata === 32'dx && omon_pkt.rdata === 32'dx && imon_pkt.rd == 1) || (imon_pkt.rdata === 32'dz && omon_pkt.rdata === 32'dz && imon_pkt.rd == 1) || (imon_pkt.rdata == 32'd0 && omon_pkt.rdata == 32'd0 && imon_pkt.rd == 1))
      begin
        $display("[@%0t] [SCB] ADDRESS hasnt been written!!     addr = 0x%0h\timon rdata = 0x%0h\tDUV rdata = 0x%0h\trd = %0d", $time, omon_pkt.addr, imon_pkt.rdata, omon_pkt.rdata, omon_pkt.rd);
        miss = miss+1;
        missed_rd_pkts++;
        $display("[@%0t] [SCB] **************** MISS ****************",$time);
      end
        
    // MISMATCH CONDITION
    else if(imon_pkt.rdata !== omon_pkt.rdata)
      begin
        $display("[@%0t] [SCB] addr = 0x%0h\timon rdata = 0x%0h\tDUV rdata = 0x%0h",$time,omon_pkt.addr,imon_pkt.rdata,omon_pkt.rdata);
        mismatch = mismatch + 1;   
        $display("[@%0t] [SCB] **************** MISMATCH ****************",$time);
      end

    // SYNC_ISSUE CONDITION
    else if (imon_pkt.wdata != omon_pkt.wdata || imon_pkt.wr != omon_pkt.wr || imon_pkt.rd != omon_pkt.rd || imon_pkt.addr != omon_pkt.addr)
      begin
        sync_issue = sync_issue+1;
        $display("[@%0t] [SCB] **************** SYNC ISSUE ****************",$time);
      end
      
    // UNKNOWN CONDITION
    else
      begin
        unknown++;
        $display("[@%0t] [SCB] **************** FAILING REASON UNKNOWN ****************",$time);
      end    
    
    $display();
    no_pkts++;
  endtask : comparer
  
  task final_report();
    $display("\n[SCB] PRINTING FINAL REPORT");
    $display("[SCB] Total packet count = %0d",no_pkts);
    $display("[SCB] Total writes = %0d",wr_pkts);
    $display("[SCB] Total successful reads = %0d",rd_pkts);
    $display("[SCB] Total missed reads = %0d",missed_rd_pkts);
    $display("[SCB] Total Total Read & Writes = %0d",wr_rd_pkts);
    $display("[SCB] Total Idles = %0d",idle_pkts);
    $display("\n[SCB] Total packet count = %0d",no_pkts);
    $display("[SCB] Total MATCH = %0d",match);
    $display("[SCB] Total MISS = %0d",miss);
    $display("[SCB] Total MISMATCH = %0d",mismatch);
    $display("[SCB] Total SYNC_ISSUE = %0d",sync_issue);
    $display("[SCB] Total UNKNOWN = %0d",unknown);
    $finish();
  endtask : final_report
  
endclass : scoreboard 