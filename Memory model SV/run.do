vsim +access+r;
run -all;
acdb save;
acdb report -db  fcover.acdb -txt -o cov.txt -verbose  
exec cat cov.txt;

# Set the working directory
#set work_dir "./path/to/your/design"

# Change to the working directory
#cd $work_dir

# Enable coverage analysis
#SetCoverageAnalyzeEnable true
#SetCoverageSimulateEnable true

# Analyze HDL files
#analyze ./hdl/TMR/hdl/hdl_TMR/TMR.vhd

# DUT (Device Under Test)
#analyze ./hdl/Dynamic_Mux_Controller.vhd

# Analyze testbench files
#analyze ./tb/packages/Dynamic_Mux_Controller_component_pkg.vhd
#analyze ./tb/test_control/test_control_entity.vhd
#analyze ./tb/Dynamic_Mux_Controller_tb.vhd

# Run the test case
#RunTest ./tb/test_control/test_case_1.vhd

# Disable coverage simulation if needed after running tests
#SetCoverageSimulateEnable false

# Generate coverage report (HTML format)
#SetCoverageReportType html
#SetCoverageReportOutput "coverage_report.html"
#GenerateCoverageReport

# Optionally, you can also generate a text report
#SetCoverageReportType text
#SetCoverageReportOutput "coverage_report.txt"
#GenerateCoverageReport

#exit
# End of script