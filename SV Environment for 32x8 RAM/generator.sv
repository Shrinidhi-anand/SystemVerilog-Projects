//************************GENERATOR**********************//
////filename generator.sv
class generator;
  int no_of_pkts;
  packet ref_pkt,pkt;
  
  mailbox #(packet) mbox;
  
  function new (mailbox #(packet) mbox_in, int gen_pkts_no = 1);
    no_of_pkts = gen_pkts_no;
    mbox = mbox_in;
    ref_pkt = new();
  endfunction
  
  task run();
    int pkt_count;
    $display("@%0t [GENERATOR] Run started \n",$time);
    repeat(no_of_pkts)
      begin
        assert(ref_pkt.randomize());
        pkt = new();
        pkt.copy(ref_pkt);
        mbox.put(pkt);
        pkt_count = pkt_count + 1;
        pkt.print("GENERATOR");
        $display("@%0t [GENERATOR] Sent packet %0d to driver \n",$time,pkt_count);
        
      end
    $display("@%0t [GENERATOR] run ended size of mbox = %d \n",$time,mbox.num());
  endtask
endclass
