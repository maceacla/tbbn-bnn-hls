# log_saif_from_timing_simulation.tcl
# Run:
#   vivado -mode batch -source log_saif_from_timing_simulation.tcl

set XPR_PATH        [file normalize "binarynet/solution1/impl/verilog/project.xpr"]
set TB_FILE         [file normalize "tb/tb_binarynet.v"]

set OUTDIR          [file normalize "reports"]
file mkdir $OUTDIR
set SAIF_OUT        [file normalize "$OUTDIR/binarynet_timing.saif"]

# Post-implementation timing sim uses two bd_0_i levels:
#   /tb_binarynet/bd_0_i          -> TB instance of bd_0_wrapper
#   /tb_binarynet/bd_0_i/bd_0_i   -> block-design instance inside bd_0_wrapper
# Log the inner implementation hierarchy so SAIF import can strip only the TB layer.
set TB_TOP_SCOPE    "/tb_binarynet"
set TB_DUT_SCOPE    "/tb_binarynet/bd_0_i"
set IMPL_DUT_SCOPE  "/tb_binarynet/bd_0_i/bd_0_i"

open_project $XPR_PATH
open_run impl_1

# ---- Force manual source mgmt so "top" is respected ----
set_property source_mgmt_mode None [current_project]

# ---- Add TB into sim_1 (only if not already present) ----
if {[llength [get_files -quiet $TB_FILE]] == 0} {
  add_files -fileset sim_1 -norecurse $TB_FILE
}

# ---- Set TB as simulation top ----
set_property top tb_binarynet [get_filesets sim_1]
update_compile_order -fileset sim_1

# ---- Launch post-impl timing sim (Vivado generates timesim.v + .sdf under project.sim/...) ----
launch_simulation -mode post-implementation -type timing

# ---- Inside xsim kernel now ----
restart

# Quick sanity: make sure your TB scope exists
puts "Top scopes:"
puts [get_scopes /*]

if {[llength [get_scopes $TB_TOP_SCOPE]] == 0} {
  puts "ERROR: $TB_TOP_SCOPE not found. You're not simulating the TB."
  puts "TIP: check that $TB_FILE was added to sim_1 and top=tb_binarynet."
  quit
}

if {[llength [get_scopes $TB_DUT_SCOPE]] == 0} {
  puts "ERROR: TB DUT scope '$TB_DUT_SCOPE' not found."
  puts "Scopes under $TB_TOP_SCOPE:"
  puts [get_scopes ${TB_TOP_SCOPE}/*]
  quit
}

if {[llength [get_scopes $IMPL_DUT_SCOPE]] == 0} {
  puts "ERROR: Implementation DUT scope '$IMPL_DUT_SCOPE' not found."
  puts "Scopes under $TB_DUT_SCOPE:"
  puts [get_scopes ${TB_DUT_SCOPE}/*]
  quit
}

open_saif $SAIF_OUT
puts "Logging SAIF at scope: $IMPL_DUT_SCOPE"
log_saif [get_objects -recursive ${IMPL_DUT_SCOPE}/*]

# Run until the testbench terminates via $finish.
run all

close_saif
quit
