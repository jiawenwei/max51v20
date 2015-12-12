
`timescale 1ns/10ps
module key_ctrl
( 
    clk_i       ,   //50MHZ 
    rst_i       ,   
    col_i4      ,   //?
    row_o2      ,   //?

    key_o       ,   //??
    clr_i       ,   //??
    int_o       ,   //??
    sta_o       ,
    
);
    input           clk_i;
    input           rst_i;
    input   [3:0]   col_i4;
    output  [1:0]   row_o2;
    
    output  [2:0]   key_o;
    input           clr_i;
    output          int_o;
    output          sta_o;
    
    reg [1:0]   row_r2; 
    reg [3:0]   key_r; 
    reg [5:0]   count;      //delay_20ms 
    
    reg [2:0]   state;      //????
    reg         key_flag;   //?????
    reg         clk_500khz; //500KHZ????
    reg [3:0]   col_reg;    //??????
    reg [1:0]   row_reg;    //??????
    
    assign      row_o2  =row_r2;
    assign      key_o   =key_r;

//-------------------------------------
    always @(posedge clk_i or posedge rst_i) 
    if(rst_i) 
        begin 
            clk_500khz<=0; 
            count<=0; 
        end
    else
    begin
        if(count>=50) 
        begin 
            clk_500khz<=~clk_500khz;
            count<=0;
        end 
        else 
            count<=count+1; 
    end 

//-------------------------------------
    always @(posedge clk_500khz or posedge rst_i) 
    if(rst_i) 
        begin 
            row_r2<=2'b00;
            state<=0;
        end 
    else 
    begin 
        case (state) 
        0: 
        begin 
            row_r2[1:0]<=2'b00; 
            key_flag<=1'b0;
            if(col_i4[3:0]!=4'b1111) 
            begin
                state<=1;
                row_r2[1:0]<=2'b10;
            end //??????????
            else 
                state<=0; 
        end
        1:
        begin 
            if(col_i4[3:0]!=4'b1111) //????????
            begin 
                state<=5;
            end 
            else 
            begin 
                state<=2;
                row_r2[1:0]<=2'b01; //?????
            end 
        end 
        
        2: 
        begin 
            if(col_i4[3:0]!=4'b1111) //????????
            begin 
                state<=5;
            end 
            else 
            begin 
                state<=0; 
            end 
        end 

        5: 
        begin 
            if(col_i4[3:0]!=4'b1111) 
            begin 
                col_reg <=col_i4;   //??????
                row_reg <=row_r2;   //??????
                state   <=5; 
                key_flag<=1'b1;     //????
            end 
            else 
            begin 
                state<=0;
            end 
        end
        endcase 
    end 
//-------------------------------------
    always @(clk_500khz or col_reg or row_reg) 
    begin 
        if(key_flag==1'b1) 
        begin 
            case ({col_reg,row_reg}) 
            6'b1110_10: key_r<=1; 
            6'b1110_01: key_r<=2; 
            6'b1101_10: key_r<=3; 
            6'b1101_01: key_r<=4; 
            6'b1011_10: key_r<=5; 
            6'b1011_01: key_r<=6; 
				6'b0111_10: key_r<=7; 
            6'b0111_01: key_r<=8; 
            endcase
        end
    end

//-------------------------------------
reg     clr_dy1;
reg     clr_dy2;
wire    clr_posedge;

    always @(posedge clk_500khz or posedge rst_i) 
    if(rst_i)
    begin
        clr_dy1 <= 1'b0;
        clr_dy2 <= 1'b0;
    end 
    else
    begin
        clr_dy1 <= clr_i;
        clr_dy2 <= clr_dy1;
    end
    
    assign clr_posedge = ~clr_dy1&clr_dy2;
//-------------------------------------
reg sta_r;

    always @(posedge clk_500khz or posedge rst_i) 
    if(rst_i)
    begin
        sta_r <= 1'b0;
    end 
    else 
    begin
        if(clr_posedge)
            sta_r <= 1'b0;
        else 
        begin 
            if(key_flag)
                sta_r <= 1'b1;
            else
                sta_r <= sta_r;
        end
    end
    
    assign int_o = sta_r;
    assign sta_o = sta_r;
//---------------------------------------------------
endmodule


