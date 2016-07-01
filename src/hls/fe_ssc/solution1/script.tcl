############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2016 Xilinx, Inc. All Rights Reserved.
############################################################
open_project fe_ssc
set_top fe_ssc
add_files fe_ssc/fe_ssc.cpp
open_solution "solution1"
set_part {xc7z020clg484-1} -tool vivado
create_clock -period 10 -name default
#source "./fe_ssc/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
