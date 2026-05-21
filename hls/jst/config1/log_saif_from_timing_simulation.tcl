# log_saif_from_timing_simulation.tcl

set XPR_PATH        [file normalize "binarynet/solution1/impl/verilog/project.xpr"]
set TB_FILE         [file normalize "tb/tb_binarynet.v"]

set OUTDIR          [file normalize "reports"]
file mkdir $OUTDIR
set SAIF_OUT        [file normalize "$OUTDIR/binarynet_timing.saif"]

set TB_TOP_SCOPE    "/tb_binarynet"
set TB_DUT_SCOPE    "/tb_binarynet/bd_0_i"
set IMPL_DUT_SCOPE  "/tb_binarynet/bd_0_i/bd_0_i"

open_project $XPR_PATH
open_run impl_1

set_property source_mgmt_mode None [current_project]

if {[llength [get_files -quiet $TB_FILE]] == 0} {
  add_files -fileset sim_1 -norecurse $TB_FILE
}

set_property top tb_binarynet [get_filesets sim_1]
update_compile_order -fileset sim_1

launch_simulation -mode post-implementation -type timing

restart

puts "Top scopes:"
puts [get_scopes /*]

if {[llength [get_scopes $TB_TOP_SCOPE]] == 0} {
  puts "ERROR: $TB_TOP_SCOPE not found. You're not simulating the TB."
  quit
}

if {[llength [get_scopes $TB_DUT_SCOPE]] == 0} {
  puts "ERROR: TB DUT scope '$TB_DUT_SCOPE' not found."
  puts [get_scopes ${TB_TOP_SCOPE}/*]
  quit
}

if {[llength [get_scopes $IMPL_DUT_SCOPE]] == 0} {
  puts "ERROR: Implementation DUT scope '$IMPL_DUT_SCOPE' not found."
  puts [get_scopes ${TB_DUT_SCOPE}/*]
  quit
}

open_saif $SAIF_OUT
puts "Logging SAIF at scope: $IMPL_DUT_SCOPE"
log_saif [get_objects -recursive ${IMPL_DUT_SCOPE}/*]

run all

close_saif
quit
