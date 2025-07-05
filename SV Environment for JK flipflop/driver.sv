class driver;
packet pkt;

mailbox #(packet) mbox1;

virtual jkif.DRV vif_drv;

int no_of_pkts;

function new (input mailbox #(packet) mbox_in, input virtual jkif.DRV drv);
	mbox1 = mbox_in;
	vif_drv = drv;
	if(vif_drv == null)
		$display("FATAL handle not set");
endfunction

virtual task run();
	$display("@%0t [DRV:run] Driver run started",$time);
	//wait(!top.rst)										////TRY UNCOMMENTING IF ISSUE
	while(1)
	begin
		mbox1.get(pkt);
		no_of_pkts++;
		drive_to_design();
	end
endtask
	
task drive_to_design();
	@(vif_drv.drv_cb);
	vif_drv.drv_cb.jk <= pkt.jk;
	$display("********************************@%0t [TEST] Interface signals jk = %b",$time,vif_drv.drv_cb.jk);
endtask

endclass
