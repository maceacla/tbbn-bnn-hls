set XPR_PATH "binarynet/solution1/impl/verilog/project.xpr"
set OUTDIR [file normalize "reports"]
file mkdir $OUTDIR
set SAIF_IN  [file normalize "$OUTDIR/binarynet_timing.saif"]
set SAIF_NORM [file normalize "$OUTDIR/binarynet_timing.normalized.saif"]
set PWR_RPT  [file normalize "$OUTDIR/power_from_saif.rpt"]
set UNMATCH  [file normalize "$OUTDIR/unmatched_nets.rpt"]
set SAIF_STRIP_PATH "tb_binarynet/bd_0_i"

exec python3 [file normalize "normalize_saif.py"] $SAIF_IN $SAIF_NORM

proc print_annotation_summary {report_path} {
  set fh [open $report_path r]
  set report_text [read $fh]
  close $fh

  foreach line [split $report_text "\n"] {
    if {[string match "*Design Nets Matched*" $line]} {
      puts [string trim $line]
      return
    }
  }
}

open_project $XPR_PATH
open_run impl_1

if {[llength [get_clocks ap_clk]] == 0} {
  create_clock -name ap_clk -period 10.000 [get_ports ap_clk]
}

read_saif -strip_path $SAIF_STRIP_PATH -out_file $UNMATCH -verbose $SAIF_NORM

report_power -advisory -file $PWR_RPT
print_annotation_summary $PWR_RPT
quit
