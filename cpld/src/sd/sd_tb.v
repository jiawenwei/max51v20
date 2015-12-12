
`timescale 1ns/100ps
module sd_tb;

reg         mcu_clk   ;
reg         mcu_rst   ;
reg         mcu_rd    ;
reg         mcu_wr    ;
reg  [7:0]  mcu_addr  ;
reg  [7:0]  mcu_wrdat ;
wire [7:0]  mcu_rddat ;

reg  [2:0]  dowork    ;
reg         clk       ;


  initial
  begin
    clk       = 1'b0;
    mcu_rst   = 1'b1;
    mcu_clk   = 1'b0;
    dowork    = 3'b111;

    #500    mcu_rst = 1'b0;
    
    #255000  dowork  = 3'd1;
    #255000  dowork  = 3'd2;
    #255000  dowork  = 3'd3;
    #255000  dowork  = 3'd4;
    #255000  dowork  = 3'd4;
    #255000  dowork  = 3'd4;
    #255000  dowork  = 3'd4;
    #255000  dowork  = 3'd5;
    #255000  dowork  = 3'd6;
    
    #299000  dowork  = 3'd0;
    #25500   dowork  = 3'd2;
    #25500   dowork  = 3'd3;
    #25500   dowork  = 3'd4;
    #25500   dowork  = 3'd4;
    #25500   dowork  = 3'd4;
    #25500   dowork  = 3'd4;
    #25500   dowork  = 3'd5;
    #25500   dowork  = 3'd6;
    
    #255000  dowork  = 3'b111;
  end

  always #8.3 clk  = ~clk; //60MHz
  always #27.1 mcu_clk  = ~mcu_clk; //18.432MHz
  
  always@(posedge mcu_clk or posedge mcu_rst)
  begin
    if(mcu_rst)
    begin
      mcu_wr    <= 1'b0;
      mcu_rd    <= 1'b0;
      mcu_addr  <= 8'h00;
      mcu_wrdat <= 8'h00;
    end
    else
    begin
        case(dowork)
          3'd0:
          begin
            mcu_wr    <= 1'b1;
            mcu_addr  <= 8'h01;
            mcu_wrdat <= 8'd0;
            dowork    <= 3'b111;
          end
          3'd1:
          begin
            mcu_wr    <= 1'b1;
            mcu_addr  <= 8'h01;
            mcu_wrdat <= 8'd6;
            dowork    <= 3'b111;
          end
          3'd2:
          begin
            mcu_wr    <= 1'b1;
            mcu_addr  <= 8'h00;
            mcu_wrdat <= 8'h56;
            dowork    <= 3'b111;
          end
          3'd3:
          begin
            mcu_wr    <= 1'b1;
            mcu_addr  <= 8'h00;
            mcu_wrdat <= 8'hff;
            dowork    <= 3'b111;
          end
          3'd4:
          begin
            mcu_rd    <= 1'b1;
            mcu_addr  <= 8'h00;
          //mcu_wrdat <= 8'hxx;
            dowork    <= 3'b111;
          end
          3'd5:
          begin
            mcu_rd    <= 1'b1;
            mcu_addr  <= 8'h01;
          //mcu_wrdat <= 8'hxx;
            dowork    <= 3'b111;
          end
          3'd6:
          begin
            mcu_rd    <= 1'b1;
            mcu_addr  <= 8'h02;
          //mcu_wrdat <= 8'hxx;
            dowork    <= 3'b111;
          end
          
          default://dowork    <= 3'b111;
          begin
            mcu_wr    <= 1'b0;
            mcu_rd    <= 1'b0;
            mcu_addr  <= 8'hzz;
            mcu_wrdat <= 8'hzz;
          end
        endcase
    end
  end
  
wire      sck   ;
wire      sdo   ;
reg       sdi   ;
reg [31:0] spsreg;

  sd  inst_sd
  (
      .mcu_rst_i    (mcu_rst  ),
      .mcu_cs_i     (1'b1     ),
      .mcu_wr_i     (mcu_wr   ),
      .mcu_rd_i     (mcu_rd   ),
      .mcu_addr_i8  (mcu_addr ),
      .mcu_wrdat_i8 (mcu_wrdat),
      .mcu_rddat_o8 (mcu_rddat),
      
      .clk_i        (clk      ),
      .spi_sck_o    (sck      ),
      .spi_sdo_o    (sdo      ),
      .spi_sdi_i    (sdi      )
  );
  
  always@(posedge sck or posedge mcu_rst)
  if(mcu_rst)
  begin
    spsreg[31:0] <= 32'hffffff55;
    sdi          <= 1'b1;
  end
  else
  begin
    sdi          <= spsreg[31];
    spsreg[31:0] <= {spsreg[30:0],sdo};
  end


//---------------------------------------------------
endmodule

