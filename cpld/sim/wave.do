onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/reset
add wave -noupdate -format Logic /tb/reset_dy1
add wave -noupdate -format Logic /tb/clk_50
add wave -noupdate -format Logic /tb/clk_18
add wave -noupdate -format Logic /tb/ale
add wave -noupdate -format Logic /tb/psen_n
add wave -noupdate -format Logic /tb/wr_n
add wave -noupdate -format Logic /tb/rd_n
add wave -noupdate -format Literal -radix hexadecimal /tb/port0
add wave -noupdate -format Literal -radix hexadecimal /tb/port2
add wave -noupdate -format Literal /tb/leds
add wave -noupdate -format Literal -radix decimal /tb/i
add wave -noupdate -format Literal -radix hexadecimal /tb/wport0
add wave -noupdate -format Literal -radix hexadecimal /tb/wport2
add wave -noupdate -format Logic /tb/mcu_if_u1/rst
add wave -noupdate -format Logic /tb/mcu_if_u1/clk
add wave -noupdate -format Logic /tb/mcu_if_u1/mcu_wr_n
add wave -noupdate -format Logic /tb/mcu_if_u1/mcu_rd_n
add wave -noupdate -format Logic /tb/mcu_if_u1/mcu_ale
add wave -noupdate -format Logic /tb/mcu_if_u1/mcu_psen_n
add wave -noupdate -format Literal -radix hexadecimal /tb/mcu_if_u1/mcu_p2
add wave -noupdate -format Literal -radix hexadecimal /tb/mcu_if_u1/mcu_p0
add wave -noupdate -format Literal /tb/mcu_if_u1/leds_o
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_n_dy1
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_n_dy2
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_h2l
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_n_dy1
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_n_dy2
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_h2l
add wave -noupdate -format Logic /tb/mcu_if_u1/ale_dy1
add wave -noupdate -format Logic /tb/mcu_if_u1/ale_dy2
add wave -noupdate -format Logic /tb/mcu_if_u1/ale_h2l
add wave -noupdate -format Logic /tb/mcu_if_u1/psen_n_dy1
add wave -noupdate -format Logic /tb/mcu_if_u1/psen_n_dy2
add wave -noupdate -format Logic /tb/mcu_if_u1/psen_n_h2l
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_h2l_dy1
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_h2l_dy2
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_h2l_dy3
add wave -noupdate -format Logic /tb/mcu_if_u1/wr_h2l_dy4
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_h2l_dy1
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_h2l_dy2
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_h2l_dy3
add wave -noupdate -format Logic /tb/mcu_if_u1/rd_h2l_dy4
add wave -noupdate -format Literal -radix hexadecimal /tb/mcu_if_u1/addr_r
add wave -noupdate -format Literal -radix hexadecimal /tb/mcu_if_u1/rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {976200 ps} 0}
configure wave -namecolwidth 210
configure wave -valuecolwidth 73
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2100 ns}
