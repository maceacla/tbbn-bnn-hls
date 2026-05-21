open_project -reset binarynet

set_top BinaryNet

add_files src/BinaryNet.cpp
add_files src/r_10_32_4.cpp
add_files src/r_10n1.cpp
add_files src/r_128_196_4.cpp
add_files src/r_128_32_4_a.cpp
add_files src/r_128_32_4_b.cpp
add_files src/r_10.cpp
add_files src/r_10_10.cpp

add_files src/BinaryNet.h
add_files src/r_10_32_4.h
add_files src/r_10_32_4_params.h
add_files src/r_10n1.h
add_files src/r_128_196_4.h
add_files src/r_128_196_4_params.h
add_files src/r_128_32_4_a.h
add_files src/r_128_32_4_a_params.h
add_files src/r_128_32_4_b.h
add_files src/r_128_32_4_b_params.h
add_files src/r_10.h
add_files src/r_10_10.h
add_files src/r_10_10_params.h

open_solution -reset solution1
set_part xcu250-figd2104-2L-e

create_clock -period 10.0 -name default

csynth_design

export_design -flow impl -rtl verilog -format ip_catalog

exit
