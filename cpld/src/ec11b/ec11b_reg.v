
`timescale 1ns/10ps
module ec11b_reg
(
    mcu_rst_i    ,
    mcu_cs_i     ,
    mcu_wr_i     ,
    mcu_rd_i     ,
    mcu_addr_i8  ,
    mcu_wrdat_i8 ,
    mcu_rddat_o8 ,
    mcu_int_o    ,
    
    ec11b_clr_o  ,
    ec11b_lva_i8 ,
    ec11b_rva_i8 ,
    
);

input       mcu_rst_i    ;
input       mcu_cs_i     ;
input       mcu_wr_i     ;
input       mcu_rd_i     ;
input [7:0] mcu_addr_i8  ;
input [7:0] mcu_wrdat_i8 ;
output[7:0] mcu_rddat_o8 ;
output      mcu_int_o    ;

output      ec11b_clr_o  ;
input [7:0] ec11b_lva_i8 ;
input [7:0] ec11b_rva_i8 ;

reg   [7:0] mcu_rddat_o8;
reg   [7:0] test_r8      ;
reg         mcu_intmsk_r ;
reg         ec11b_clr_r  ;

//----------------------------------------------------------
assign ec11b_int_i = 1'b0;

//assign ec11b_clr_o = mcu_cs_i&(mcu_wr_i|mcu_rd_i);

assign ec11b_clr_o = ec11b_clr_r;

assign mcu_int_o = (|ec11b_lva_i8)&(|ec11b_rva_i8)&mcu_intmsk_r;

//----------------------------------------------------------
always@ ( * )
begin
  if(mcu_rst_i)
    mcu_rddat_o8   =  8'h00;
  else if (mcu_cs_i & mcu_rd_i)
  begin
    case (mcu_addr_i8[7:0])
      8'h00:  mcu_rddat_o8[7:0] =  ec11b_lva_i8 ;
      8'h01:  mcu_rddat_o8[7:0] =  ec11b_rva_i8 ;
      8'h02:  mcu_rddat_o8[7:0] =  test_r8;
      8'h03:  mcu_rddat_o8[7:0] =  {7'b0,mcu_intmsk_r};
      8'h04:  mcu_rddat_o8[7:0] =  {7'b0,ec11b_clr_r};
      
    default:  mcu_rddat_o8[7:0] =  8'h0;
    endcase
  end
end

//----------------------------------------------------------
always@( * )
begin
  if(mcu_rst_i)
  begin
      test_r8      = 8'h00;
      mcu_intmsk_r = 1'b1;
      ec11b_clr_r  = 1'b0;
  end
  else if (mcu_cs_i & mcu_wr_i)
  begin
    case (mcu_addr_i8[7:0])
//    8'h00:  ec11b_lva_o8      =  mcu_wrdat_i8[7:0];
//    8'h01:  ec11b_lva_o8      =  mcu_wrdat_i8[7:0];

      8'h02:  test_r8           =  mcu_wrdat_i8[7:0];//²âÊÔ¶ÁÐ´¼Ä´æÆ÷
      8'h03:  mcu_intmsk_r      =  mcu_wrdat_i8[0];  //ÆÁ±ÎÖÐ¶Ï¼Ä´æÆ÷
      8'h04:  ec11b_clr_r       =  mcu_wrdat_i8[0];  //Çå³ýVALUEÖµ
      
    default:
      begin
          test_r8      = 8'h00;
          mcu_intmsk_r = 1'b1;
          ec11b_clr_r  = 1'b0;
      end
    endcase
  end
end

//---------------------------------------------------
endmodule 
