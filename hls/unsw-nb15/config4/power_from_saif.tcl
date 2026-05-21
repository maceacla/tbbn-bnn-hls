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

# Summarize both unmatched simulation nets and unmatched design nets from
# Vivado's read_saif report, and break out NLW_* implementation-only nets.
# The design-net section is the one that corresponds to Vivado's official
# Design Nets Matched denominator; the simulation-net section is only diagnostic.
proc print_unmatched_summary {unmatch_path} {
  set fh [open $unmatch_path r]
  set unmatch_text [read $fh]
  close $fh

  set section ""
  set sim_raw 0
  set sim_nlw 0
  set design_raw 0
  set design_nlw 0

  foreach line [split $unmatch_text "
"] {
    set trimmed [string trim $line]
    if {$trimmed eq "--- Unmatched simulation nets ---"} {
      set section "sim"
      continue
    }
    if {$trimmed eq "--- Unmatched design nets ---"} {
      set section "design"
      continue
    }
    if {$trimmed eq "" || [string match "---*" $trimmed]} {
      continue
    }

    if {$section eq "sim"} {
      incr sim_raw
      if {[string match "*NLW_*" $trimmed]} {
        incr sim_nlw
      }
    } elseif {$section eq "design"} {
      incr design_raw
      if {[string match "*NLW_*" $trimmed]} {
        incr design_nlw
      }
    }
  }

  puts "Unmatched simulation nets (raw): $sim_raw"
  puts "Unmatched simulation nets (excluding NLW_*): [expr {$sim_raw - $sim_nlw}]"
  puts "Unmatched simulation nets tagged NLW_*: $sim_nlw"
  puts "Unmatched design nets (official raw): $design_raw"
  puts "Unmatched design nets (excluding NLW_*): [expr {$design_raw - $design_nlw}]"
  puts "Unmatched design nets tagged NLW_*: $design_nlw"
}

open_project $XPR_PATH
open_run impl_1

if {[llength [get_clocks ap_clk]] == 0} {
  create_clock -name ap_clk -period 10.000 [get_ports ap_clk]
}

read_saif -strip_path $SAIF_STRIP_PATH -out_file $UNMATCH -verbose $SAIF_NORM

report_power -advisory -file $PWR_RPT
print_annotation_summary $PWR_RPT
print_unmatched_summary $UNMATCH
quit
