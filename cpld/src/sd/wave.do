onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/rst_i
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/sttshift_i
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/ssppres_i8
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/ssptdat_i8
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/sspsreg_o8
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/sspstat_o8
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_sck_o
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_sdo_o
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_sdi_i
add wave -noupdate -format Literal /sd_tb/inst_sd/inst_sd_ctrl/current_state_dgo
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/sttshift_i_dy1
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/sttshift_i_dy2
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/sttshift_i_dy3
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/clk_i
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/rst_n
add wave -noupdate -format Literal -radix unsigned /sd_tb/inst_sd/inst_sd_ctrl/clk_cnt
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_clk
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/current_state
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/next_state
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/nstate
add wave -noupdate -format Literal -radix hexadecimal /sd_tb/inst_sd/inst_sd_ctrl/dycnt
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/delay_ok
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/shift_negedge
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/shift_trigger
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/shift_ok_posedge
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/shift_ok
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_sck
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_sdo
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/st_idle
add wave -noupdate -format Logic /sd_tb/inst_sd/inst_sd_ctrl/spi_sdi
add wave -noupdate -format Literal -radix decimal /sd_tb/inst_sd/inst_sd_ctrl/sbcnt
add wave -noupdate -format Literal -radix binary /sd_tb/inst_sd/inst_sd_ctrl/sspsreg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {537691 ns} 0} {{Cursor 2} {1566569 ns} 0}
configure wave -namecolwidth 287
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {480655 ns} {611905 ns}
