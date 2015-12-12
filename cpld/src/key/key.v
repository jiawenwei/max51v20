
`timescale 1ns/10ps
module key
(
    mcu_rst_i    ,
    mcu_cs_i     ,
    mcu_wr_i     ,
    mcu_rd_i     ,
    mcu_addr_i8  ,
    mcu_wrdat_i8 ,
    mcu_rddat_o8 ,
    mcu_int_o    ,

    clk_i        ,   //50MHZ
    key_col_i4   ,   //?
    key_row_o2   ,   //?

);

  input         mcu_rst_i    ;
  input         mcu_cs_i     ;
  input         mcu_wr_i     ;
  input         mcu_rd_i     ;
  input [7:0]   mcu_addr_i8  ;
  input [7:0]   mcu_wrdat_i8 ;
  output[7:0]   mcu_rddat_o8 ;
  output        mcu_int_o    ;
  
  input         clk_i        ;
  input  [3:0]  key_col_i4   ;
  output [1:0]  key_row_o2   ;
  
//---------------------------------------------------
wire [7:0] int_w8;
wire [7:0] key_w8;
wire       clr_w;
wire       sta_w;

//assign  mcu_int_o = 1'b0;

key_reg inst_key_reg
(
    .mcu_rst_i    (mcu_rst_i    ),
    .mcu_cs_i     (mcu_cs_i     ),
    .mcu_wr_i     (mcu_wr_i     ),
    .mcu_rd_i     (mcu_rd_i     ),
    .mcu_addr_i8  (mcu_addr_i8  ),
    .mcu_wrdat_i8 (mcu_wrdat_i8 ),
    .mcu_rddat_o8 (mcu_rddat_o8 ),
    .mcu_int_o    (mcu_int_o    ),

    .key_clr_o    (clr_w        ),
    .key_int_i    (int_w8       ),
    .key_sta_i    (sta_w        ),
    .key_value_i8 (key_w8       ),

);

key_ctrl inst_key_ctrl
(
    .clk_i        (clk_i        ),   //50MHZ 
    .rst_i        (mcu_rst_i    ),   
    .col_i4       (key_col_i4   ),   //?
    .row_o2       (key_row_o2   ),   //?
    
    .key_o        (key_w8       ),   //??
    .clr_i        (clr_w        ),   //??
    .int_o        (int_w8       ),   //??
    .sta_o        (sta_w        ),   //??

);

//---------------------------------------------------
endmodule
