// Code your design here

program pgm (jkif jk_if);

jktest test;										////Uncomment after writing test code

initial
begin
	$display("@%0t [Prg] Simulations Started",$time);
	
	test = new(jk_if.DRV,jk_if.IMON,jk_if.OMON);					////Uncomment after writing test code
	test.run();

	$display("@%0t [Prg] Simulation finished",$time);
$finish;
end

endprogram
