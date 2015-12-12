
vlib work
vmap work work

#compile
vlog +acc -work work ../src/max51.v
vlog +acc -work work ./tb.v

#simulation
vsim -t 100ps -novopt work.tb

view object
view wave

do wave.do

run 2us


