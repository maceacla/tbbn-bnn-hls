# Generate post-implementation timing XSIM scripts for config2.
# Run from config2/ with:
#   vivado -mode batch -source gen_post_impl_timing_xsim.tcl

set XPR_PATH [file normalize "binarynet/solution1/impl/verilog/project.xpr"]
set TB_FILE  [file normalize "tb/tb_binarynet.v"]

if {![file exists $XPR_PATH]} {
  puts "ERROR: Missing project file: $XPR_PATH"
  puts "Run: vitis-run --mode hls --tcl csynth_impl_pr.tcl"
  exit 1
}
if {![file exists $TB_FILE]} {
  puts "ERROR: Missing testbench file: $TB_FILE"
  exit 1
}

open_project $XPR_PATH
set_property source_mgmt_mode None [current_project]

if {[llength [get_files -quiet $TB_FILE]] == 0} {
  add_files -fileset sim_1 -norecurse $TB_FILE
}

set_property top tb_binarynet [get_filesets sim_1]
update_compile_order -fileset sim_1

# Generate the XSIM scripts/artifacts for post-implementation timing sim.
launch_simulation -scripts_only -mode post-implementation -type timing
close_project
exit
