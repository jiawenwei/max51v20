
`timescale 1ns/10ps
module key_reg
(
    mcu_rst_i    ,
    mcu_cs_i     ,
    mcu_wr_i     ,
    mcu_rd_i     ,
    mcu_addr_i8  ,
    mcu_wrdat_i8 ,
    mcu_rddat_o8 ,
    mcu_int_o    ,
    
    key_clr_o    ,
    key_int_i    ,
    key_sta_i    ,
    key_value_i8 ,
    
);

input       mcu_rst_i    ;
input       mcu_cs_i     ;
input       mcu_wr_i     ;
input       mcu_rd_i     ;
input [7:0] mcu_addr_i8  ;
input [7:0] mcu_wrdat_i8 ;
output[7:0] mcu_rddat_o8 ;
output      mcu_int_o    ;

output      key_clr_o    ;
input       key_int_i    ;
input       key_sta_i    ;
input [7:0] key_value_i8 ;


reg         key_intmsk_r ;
reg   [7:0] test_r8      ; 


//----------------------------------------------------------
assign mcu_int_o = key_int_i&key_intmsk_r;

//----------------------------------------------------------
reg   [7:0] mcu_rddat_o8 ;

always@ ( * )
begin
  if(mcu_rst_i)
    mcu_rddat_o8   =  8'h00;
  else if (mcu_cs_i & mcu_rd_i)
  begin
    case (mcu_addr_i8[7:0])
      8'h00:  mcu_rddat_o8[7:0] =  key_value_i8 ;
      8'h01:  mcu_rddat_o8[7:0] =  {7'b0,key_intmsk_r};
      8'h02:  mcu_rddat_o8[7:0] =  test_r8      ;
      8'h03:  mcu_rddat_o8[7:0] =  {7'b0,key_clr_o};
      8'h04:  mcu_rddat_o8[7:0] =  {7'b0,key_sta_i};
      
    default:  mcu_rddat_o8[7:0] =  8'h0         ;
    endcase
  end
end

//----------------------------------------------------------
reg key_clr_o;

always@( * )
begin
  if(mcu_rst_i)
  begin
      test_r8      = 8'h00;
      key_intmsk_r = 1'b1;
      key_clr_o    = 1'b0;
  end
  else if (mcu_cs_i & mcu_wr_i)
  begin
    case (mcu_addr_i8[7:0])
//    8'h00:  key_value_o8      =  mcu_wrdat_i8[7:0];
      8'h01:  key_intmsk_r      =  mcu_wrdat_i8[0]  ;//ÆÁ±ÎÖĞ¶Ï¼Ä´æÆ÷
      8'h02:  test_r8           =  mcu_wrdat_i8[7:0];//²âÊÔ¶ÁĞ´¼Ä´æÆ÷
      8'h03:  key_clr_o         =  mcu_wrdat_i8[0]  ;
      
    default:
      begin
          test_r8      = 8'h00;
          key_intmsk_r = 1'b1;
          key_clr_o    = 1'b0;
      end
    endcase
  end
end

//---------------------------------------------------
endmodule 
