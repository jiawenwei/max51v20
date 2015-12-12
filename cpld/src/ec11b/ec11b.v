
`timescale 1ns/10ps
module ec11b
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
    a_pin_i      ,
    b_pin_i      ,
    d_pin_i      ,
    
    debug_o8      ,

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
  input         a_pin_i      ;
  input         b_pin_i      ;
  input         d_pin_i      ;
  
  output[7:0]   debug_o8     ;
  
  assign  debug_o8 = debug_w8;
//---------------------------------------------------
wire [7:0] lva_w8;
wire [7:0] rva_w8;
wire [7:0] clr_w;

//assign  mcu_int_o = 1'b0;

ec11b_reg inst_ec11b_reg
(
    .mcu_rst_i    (mcu_rst_i    ),
    .mcu_cs_i     (mcu_cs_i     ),
    .mcu_wr_i     (mcu_wr_i     ),
    .mcu_rd_i     (mcu_rd_i     ),
    .mcu_addr_i8  (mcu_addr_i8  ),
    .mcu_wrdat_i8 (mcu_wrdat_i8 ),
    .mcu_rddat_o8 (mcu_rddat_o8 ),
    .mcu_int_o    (mcu_int_o    ),

    .ec11b_clr_o  (clr_w        ),
    .ec11b_lva_i8 (lva_w8       ),
    .ec11b_rva_i8 (rva_w8       ),
);

//---------------------------------------------------
wire  [7:0]   debug_w8     ;

ec11b_ctrl inst_ec11b_ctrl
(
    .clk_i        (clk_i      ),//50MHZ 
    .rst_i        (mcu_rst_i  ),
    .a_i          (a_pin_i    ),
    .b_i          (b_pin_i    ),
    .d_i          (d_pin_i    ),
    
    .clr_i        (clr_w      ),
    .lva_o8       (lva_w8     ),
    .rva_o8       (rva_w8     ),
    .debug_o8     (debug_w8   ),
    
);

//---------------------------------------------------
endmodule
