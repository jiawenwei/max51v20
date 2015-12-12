

//clk_i���Ϊ40MHz����spi_clk = 40MHz/2/(2��ssppres)�η�)
//                    spi_sck = spi_clk/4
//                    spi_sck���Ϊ5MHz

//����д1���ֽ�ʱ��������1.7us��34��spi_clk  (1/20MHz*34 = 1.7us) 
//SD��λ��ʼ�����������ʲ��ܸ���400kHz

//��ssppres=4��ʱ��spi_clk = 1.25MHz, spi_sck��Ϊ1.25MHz/4 = 312.5kHz
//��ssppres=0��ʱ��spi_clk = 20MHz, spi_sck��Ϊ20MHz/4 = 5MHz 

`timescale 1ns/10ps
module sd
(
    mcu_rst_i    ,
    mcu_cs_i     ,
    mcu_wr_i     ,
    mcu_rd_i     ,
    mcu_addr_i8  ,
    mcu_wrdat_i8 ,
    mcu_rddat_o8 ,

    clk_i        ,
    spi_sck_o    ,
    spi_sdo_o    ,
    spi_sdi_i    ,
    
    sspshif_o    ,
    current_state_dgo
);

  input         mcu_rst_i    ;
  input         mcu_cs_i     ;
  input         mcu_wr_i     ;
  input         mcu_rd_i     ;
  input [7:0]   mcu_addr_i8  ;
  input [7:0]   mcu_wrdat_i8 ;
  output[7:0]   mcu_rddat_o8 ;
  
  input         clk_i        ;
  output        spi_sck_o    ;
  output        spi_sdo_o    ;
  input         spi_sdi_i    ;
  
  //debug
  output        sspshif_o    ;
  output [3:0]       current_state_dgo;
  
//---------------------------------------------------
wire       sspshif;
wire [7:0] ssppres;
wire [7:0] ssptdat;
wire [7:0] sspsreg;
wire [7:0] sspstat;

assign        sspshif_o = sspshif;

sd_reg inst_sd_reg
(
    .mcu_rst_i    (mcu_rst_i    ),
    .mcu_cs_i     (mcu_cs_i     ),
    .mcu_wr_i     (mcu_wr_i     ),
    .mcu_rd_i     (mcu_rd_i     ),
    .mcu_addr_i8  (mcu_addr_i8  ),
    .mcu_wrdat_i8 (mcu_wrdat_i8 ),
    .mcu_rddat_o8 (mcu_rddat_o8 ),
    .mcu_int_o    (             ),

    .sspshif_o    (sspshif      ),//shift trigger
    .ssppres_o8   (ssppres      ),//Prescaler
    .ssptdat_o8   (ssptdat      ),//TX Buffer

    .ssprdat_i8   (sspsreg      ),//Rx buffer
    .sspstat_i8   (sspstat      ) //status
);

sd_ctrl inst_sd_ctrl
(
    .clk_i        (clk_i        ),
    .rst_i        (mcu_rst_i    ),

    .sttshift_i   (sspshif      ),
    .ssppres_i8   (ssppres      ),
    .ssptdat_i8   (ssptdat      ),
    
    .sspsreg_o8   (sspsreg      ),
    .sspstat_o8   (sspstat      ),

    .spi_sck_o    (spi_sck_o    ),
    .spi_sdo_o    (spi_sdo_o    ),
    .spi_sdi_i    (spi_sdi_i    ),
    
    .current_state_dgo(current_state_dgo)

);


//---------------------------------------------------
endmodule
