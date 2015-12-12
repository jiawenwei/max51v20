## Generated SDC file "max51.sdc"

## Copyright (C) 1991-2008 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 8.0 Build 215 05/29/2008 SJ Full Version"

## DATE    "Sun Mar 29 13:20:46 2015"

##
## DEVICE  "EPM1270T144C5"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_sys} -period 25.000 -waveform { 0.000 12.500 } [get_ports {CLK_50M_i}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {spi_clk} -source [get_ports {CLK_50M_i}] -master_clock {clk_sys} [get_nets {inst_sd|inst_sd_ctrl|clk_cnt[0] inst_sd|inst_sd_ctrl|clk_cnt[1] inst_sd|inst_sd_ctrl|clk_cnt[1]~38 inst_sd|inst_sd_ctrl|clk_cnt[1]~38COUT1_69 inst_sd|inst_sd_ctrl|clk_cnt[2] inst_sd|inst_sd_ctrl|clk_cnt[2]~40 inst_sd|inst_sd_ctrl|clk_cnt[2]~40COUT1_71 inst_sd|inst_sd_ctrl|clk_cnt[3] inst_sd|inst_sd_ctrl|clk_cnt[3]~42 inst_sd|inst_sd_ctrl|clk_cnt[3]~42COUT1_73 inst_sd|inst_sd_ctrl|clk_cnt[4] inst_sd|inst_sd_ctrl|clk_cnt[4]~44 inst_sd|inst_sd_ctrl|clk_cnt[5] inst_sd|inst_sd_ctrl|clk_cnt[5]~46 inst_sd|inst_sd_ctrl|clk_cnt[5]~46COUT1_75 inst_sd|inst_sd_ctrl|clk_cnt[6] inst_sd|inst_sd_ctrl|clk_cnt[6]~48 inst_sd|inst_sd_ctrl|clk_cnt[6]~48COUT1_77 inst_sd|inst_sd_ctrl|clk_cnt[7]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************

