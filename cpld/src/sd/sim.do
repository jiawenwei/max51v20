vlib work
vmap work work

#compile
vlog +acc -work work ./sd.v
vlog +acc -work work ./sd_reg.v
vlog +acc -work work ./sd_ctrl.v

vlog +acc -work work ./sd_tb.v

# simulation
vsim -t 1ns sd_tb

view object
view wave
do wave.do

#run 60us
run 2ms
