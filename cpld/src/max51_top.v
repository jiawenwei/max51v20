//pcb version: max51_v2.0
module max51_top
(
  CLK_50M_i     ,//50Mhz
  RESET_N_i     ,
  //
  CPU_ALE_i     ,
  CPU_nPSEN_i   ,
  CPU_nRD_i     ,
  CPU_nWR_i     ,
  CPU_DA_io8    ,//P0
  CPU_ADDR_i8   ,//P2
  
  CPU_INT0_o    ,
  CPU_INT1_o    ,
  CPU_LIB_i     ,
  V3_AD_nOE_o   ,
  V3_AD_DIR_o   ,
  //
  SRAM_nWE_o    ,
  SRAM_nOE_o    ,
  SRAM_ADD_o16  ,
  SRAM_DAT_io8  ,
  //
  LED_CTL_o     ,
  V3_LCD_nRST_o ,
  V3_LCD_RS_o   ,
  V3_LCD_E_o    ,
  V3_LCD_RW_o   ,
  //
  SD_SCK_o      ,
  SD_SDI_i      ,
  SD_SDO_o      ,
  SD_nCS_i      ,
  SD_CD_i       ,
  //
  KEY_COL_i4    ,
  KEY_ROW_o2    ,
  EC11E_A_i     ,
  EC11E_B_i     ,
  EC11E_D_i     ,
  //
  SOUND_o       ,
  LED_o8        ,
  //W25X20CLSN-spiFlash interface
  spi_nCS       ,//v2.0 2015/12/12
  spi_CLK       ,
  spi_MOSI      ,
  spi_MISO      ,
  //AT24C02D-eeprom -iic interface
  iic_SDA       ,//v2.0 2015/12/12
  iic_SCL       ,
  iic_WP        
);
//---------------------------------------------------
    //global input
    input           CLK_50M_i       ;//50MHz
    input           RESET_N_i       ;
    
    //89c52 interface
    input           CPU_ALE_i       ;
    input           CPU_nPSEN_i     ;
    input           CPU_nRD_i       ;
    input           CPU_nWR_i       ;
    inout [7:0]     CPU_DA_io8      ;//P0
    input [15:8]    CPU_ADDR_i8     ;//P2
    
    output          CPU_INT0_o      ;
    output          CPU_INT1_o      ;
    input           CPU_LIB_i       ;//??SRAM??65536??
    output          V3_AD_nOE_o     ;
    output          V3_AD_DIR_o     ;
    
    //IS62WV1288DBLL interface
    output          SRAM_nWE_o      ;
    output          SRAM_nOE_o      ;
    output [16:0]   SRAM_ADD_o16    ;
    inout  [7:0]    SRAM_DAT_io8    ;
    
    //LCD128x64 interface
    output          LED_CTL_o       ;
    output          V3_LCD_nRST_o   ;
    output          V3_LCD_RS_o     ;
    output          V3_LCD_E_o      ;
    output          V3_LCD_RW_o     ;
    
    //SD CARD control interface
    output          SD_SCK_o        ;
    input           SD_SDI_i        ;
    output          SD_SDO_o        ;
    input           SD_CD_i         ;
    output          SD_nCS_i        ;
    
    //2x3 Matrix keyboard interface 
    input  [3:0]    KEY_COL_i4      ;//v2.0 2015/12/12
    output [1:0]    KEY_ROW_o2      ;
    
    //EC11E encoder interface
    input           EC11E_A_i       ;
    input           EC11E_B_i       ;
    input           EC11E_D_i       ;
    
    //SOUND&&LED interface
    output          SOUND_o         ;
    output [7:0]    LED_o8          ;
    
    //W25X20CLSN-spiFlash interface
    output          spi_nCS         ;//v2.0 2015/12/12
    output          spi_CLK         ;
    output          spi_MOSI       ;
    input           spi_MISO       ;

    //AT24C02D-eeprom -iic interface
    inout           iic_SDA        ;//v2.0 2015/12/12
    output          iic_SCL        ;
    output          iic_WP         ;
    
    
//---------------------------------------------------
    wire   [7:0]    mcu_cs          ;
    wire   [7:0]    mcu_wrdat       ;
    wire   [15:0]   mcu_addr        ;
    
    wire   [7:0]    mcu_rddat0      ;
    wire   [7:0]    mcu_rddat1      ;
    wire   [7:0]    mcu_rddat2      ;
    wire   [7:0]    mcu_rddat3      ;
    wire   [7:0]    mcu_rddat4      ;
    wire   [7:0]    mcu_rddat5      ;
    wire   [7:0]    mcu_rddat6      ;
    wire   [7:0]    mcu_rddat7      ;
    
    wire            mcu_rst         ;
    wire            mcu_int0        ;
    wire            mcu_int1        ;
    wire            mcu_int2        ;
    wire            mcu_int3        ;
    wire            mcu_rd          ;
    wire            mcu_wr          ;
    wire            mcu_psen        ;
    
    wire            lcd_rst         ;
    wire            lcd_bk          ;
    wire   [7:0]    led_w8          ;
    wire   [2:0]    key_value       ;
    
//--------------------------------------
    assign  SD_nCS_i    = 1'b0;
    assign  V3_AD_nOE_o = 1'b0;
    assign  V3_AD_DIR_o = CPU_nRD_i&CPU_nPSEN_i;
    
    //assign  LED_o8 = ~mcu_cs;
    //assign  LED_o8 = mcu_addr[7:0];
    //assign  LED_o8 = ~led_w8;
    //assign  led_w8 = RESET_N_i? mcu_cs: 8'h55 ;
    assign  LED_o8 = {sspshif_dg_o,current_state_dgo,~key_value};

//debug---------
    wire         sspshif_dg_o;
    wire[3:0]    current_state_dgo;
    
//--------------------------------------
cpu_if      inst_cpu_if
(
    .cpu_rst_i    (RESET_N_i    ),
    .cpu_cs_ni    (1'b0         ),
    .cpu_ale_i    (CPU_ALE_i    ),
    .cpu_psen_ni  (CPU_nPSEN_i  ),
    .cpu_rd_ni    (CPU_nRD_i    ),
    .cpu_wr_ni    (CPU_nWR_i    ),
    .cpu_lib_i    (CPU_LIB_i    ),
    .cpu_da_io8   (CPU_DA_io8   ),
    .cpu_a_i8     (CPU_ADDR_i8  ),
    .cpu_int0_o   (CPU_INT0_o   ),
    .cpu_int1_o   (CPU_INT1_o   ),
    //
    .mcu_rddat0_i8(mcu_rddat0   ),
    .mcu_rddat1_i8(mcu_rddat1   ),
    .mcu_rddat2_i8(mcu_rddat2   ),
    .mcu_rddat3_i8(mcu_rddat3   ),
    .mcu_rddat4_i8(             ),
    .mcu_rddat5_i8(             ),
    .mcu_rddat6_i8(             ),
    .mcu_rddat7_i8(mcu_rddat7   ),
    .mcu_wrdat_o8 (mcu_wrdat    ),
    .mcu_addr_o16 (mcu_addr     ),
    //
    .mcu_rst_o    (mcu_rst      ),
    .mcu_int0_i   (1'b0         ),
    .mcu_int1_i   (1'b0         ),
    .mcu_int2_i   (1'b0         ),
    .mcu_int3_i   (mcu_int3     ),
    .mcu_cs_o8    (mcu_cs[7:0]  ),
    .mcu_rd_o     (mcu_rd       ),
    .mcu_wr_o     (mcu_wr       ),
    .mcu_psen_o   (mcu_psen     )
    
);

//--------------------------------------
sram_ctrl   inst_sram_ctrl
(
    .mcu_rst_i    (mcu_rst        ),
    .mcu_cs_i     (mcu_cs[7]      ),//0000~ff8f
    .mcu_wr_i     (mcu_wr         ),
    .mcu_rd_i     (mcu_rd         ),
    .mcu_psen_i   (mcu_psen       ),
    .mcu_addr_i16 (mcu_addr[15:0] ),
    .mcu_wrdat_i8 (mcu_wrdat      ),
    .mcu_rddat_o8 (mcu_rddat7     ),

    .sram_data_io8(SRAM_DAT_io8   ),
    .sram_addr_o17(SRAM_ADD_o16   ),
    .sram_oe_no   (SRAM_nOE_o     ),
    .sram_we_no   (SRAM_nWE_o     )
);

//--------------------------------------
lcd_ctrl    inst_lcd_ctrl
(
    .mcu_rst_i    (mcu_rst        ),
    .mcu_cs_i     (mcu_cs[0]      ),//ff90~ff9f
    .mcu_wr_i     (mcu_wr         ),
    .mcu_rd_i     (mcu_rd         ),
    .mcu_addr_i16 (mcu_addr[15:0] ),
    .mcu_rddat_o8 (mcu_rddat0     ),

    .lcd_rst_i    (lcd_rst        ),
    .lcd_bk_i     (lcd_bk         ),
    .lcd_nrst_o   (V3_LCD_nRST_o  ),
    .lcd_bk_o     (LED_CTL_o      ),
    .lcd_rs_o     (V3_LCD_RS_o    ),
    .lcd_rw_o     (V3_LCD_RW_o    ),
    .lcd_e_o      (V3_LCD_E_o     )
);

//--------------------------------------
common_reg  inst_common_reg
(
    .mcu_rst_i    (mcu_rst        ),
    .mcu_cs_i     (mcu_cs[1]      ),//ffa0~ffaf
    .mcu_rd_i     (mcu_rd         ),
    .mcu_wr_i     (mcu_wr         ),
    .mcu_addr_i8  ({4'h0,mcu_addr[3:0]}),
    .mcu_wrdat_i8 (mcu_wrdat      ),
    .mcu_rddat_o8 (mcu_rddat1     ),
    .mcu_int_o    (               ),
    //-- output ----------------  //
    .sound_o      (SOUND_o        ),
    .led_o8       (led_w8         ),
    .lcd_rst_o    (lcd_rst        ),
    .lcd_bk_o     (lcd_bk         )
);

//--------------------------------------
sd          inst_sd
(
    .mcu_rst_i    (mcu_rst        ),
    .mcu_cs_i     (mcu_cs[2]      ),//ffb0~ffbf
    .mcu_wr_i     (mcu_wr         ),
    .mcu_rd_i     (mcu_rd         ),
    .mcu_addr_i8  ({4'h0,mcu_addr[3:0]}),
    .mcu_wrdat_i8 (mcu_wrdat      ),
    .mcu_rddat_o8 (mcu_rddat2     ),

    .clk_i        (CLK_50M_i      ),
    .spi_sdi_i    (SD_SDI_i       ),//??????
    .spi_sdo_o    (SD_SDO_o       ),
    .spi_sck_o    (SD_SCK_o       ),

    .sspshif_o    (sspshif_dg_o   ),
    .current_state_dgo(current_state_dgo)
);

//--------------------------------------
ec11b       inst_ec11b
(
    .mcu_rst_i      (mcu_rst        ),//ffc0~ffcf
    .mcu_cs_i       (mcu_cs[3]      ),
    .mcu_wr_i       (mcu_wr         ),
    .mcu_rd_i       (mcu_rd         ),
    .mcu_addr_i8    ({4'h0,mcu_addr[3:0]}),
    .mcu_wrdat_i8   (mcu_wrdat      ),
    .mcu_rddat_o8   (mcu_rddat3     ),
    .mcu_int_o      (mcu_int3       ),
    
    .clk_i          (CLK_50M_i      ),//50MHZ
    .a_pin_i        (EC11E_A_i      ),
    .b_pin_i        (EC11E_B_i      ),
    .d_pin_i        (EC11E_D_i      ),
    
);

key         inst_key
(
    .mcu_rst_i    (mcu_rst          ),//ffd0~ffdf
    .mcu_cs_i     (mcu_cs[4]        ),
    .mcu_wr_i     (mcu_wr           ),
    .mcu_rd_i     (mcu_rd           ),
    .mcu_addr_i8  ({4'h0,mcu_addr[3:0]}),
    .mcu_wrdat_i8 (mcu_wrdat        ),
    .mcu_rddat_o8 (mcu_rddat4       ),
    .mcu_int_o    (mcu_int4         ),

    .clk_i        (CLK_50M_i        ),//50MHZ
    .key_col_i4   (KEY_COL_i4       ),//?
    .key_row_o2   (KEY_ROW_o2       ),//?

);


//---------------------------------------------------
endmodule
