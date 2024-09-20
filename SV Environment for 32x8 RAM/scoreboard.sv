//**************************SCOREBOARD**********************//
////filename scoreboard.sv
class scoreboard;
  int total_pkts_rcvd;
  packet imon_pkt;
  packet omon_pkt;
  mailbox #(packet) mbox_in;
  mailbox #(packet) mbox_out;
  bit [15:0] match;
  bit [15:0]mismatch;
  bit [15:0] missed;
  bit [15:0] black_hole;
  int wr_no_of_pkts;
  int rd_no_of_pkts;
  int i;
  event compare_pkt;
  
  function new(input mailbox #(packet) mbox_in, input mailbox #(packet) mbox_out);
    this.mbox_in = mbox_in;
    this.mbox_out = mbox_out;
  endfunction
  
  task run();
    $display("@%0t [SCB] Run started\n",$time);
    imon_pkt = new();
    omon_pkt = new();
    fork
      begin
        while(1)
          begin
            wr_no_of_pkts++;
            mbox_in.get(imon_pkt);
            $display("@%0t [SCBIN] addr = %0d monin_data_out = %0d",$time,imon_pkt.addr,imon_pkt.data_out_monin);
            -> compare_pkt;
          end
      end
      
      begin
        while(1)
          begin
            mbox_out.get(omon_pkt);
            rd_no_of_pkts++;
            $display("@%0t [SCBOUT] addr = %0d monout_data_out =%0d",$time,omon_pkt.addr,omon_pkt.data_out);
            
            @(compare_pkt);
            if(imon_pkt.data_out_monin === omon_pkt.data_out)
              begin
                $display("@%0t [SCB] PASS addr = %0d tb data = %0d DUV data = %0d",$time,imon_pkt.addr,imon_pkt.data_out_monin,omon_pkt.data_out);
                match = match+1;
              end
            
            else if(imon_pkt.data_out_monin === 8'dx && omon_pkt.data_out === 8'dx && omon_pkt.addr !== 5'dx && imon_pkt.rd_en == 1)
              begin
                $display("@%0t [SCB] address hasnt been written addr = %0d tbdata = %0d DUV data = %0d rd_en = %0d",$time,omon_pkt.addr,imon_pkt.data_out_monin,omon_pkt.data_out,imon_pkt.rd_en);
                match = match+1;
              end
            
            else if(imon_pkt.data_out_monin !== omon_pkt.data_out)
              begin
                $display("@%0t [SCB] addr = %0d tbdata = %0d DUV data = %0d",$time,omon_pkt.addr,imon_pkt.data_out_monin,omon_pkt.data_out);
                mismatch = mismatch + 1;
              end
            
            else
              black_hole = black_hole+1;
            $display("[CHECK] match = %0d mismatch = %0d blackhole = %0d",match,mismatch,black_hole);
            total_pkts_rcvd = total_pkts_rcvd + 1;
            $display("[CHECK] pkt count = %0d",total_pkts_rcvd);
          end
      end
    join
  endtask
endclass
