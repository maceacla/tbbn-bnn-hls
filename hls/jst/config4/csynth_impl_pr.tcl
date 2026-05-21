open_project -reset binarynet

set_top BinaryNet

add_files src/BinaryNet.cpp
add_files src/r_64_16.cpp
add_files src/r_5_16_4.cpp
add_files src/r_5n1.cpp

add_files src/BinaryNet.h
add_files src/r_64_16.h
add_files src/r_64_16_params.h
add_files src/r_5_16_4.h
add_files src/r_5_16_4_params.h
add_files src/r_5n1.h

open_solution -reset solution1
set_part xcu250-figd2104-2L-e

create_clock -period 10.0 -name default

csynth_design

export_design -flow impl -rtl verilog -format ip_catalog

exit
