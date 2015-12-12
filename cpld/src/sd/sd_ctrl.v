
//SD命令由6个字节(48bit)组成，先发送第一个字节的第7位,左移8位发送一字节.
//SD卡时序:上升沿采样数据,下降沿发送数据
//主机时序:下降沿采样数据,上升沿发送数据

`timescale 1ns/10ps
module sd_ctrl
(
    clk_i        ,
    rst_i        ,
    
    sttshift_i   , //shift trigger
    ssppres_i8   , //Prescaler
    ssptdat_i8   , //Tx buffer
    sspsreg_o8   , //Rx buffer
    sspstat_o8   , //status
    
    spi_sck_o    ,
    spi_sdo_o    ,
    spi_sdi_i    ,
    
    current_state_dgo
);

parameter [4:0] IDLE      = 5'b00001;
parameter [4:0] READY     = 5'b00010;
parameter [4:0] POSEDGE   = 5'b00100;
parameter [4:0] NEGEDGE   = 5'b01000;
parameter [4:0] DELAY     = 5'b10000;

  input         clk_i        ;
  input         rst_i        ;
  
  input         sttshift_i   ; //shift trigger
  input [7:0]   ssppres_i8   ; //Prescaler
  input [7:0]   ssptdat_i8   ; //Tx buffer
  output[7:0]   sspsreg_o8   ; //Rx buffer
  output[7:0]   sspstat_o8   ; //status
  
  output        spi_sck_o    ;
  output        spi_sdo_o    ;
  input         spi_sdi_i    ;

  //debug
  output[3:0]    current_state_dgo    ;
  //assign        current_state_dgo ={1'b0,delay_ok,shift_trigger,shift_ok};
  //  assign      current_state_dgo=sbcnt;
//---------------------------------------------------
reg   sttshift_i_dy1;
reg   sttshift_i_dy2;
reg   sttshift_i_dy3;
wire  shift_negedge;
reg   clk_i2;
wire  rst_n;

reg   shift_ok_dy1;
reg   shift_ok_dy2;
reg   shift_ok_dy3;
wire  shift_ok_posedge;

assign rst_n = ~rst_i;

always@(posedge clk_i or negedge rst_n)
begin
  if(!rst_n)
  begin
    sttshift_i_dy1  <= 1'b0;
    sttshift_i_dy2  <= 1'b0;
    sttshift_i_dy3  <= 1'b0;
  end
  else
  begin
    sttshift_i_dy1 <= sttshift_i;
    sttshift_i_dy2 <= sttshift_i_dy1;
    sttshift_i_dy3 <= sttshift_i_dy2;
  end
end

assign shift_negedge = sttshift_i_dy3&~sttshift_i_dy2;
//---------------------------------------------------
reg  [7:0]  clk_cnt       ;
reg         shift_trigger ;
wire        spi_clk       ;
reg         shift_ok      ;

always@(posedge clk_i or negedge rst_n)
begin
  if(!rst_n)
  begin
    shift_ok_dy1  <= 1'b0;
    shift_ok_dy2  <= 1'b0;
    shift_ok_dy3  <= 1'b0;
  end
  else
  begin
        shift_ok_dy1 <= shift_ok;
        shift_ok_dy2 <= shift_ok_dy1;
        shift_ok_dy3 <= shift_ok_dy2;
  end
end

assign shift_ok_posedge = ~shift_ok_dy3&shift_ok_dy2;
//---------------------------------------------------
always@(posedge clk_i or negedge rst_n)
begin
  if(!rst_n)
  begin
    clk_cnt[7:0]  <= 8'd0;
    shift_trigger <= 1'b0;
  end
  else
  begin
    clk_cnt[7:0] <= clk_cnt[7:0] + 8'd1;
    if(shift_negedge)
        shift_trigger <= 1'b1;
    else if(shift_ok_posedge)             //shift_ok
        shift_trigger <= 1'b0;
  end
end

//---------------------------------------------------
reg[7:0] ssppres_r8;

always@(posedge clk_i or negedge rst_n)
begin
  if(!rst_n)
  begin
    ssppres_r8 <= 8'h00;
  end
  else
  begin
    ssppres_r8 <= ssppres_i8;
  end
end

assign spi_clk = clk_cnt[ssppres_r8];

//---------------------------------------------------
reg [4:0] current_state ;
reg [4:0] next_state    ;
reg [4:0] nstate        ;
reg [7:0] dycnt         ;

wire      spi_sdi ;
reg       spi_sck ;
reg       spi_sdo ;

reg       st_idle ;
reg       delay_ok;

reg [3:0] sbcnt   ;
reg [7:0] sspsreg ;

//----------------------------------------
always @ (posedge spi_clk or negedge rst_n)
if(!rst_n)
  begin
    current_state <= IDLE;
  end
else
  begin
    current_state <= next_state;
  end

//----------------------------------------com
always@( * )
begin
    next_state = 5'bxxxxx;
//    nstate     = IDLE;
//    shift_ok   = 1'b0;
//    
    case(current_state)
    IDLE:
      begin
        shift_ok     = 1'b0;
        if(shift_trigger)
        begin
          next_state = READY;
        end
        else 
        begin
          next_state = IDLE;
          nstate     = IDLE;
        end
      end
    READY:
      begin
        next_state  = DELAY;
        nstate      = POSEDGE;
      end
    POSEDGE:
      begin
        next_state  = DELAY;
        nstate      = NEGEDGE;
      end
    NEGEDGE:
      begin
        if(sbcnt == 4'd0)
          begin
            next_state  = IDLE;
            shift_ok    = 1'b1;
          end
        else
          begin
            next_state = DELAY;
            nstate = POSEDGE;
          end
      end
    DELAY:
      begin
        if(delay_ok)
        begin
          next_state = nstate;
        end
        else
        begin
          next_state = next_state;
        end
      end
      
    default:
      begin
        next_state   = IDLE;
        nstate       = IDLE;
        shift_ok     = 1'b0;
      end
    endcase
end
//----------------------------------------output
always @(posedge spi_clk or negedge rst_n)
begin
  if(!rst_n)
  begin
    spi_sck   <= 1'b0;
    spi_sdo   <= 1'b1;
    sbcnt     <= 4'd8;
    st_idle   <= 1'b1;
    sspsreg   <= 8'hff;
    
    dycnt     <= 8'd1;
    delay_ok  <= 1'b0;
  end
  else
  begin
    case(next_state)
      IDLE:
          begin
            spi_sdo      <= 1'b1;
            spi_sck      <= 1'b0;
            st_idle      <= 1'b1;
            
            dycnt        <= 8'd1;
            delay_ok     <= 1'b0;
          end
      READY:
          begin
            sspsreg[7:0] <= ssptdat_i8;
            //spi_sdo      <= sspsreg[7];//此时为前一个字节的第7位，非预装之后的ssptdat_i8[7]
            sbcnt        <= 4'd8;
            st_idle      <= 1'b0;
            
            dycnt        <= 8'd1;
            delay_ok     <= 1'b0;
          end
      POSEDGE:
          begin
            spi_sck      <= 1'b1;
            //spi_sdo      <= sspsreg[7];//
            
            dycnt        <= 8'd1;
            delay_ok     <= 1'b0;
          end
      NEGEDGE:
          begin
            spi_sck      <= 1'b0;
            //spi_sdo      <= sspsreg[7];//
            sspsreg[7:0] <= {sspsreg[6:0],spi_sdi};
            sbcnt        <= sbcnt-4'd1;
            dycnt        <= 8'd1;
            delay_ok     <= 1'b0;
          end
      DELAY:
          begin
            spi_sdo      <= sspsreg[7];
            
            if(dycnt == 8'd1)
            begin
              delay_ok   <= 1'b1;
              dycnt      <= 8'd0;
            end
            else
            begin
              //dycnt     <= dycnt -8'd1;
            end
          end
      
      default:
          begin
            spi_sck     <= 1'b0;
            spi_sdo     <= 1'b1;
          end
    endcase
  end
end

//---------------------------------------------------
assign spi_sck_o    = spi_sck;
assign spi_sdo_o    = spi_sdo;
assign spi_sdi      = spi_sdi_i;
assign sspsreg_o8   = sspsreg;
assign sspstat_o8   = {7'b0,st_idle};

//assign current_state_dgo={shift_trigger,shift_ok,st_idle,debug[0]};shift_negedge
//assign current_state_dgo={shift_trigger,shift_ok,shift_ok_posedge,st_idle};

//assign current_state_dgo = {spi_clk,next_state[3:1]};
//---------------------------------------------------
endmodule
