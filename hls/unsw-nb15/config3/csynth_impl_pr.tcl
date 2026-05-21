open_project -reset binarynet

set_top binarynet

add_files src/binarynet.cpp
add_files src/r_64_593.cpp
add_files src/r_16_4.cpp

add_files src/binarynet.h
add_files src/r_64_593.h
add_files src/r_64_593_params.h
add_files src/r_16_4.h
add_files src/r_16_4_params.h

open_solution -reset solution1
set_part xcu250-figd2104-2L-e

create_clock -period 10.0 -name default

csynth_design

export_design -flow impl -rtl verilog -format ip_catalog

exit
