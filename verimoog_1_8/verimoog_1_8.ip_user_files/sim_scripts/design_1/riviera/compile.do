transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xil_defaultlib
vlib riviera/lib_cdc_v1_0_2
vlib riviera/proc_sys_reset_v5_0_14

vmap xil_defaultlib riviera/xil_defaultlib
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_14 riviera/proc_sys_reset_v5_0_14

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../verimoog_1_8.gen/sources_1/bd/design_1/ipshared/c2c6" -l xil_defaultlib -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../bd/design_1/ip/design_1_top_0_0/sim/design_1_top_0_0.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0/design_1_clk_wiz_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0/design_1_clk_wiz_0.v" \

vcom -work lib_cdc_v1_0_2 -93  -incr \
"../../../../verimoog_1_8.gen/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_14 -93  -incr \
"../../../../verimoog_1_8.gen/sources_1/bd/design_1/ipshared/408c/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/design_1/ip/design_1_rst_clk_wiz_100M_0/sim/design_1_rst_clk_wiz_100M_0.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../verimoog_1_8.gen/sources_1/bd/design_1/ipshared/c2c6" -l xil_defaultlib -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

