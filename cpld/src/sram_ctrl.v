module sram_ctrl
(
    mcu_rst_i     ,
    mcu_cs_i      ,
    mcu_wr_i      ,
    mcu_rd_i      ,
    mcu_psen_i    ,
    mcu_addr_i16  ,
    mcu_wrdat_i8  ,
    mcu_rddat_o8  ,
    
    sram_data_io8 ,
    sram_addr_o17 ,
    sram_oe_no    ,
    sram_we_no
);

//-- mcu interface -----------//
input         mcu_rst_i     ;
input         mcu_cs_i      ;

input         mcu_wr_i      ;
input         mcu_rd_i      ;
input         mcu_psen_i    ;
input [15:0]  mcu_addr_i16  ;
input [ 7:0]  mcu_wrdat_i8  ;
output[ 7:0]  mcu_rddat_o8  ;

inout [ 7:0]  sram_data_io8 ;
output[16:0]  sram_addr_o17 ;
output        sram_oe_no    ;
output        sram_we_no    ;

//----------------------------------------------------------
assign sram_data_io8        = mcu_cs_i&mcu_wr_i ? mcu_wrdat_i8 : 8'hzz;
assign mcu_rddat_o8         = sram_data_io8;

assign sram_we_no           = mcu_cs_i&(~mcu_wr_i)   ;
assign sram_oe_no           = mcu_cs_i&(~mcu_rd_i)&(~mcu_psen_i)   ;

assign sram_addr_o17[15:0]  = mcu_cs_i?mcu_addr_i16 : 16'hzzzz ;
assign sram_addr_o17[16]    = mcu_cs_i&mcu_psen_i? 1'b1: 1'b0;
/*
ram:00000~0ffff   µÍ65536ÎªRAM
rom:10000~1ffff   ¸ß65536ÎªROM
*/
//----------------------------------------------------------
endmodule
