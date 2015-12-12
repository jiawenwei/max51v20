
module lcd_ctrl
(
    mcu_rst_i     ,
    mcu_cs_i      ,
    mcu_wr_i      ,
    mcu_rd_i      ,
    mcu_addr_i16  ,
    mcu_rddat_o8  ,
    
    lcd_rst_i     ,
    lcd_bk_i      ,
    lcd_nrst_o    ,
    lcd_bk_o      ,
    
    lcd_rs_o      ,
    lcd_rw_o      ,
    lcd_e_o       
);

    input         mcu_rst_i   ;
    input         mcu_cs_i    ;
    input         mcu_wr_i    ;
    input         mcu_rd_i    ;
    input [15:0]  mcu_addr_i16;
    output[7:0]   mcu_rddat_o8;
    
    input         lcd_rst_i   ;
    input         lcd_bk_i    ;
    output        lcd_rs_o    ;
    output        lcd_rw_o    ;
    output        lcd_e_o     ;
    output        lcd_nrst_o  ;
    output        lcd_bk_o    ;
    
//    assign  LED_CTRL=led_ctrl;
//    assign  V3_LCD_nRST=~lcd_rst;
    
    assign  lcd_e_o = mcu_cs_i&(mcu_wr_i|mcu_rd_i);//     ~(mcu_wr_n&mcu_rd_n);
    
//    assign  V3_LCD_RW =mcu_p2[1];
//    assign  V3_LCD_RS =mcu_p2[0];

    assign  lcd_rw_o    = mcu_addr_i16[1] ;
    assign  lcd_rs_o    = mcu_addr_i16[0] ;
    assign  lcd_nrst_o  = ~lcd_rst_i      ;
    assign  lcd_bk_o    = lcd_bk_i        ;
    assign  mcu_rddat_o8= 8'hzz           ;

////---------- high mcu addr decode ---------------//
//
//  assign  lcd_rs_o           = mcu_addr_i8[0];
//  
//  assign  lcd_wr_no          = ~mcu_wr_i;
//  assign  lcd_rd_no          = ~mcu_rd_i;
//  assign  lcd_cs_no          = ~mcu_cs_i;
//
////assign  lcd_dtio[7:0]       = mcu_wr_i ? mcu_wrdat_i[7:0] : 8'hz;
////assign  mcu_rddat_o[7:0]    = lcd_dtio[7:0];

//----------------------------------------------------------
endmodule

