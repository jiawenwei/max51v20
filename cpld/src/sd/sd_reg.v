
`timescale 1ns/10ps
module sd_reg
(
    mcu_rst_i    ,
    mcu_cs_i     ,
    mcu_wr_i     ,
    mcu_rd_i     ,
    mcu_addr_i8  ,
    mcu_wrdat_i8 ,
    mcu_rddat_o8 ,
    mcu_int_o    ,
    
    sspshif_o    ,
    ssppres_o8   ,
    ssptdat_o8   ,
    
    ssprdat_i8   ,
    sspstat_i8   
);

  input       mcu_rst_i    ;
  input       mcu_cs_i     ;
  input       mcu_wr_i     ;
  input       mcu_rd_i     ;
  input [7:0] mcu_addr_i8  ;
  input [7:0] mcu_wrdat_i8 ;
  output[7:0] mcu_rddat_o8 ;
  output      mcu_int_o    ;
  output      sspshif_o    ;
  output[7:0] ssppres_o8   ;
  output[7:0] ssptdat_o8   ;
  input [7:0] ssprdat_i8   ;
  input [7:0] sspstat_i8   ;

  reg [7:0] ssppres_o8  ;
  reg [7:0] ssptdat_o8  ;
  reg [7:0] mcu_rddat_o8;
  reg [7:0] test_r8     ;

//----------------------------------------------------------
assign mcu_int_o = 1'b0;

//----------------------------------------------------------
always@(*)
begin
  if(mcu_rst_i)
    mcu_rddat_o8   =  8'h0;
  else if (mcu_cs_i & mcu_rd_i) 
  begin
    case (mcu_addr_i8[7:0])
      8'h00:  mcu_rddat_o8[7:0] =  ssprdat_i8     ;//¶ÁĞ´ÒÆÎ»¼Ä´æÆ÷·ÅÔÚÏàÍ¬µÄ¼Ä´æÆ÷µØÖ·
      8'h01:  mcu_rddat_o8[7:0] =  ssppres_o8     ;
      8'h02:  mcu_rddat_o8[7:0] =  sspstat_i8     ;//sspstatÖ»¶Á¼Ä´æÆ÷
      8'h03:  mcu_rddat_o8[7:0] =  test_r8        ;//²âÊÔ¶ÁĞ´¼Ä´æÆ÷
      
    default:  mcu_rddat_o8[7:0] =  8'h0           ;
    endcase
  end
end

//----------------------------------------------------------
always@(*)
begin
  if(mcu_rst_i)
  begin
      ssptdat_o8  = 8'h00;
      ssppres_o8  = 8'd4;
      test_r8     = 8'h00;
  end
  else if (mcu_cs_i & mcu_wr_i)
  begin
    case (mcu_addr_i8[7:0])
      8'h00:  ssptdat_o8        =  mcu_wrdat_i8[7:0];
      8'h01:  ssppres_o8        =  mcu_wrdat_i8[7:0];
    //8'h02:  sspstat_i8        =  mcu_wrdat_i8[7:0];//sspstatÖ»¶Á¼Ä´æÆ÷
      8'h03:  test_r8           =  mcu_wrdat_i8[7:0];//²âÊÔ¶ÁĞ´¼Ä´æÆ÷
      
    default:
      begin
          ssptdat_o8   = ssptdat_o8 ;
          ssppres_o8   = ssppres_o8 ;
      end
    endcase
  end
end

//---------------------------------------------------
assign sspshif_o = mcu_cs_i&(mcu_wr_i|mcu_rd_i)&~(|mcu_addr_i8);

//assign sspshif_o = mcu_cs_i && (mcu_wr_i || mcu_rd_i);


//---------------------------------------------------
endmodule 
