# -----------------------------------------
# 1) Create project from scratch
# -----------------------------------------
open_project -reset binarynet

# -----------------------------------------
# 2) Set top function
# -----------------------------------------
set_top binarynet

# -----------------------------------------
# 3) Add all source files
# -----------------------------------------
add_files src/binarynet.cpp
add_files src/r_10_32_4.cpp
add_files src/r_10n1.cpp
add_files src/r_128_196_4.cpp
add_files src/r_128_32_4_a.cpp
add_files src/r_128_32_4_b.cpp

add_files src/binarynet.h
add_files src/r_10_32_4.h
add_files src/r_10_32_4_params.h
add_files src/r_10n1.h
add_files src/r_128_196_4.h
add_files src/r_128_196_4_params.h
add_files src/r_128_32_4_a.h
add_files src/r_128_32_4_a_params.h
add_files src/r_128_32_4_b.h
add_files src/r_128_32_4_b_params.h
add_files src/r_128_32_4_params.h

# -----------------------------------------
# 4) Create solution
# -----------------------------------------
open_solution -reset solution1
set_part xcu250-figd2104-2L-e
create_clock -period 10.0 -name default

# -----------------------------------------
# 5) Run HLS synthesis
# -----------------------------------------
csynth_design

# -----------------------------------------
# 6) Run RTL synth + P&R in Vivado
# -----------------------------------------
export_design -flow impl -rtl verilog -format ip_catalog

exit
