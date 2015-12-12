
`timescale  1ns / 100ps
module max51
(
    reset       ,
    clk         ,
    
    mcu_wr_n    ,
    mcu_rd_n    ,
    mcu_ale     ,
    mcu_psen_n  ,
    
    mcu_p0      ,
    mcu_p2      ,
    
    PH_nLED     ,
    V3_AD_nOE   ,
    V3_AD_DIR   ,
    SOUND       ,
    
    LED_CTRL    ,
    V3_LCD_nRST ,
    V3_LCD_RS   ,
    V3_LCD_E    ,
    V3_LCD_RW   ,
    
    
    
);
    //----------------------------------------
    input       reset   ;
    input       clk     ;  //input 50MHz clock;
    
    input       mcu_wr_n;
    input       mcu_rd_n;
    input       mcu_ale ;
    input       mcu_psen_n;
    
    input[7:0]  mcu_p2;
    inout[7:0]  mcu_p0;
    
    output[1:8] PH_nLED;
    output      V3_AD_nOE;
    output      V3_AD_DIR;
    output      SOUND;
    
    output      LED_CTRL;
    output      V3_LCD_nRST;
    output      V3_LCD_RS;
    output      V3_LCD_RW;
    output      V3_LCD_E;
    
    reg         wr_n_dy1;
    reg         wr_n_dy2;
    reg         wr_h2l;
    
    reg         rd_n_dy1;
    reg         rd_n_dy2;
    reg         rd_h2l;

    reg         ale_dy1;
    reg         ale_dy2;
    reg         ale_h2l;

    reg         psen_n_dy1;
    reg         psen_n_dy2;
    reg         psen_n_h2l;

    reg         wr_h2l_dy1;//write negedge earlier than data put out
    reg         wr_h2l_dy2;
    reg         wr_h2l_dy3;
    reg         wr_h2l_dy4;

    reg         rd_h2l_dy1;
    reg         rd_h2l_dy2;
    reg         rd_h2l_dy3;
    reg         rd_h2l_dy4;

    
    reg [15:0]  addr_r;
    reg[ 7:0]   leds_o;
    wire        rst;
    
    reg         sound;
    reg         lcd_rst;
    reg         led_ctrl;
    
    assign  LED_CTRL=led_ctrl;
    assign  V3_LCD_nRST=~lcd_rst;
    
    assign  V3_LCD_E = ~(mcu_wr_n&mcu_rd_n);
    
    assign  V3_LCD_RW =mcu_p2[1];
    assign  V3_LCD_RS =mcu_p2[0];
    
    assign  PH_nLED =~leds_o;
    
    assign  SOUND = sound;
    assign  rst = ~reset;
    assign  V3_AD_nOE = 1'b0;
    assign  V3_AD_DIR = mcu_rd_n;
    //assign  V3_AD_DIR = 1'b1;
    
//    reg [8:0]   column;
//    reg [8:0]   line  ;
    
      reg [7:0]   rdata;
//    reg [7:0]   datain;
    
//    assign  mcu_p0 = (!mcu_rd_n) ? rdata : 8'hzz;
    
    assign  mcu_p0 = (!mcu_rd_n) ? 8'hzz : 8'hzz;
    
    //---------------------------------------------
    always@(posedge clk)
    begin
        if(rst)
          begin
            wr_n_dy1   <= 0;
            wr_n_dy2   <= 0;
            wr_h2l     <= 0;
            rd_n_dy1   <= 0;
            rd_n_dy2   <= 0;
            rd_h2l     <= 0;
            ale_dy1    <= 0;
            ale_dy2    <= 0;
            ale_h2l    <= 0;
            psen_n_dy1 <= 0;
            psen_n_dy2 <= 0;
            psen_n_h2l <= 0;

            wr_h2l_dy1 <= 0;
            wr_h2l_dy2 <= 0;
            wr_h2l_dy3 <= 0;
            wr_h2l_dy4 <= 0;

            rd_h2l_dy1 <= 0;
            rd_h2l_dy2 <= 0;
            rd_h2l_dy3 <= 0;
            rd_h2l_dy4 <= 0;
          end
        else 
          begin
            wr_n_dy1    <= ~mcu_wr_n;
            wr_n_dy2    <= wr_n_dy1;
            wr_h2l      <= wr_n_dy1&~wr_n_dy2;
            
            rd_n_dy1    <= ~mcu_rd_n;
            rd_n_dy2    <= rd_n_dy1;
            rd_h2l      <= rd_n_dy1&~rd_n_dy2;

            ale_dy1     <= ~mcu_ale;
            ale_dy2     <= ale_dy1;
            ale_h2l     <= ale_dy1&~ale_dy2;
            
            psen_n_dy1  <= ~mcu_psen_n;
            psen_n_dy2  <= psen_n_dy1;
            psen_n_h2l  <= psen_n_dy1&~psen_n_dy2;

            wr_h2l_dy1  <= wr_h2l;
            wr_h2l_dy2  <= wr_h2l_dy1;
            wr_h2l_dy3  <= wr_h2l_dy2;
            wr_h2l_dy4  <= wr_h2l_dy3;
            
            rd_h2l_dy1  <= rd_h2l;
            rd_h2l_dy2  <= rd_h2l_dy1;
            rd_h2l_dy3  <= rd_h2l_dy2;
            rd_h2l_dy4  <= rd_h2l_dy3;

          end
    end
    //---------------------------------------------
    always@(posedge clk)
    begin
        if(rst)
        begin
            addr_r <= 16'h0;
        end
        else if(ale_h2l)
        begin
            addr_r <= {mcu_p2,mcu_p0};
        end
    end
    //---------------------------------------------
    always@(posedge clk)
    begin
        if(rst)
        begin
            rdata  <= 8'h0;
            leds_o <= 8'h55;
            sound  <= 1'b0;
            led_ctrl    <= 1'b1;
            lcd_rst     <= 1'b0;
        end
        else if(wr_h2l_dy1)
        begin
//            leds_o<= addr_r[15:8];
//            leds_o<= mcu_p0;
            case(addr_r)
            16'h5555:
                begin
                    //leds_o<=8'hf0;
                    leds_o<=mcu_p0;
                end
            16'hAAAA:
                begin
                    //leds_o<=8'h0f;
                    leds_o<=mcu_p0;
                end
            16'h8888:
                begin
                    //leds_o<=8'h0f;
                    sound<=mcu_p0[0];
                end
            16'hf001:
                begin
                    led_ctrl<=mcu_p0[0];
                    lcd_rst <=mcu_p0[1];
                end
            default: 
                    leds_o<= mcu_p0;
            endcase
        end
        else if(rd_h2l)
        begin
            case(addr_r)
            16'h5555:
                begin
                    rdata<=8'h55;
                end
            16'hAAAA:
                begin
                    rdata<=8'hAA;
                end
            default: 
					rdata<= 8'h88;
            endcase
        end
    end

//--------------------------------------------------------------------
endmodule

