

module cpu_if
(
    cpu_rst_i     ,
    cpu_cs_ni     ,
    cpu_ale_i     ,
    cpu_psen_ni   ,
    cpu_rd_ni     ,
    cpu_wr_ni     ,
    cpu_lib_i     ,
    cpu_da_io8    ,
    cpu_a_i8      ,
    cpu_int0_o    ,
    cpu_int1_o    ,
    
    mcu_rddat0_i8 ,
    mcu_rddat1_i8 ,
    mcu_rddat2_i8 ,
    mcu_rddat3_i8 ,
    mcu_rddat4_i8 ,
    mcu_rddat5_i8 ,
    mcu_rddat6_i8 ,
    mcu_rddat7_i8 ,

    mcu_wrdat_o8  ,
    mcu_addr_o16  ,
    
    mcu_rst_o     ,
    mcu_int0_i    ,
    mcu_int1_i    ,
    mcu_int2_i    ,
    mcu_int3_i    ,
    mcu_int4_i    ,
    mcu_cs_o8     ,
    mcu_rd_o      ,
    mcu_wr_o      ,
    mcu_psen_o

  );

//89s52 interface
input         cpu_rst_i     ;
input         cpu_cs_ni     ;
input         cpu_ale_i     ;
input         cpu_psen_ni   ;
input         cpu_rd_ni     ;
input         cpu_wr_ni     ;
input         cpu_lib_i     ;
inout [ 7:0]  cpu_da_io8    ;
input [15:8]  cpu_a_i8      ;
output        cpu_int0_o    ;
output        cpu_int1_o    ;

input [ 7:0]  mcu_rddat0_i8 ;
input [ 7:0]  mcu_rddat1_i8 ;
input [ 7:0]  mcu_rddat2_i8 ;
input [ 7:0]  mcu_rddat3_i8 ;
input [ 7:0]  mcu_rddat4_i8 ;
input [ 7:0]  mcu_rddat5_i8 ;
input [ 7:0]  mcu_rddat6_i8 ;
input [ 7:0]  mcu_rddat7_i8 ;

output[ 7:0]  mcu_wrdat_o8  ;
output[15:0]  mcu_addr_o16  ;

input         mcu_int0_i    ;
input         mcu_int1_i    ;
input         mcu_int2_i    ;
input         mcu_int3_i    ;
input         mcu_int4_i    ;
output[7:0]   mcu_cs_o8     ;
reg   [7:0]   mcu_cs_o8     ;

output        mcu_rst_o     ;
output        mcu_wr_o      ;
output        mcu_rd_o      ;
output        mcu_psen_o    ;

reg [7:0]     mcu_rddat     ;
reg [15:0]    mcu_addr_o16  ;
//===================================================
/*
ram:00000~0ffff   µÍ65536ÎªRAM
rom:10000~1ffff   ¸ß65536ÎªROM
*/
//assign mcu_ram_rd = !(!cpu_rd_ni & cpu_psen_ni & !cpu_lib_i);//high active
//assign mcu_ram_wr = !(!cpu_wr_ni & cpu_psen_ni & !cpu_lib_i);
//assign mcu_rom_rd  = !(!cpu_rd_ni & cpu_psen_ni & cpu_lib_i);
//assign mcu_rom_wr  = !(!cpu_wr_ni & cpu_psen_ni & cpu_lib_i);
//assign mcu_rom_prd = !cpu_psen_ni;


assign mcu_rst_o      = ~cpu_rst_i;

assign mcu_psen_o     = !cpu_psen_ni; //only sdram module used
assign mcu_rd_o       = !cpu_rd_ni;
assign mcu_wr_o       = !cpu_wr_ni;

assign cpu_da_io8     = !cpu_cs_ni&(!cpu_rd_ni | !cpu_psen_ni) ? mcu_rddat : 8'hzz; //cpu_da_io8 = mcu_rddat when cpu reading
//assign cpu_da_io8     = (!cpu_rd_ni )? mcu_rddat : 8'hzz;
assign mcu_wrdat_o8   = cpu_da_io8;

assign cpu_int0_o     = mcu_int0_i|mcu_int1_i|mcu_int2_i|mcu_int3_i;

assign cpu_int1_o     = mcu_int4_i;

//--------------------------------------
reg[15:0] cpu_addr;

always@(negedge cpu_ale_i)
begin
  if(mcu_rst_o)
  begin
    cpu_addr[15:0] <= 16'd0;
  end
  else
  begin
    cpu_addr[15:0] <= {cpu_a_i8,cpu_da_io8};
  end
end
//--------------------------------------
always@( * )
begin
  if(mcu_rst_o)
    mcu_addr_o16[15:0] <= 16'd0;
  else
  begin
    mcu_addr_o16[15:0] <= cpu_addr[15:0];
  end
end

//--------------------------------------
always@( * )
begin
  if(mcu_rst_o)
  begin
    mcu_cs_o8[7:0] <= 8'h00;
  end
  else if(cpu_cs_ni == 1'b0)
  begin
    case (cpu_addr[15:4])
      12'hff9:  mcu_cs_o8[7:0] <=8'b00000001;   // CS0 ----> 0xFF90~0xFF9F 
      12'hffa:  mcu_cs_o8[7:0] <=8'b00000010;   // CS1 ----> 0xFFA0~0xFFAF
      12'hffb:  mcu_cs_o8[7:0] <=8'b00000100;   // CS2 ----> 0xFFB0~0xFFBF
      12'hffc:  mcu_cs_o8[7:0] <=8'b00001000;   // CS3 ----> 0xFFC0~0xFFCF
      12'hffd:  mcu_cs_o8[7:0] <=8'b00010000;   // CS4 ----> 0xFFD0~0xFFDF
      12'hffe:  mcu_cs_o8[7:0] <=8'b00100000;   // CS5 ----> 0xFFE0~0xFFEF
      12'hfff:  mcu_cs_o8[7:0] <=8'b01000000;   // CS6 ----> 0xFFF0~0xFFFF
      default:  mcu_cs_o8[7:0] <=8'b10000000;   // CS7 ----> 0xFFF0~0xFFFF  for Special Static RAM
    endcase
  end
end

//---------------- mcu datout ctrl ---------//
always@( * )
begin
    if(mcu_rst_o)
    begin
        mcu_rddat <=  8'h00;
    end
    else if(cpu_cs_ni == 1'b0)
    begin
        case(mcu_cs_o8)
            8'h01: mcu_rddat <= mcu_rddat0_i8;  // CS0 ----> 0xFF80~0xFF8F 
            8'h02: mcu_rddat <= mcu_rddat1_i8;  // CS1 ----> 0xFF90~0xFF9F 
            8'h04: mcu_rddat <= mcu_rddat2_i8;  // CS2 ----> 0xFFA0~0xFFAF 
            8'h08: mcu_rddat <= mcu_rddat3_i8;  // CS3 ----> 0xFFB0~0xFFBF 
            8'h10: mcu_rddat <= mcu_rddat4_i8;  // CS4 ----> 0xFFC0~0xFFCF 
            8'h20: mcu_rddat <= mcu_rddat5_i8;  // CS5 ----> 0xFFD0~0xFFDF 
            8'h40: mcu_rddat <= mcu_rddat6_i8;  // CS6 ----> 0xFFE0~0xFFEF 
            8'h80: mcu_rddat <= mcu_rddat7_i8;  // CS7 ----> 0xFFF0~0xFFFF  for Special Static RAM 
            default: mcu_rddat <= 8'h00;
        endcase
    end
    else
    begin
        mcu_rddat <= 8'h00;
    end
end

//---------------------------------------------------
endmodule

