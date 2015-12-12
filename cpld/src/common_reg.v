
module common_reg
(
    mcu_rst_i     ,
    mcu_cs_i      ,
    mcu_rd_i      ,
    mcu_wr_i      ,
    mcu_addr_i8   ,
    mcu_wrdat_i8  ,
    mcu_rddat_o8  ,

    sound_o       ,
    led_o8        ,
    lcd_rst_o     ,
    lcd_bk_o      
);


//-- mcu interface -----------//
input         mcu_rst_i     ;
input         mcu_cs_i      ;
input         mcu_rd_i      ;
input         mcu_wr_i      ;
input [ 7:0]  mcu_addr_i8   ;
input [ 7:0]  mcu_wrdat_i8  ;

output[7:0]   mcu_rddat_o8  ;

//-- perphi control ----------//
output        sound_o       ;
output[7:0]   led_o8        ;
output        lcd_rst_o     ;
output        lcd_bk_o      ;

reg[7:0]      mcu_rddat_o8  ;
reg           sound_o       ;
reg[7:0]      led_o8        ;
reg           lcd_rst_o     ;
reg           lcd_bk_o      ;
reg[7:0]      test_r        ;

//----------------------------------------------------------
always@(*)
begin
  if(mcu_rst_i)
    mcu_rddat_o8   =  8'h00;
  else if (mcu_cs_i & mcu_rd_i) 
  begin
    case (mcu_addr_i8[7:0])
      8'h00:  mcu_rddat_o8[7:0] =  8'h55            ;
      8'h01:  mcu_rddat_o8[7:0] =  {7'b0,sound_o}   ;
      8'h02:  mcu_rddat_o8[7:0] =  led_o8           ;
      8'h03:  mcu_rddat_o8[7:0] =  {7'b0,lcd_rst_o} ;
      8'h04:  mcu_rddat_o8[7:0] =  {7'b0,lcd_bk_o}  ;
      8'h05:  mcu_rddat_o8[7:0] =  test_r           ;
    default:  mcu_rddat_o8[7:0] =  8'h0             ;
    endcase
  end
end

//----------------------------------------------------------
always@(*)
begin
  if(mcu_rst_i)
  begin
    sound_o   =1'b0;
    led_o8    =8'h55;
    lcd_rst_o =1'b0;
    lcd_bk_o  =1'b0;
    test_r    =8'h00;
  end
  else if (mcu_cs_i & mcu_wr_i)
  begin
    case (mcu_addr_i8[7:0])
    //8'h00:  version   =  mcu_wrdat_i8[7:0] ;
      8'h01:  sound_o   =  mcu_wrdat_i8[0]   ;
      8'h02:  led_o8    =  mcu_wrdat_i8[7:0] ;
      8'h03:  lcd_rst_o =  mcu_wrdat_i8[0]   ;
      8'h04:  lcd_bk_o  =  mcu_wrdat_i8[0]   ;
      8'h05:  test_r    =  mcu_wrdat_i8[7:0] ;
    default:
      begin
        sound_o   =sound_o  ;
        led_o8    =led_o8   ;
        lcd_rst_o =lcd_rst_o;
        lcd_bk_o  =lcd_bk_o ;
        test_r    =test_r   ;
      end
    endcase
  end
end

//----------------------------------------------------------
endmodule
