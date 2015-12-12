

//------------------------------------------
`timescale  1ns / 100ps
module tb;
    
    reg reset       ;
    reg reset_dy1   ;
    reg clk_50      ;//40MHz
    
    reg     clk_18      ;//18.432MHz
    
    reg     wr_n;
    reg     rd_n;
    reg     ale;
    reg     psen_n;
    
    reg[7:0]   port0;
    reg[7:0]   port2;
    wire[7:0]   leds;
    
    reg[7:0]   i;
    
    wire[7:0]  wport0;
    wire[7:0]  wport2;
    
    assign wport0=port0;
    assign wport2=port2;
    //--------------------------------------------
    initial
    begin
        clk_50  =0;
        clk_18  =0;
        reset   =1;
        #200
        reset   =0;
    end
    //--------------------------------------------
    initial
    begin
        #18000000
        $stop;
    end
    //--------------------------------------------
    always #10.0 clk_50 = ~clk_50;
    always #27.1 clk_18 = ~clk_18;

    //--------------------------------------------
    always@(posedge clk_50)
    if(reset)
        reset_dy1 <= reset;
    else
        reset_dy1 <= 0;
    //--------------------------------------------
    always@(negedge clk_18)
    if(reset)
        i<=0;
    else
        if(i==24)
            i<=0;
        else
            i <= i+1;
    //--------------------------------------------ale
    always@(negedge clk_18)
    if(reset)
        ale<=0;
    else
        if(i==0)
            ale<=1;
        else if(i==3)
            ale<=0;
        else if(i==7)
            ale<=1;
        else if(i==9)
            ale<=0;
        else if(i==19)
            ale<=1;
        else if(i==21)
            ale<=0;
    //--------------------------------------------psen_n
    always@(negedge clk_18)
    if(reset)
        psen_n<=0;
    else
        if(i==0)
            psen_n<=1;
        else if(i==3)
            psen_n<=0;
        else if(i==7)
            psen_n<=1;
        else if(i==22)
            psen_n<=0;
        else if(i==25)
            psen_n<=1;
    //--------------------------------------------wr_n,rd_n
    always@(negedge clk_18)
    if(reset)
    begin
        wr_n<=1;
        rd_n<=1;
    end
    else
        if(i==12)
            wr_n<=0;
        else if(i==18)
            wr_n<=1;
    //--------------------------------------------port2
    always@(negedge clk_18)
    if(reset)
        port2<=8'h00;
    else
        if(i==1)
            port2<=8'hff;
        else if(i==7)
            port2<=8'h55;
        else if(i==19)
            port2<=8'hff;
            
    //--------------------------------------------port0
    always@(negedge clk_18)
    if(reset)
        port0<=8'h77;
    else
        if(i==0)
            port0<=8'hff;
        else if(i==1)
            port0<=8'hff;
        else if(i==5)
            port0<=8'hff;
        else if(i==7)
            port0<=8'h55;
        else if(i==13)
            port0<=8'h01;
        else if(i==17)
            port0<=8'hzz;
        else if(i==19)
            port0<=8'h77;
            
    //--------------------------------------------

max51 max51_u1
(
    .rst         (reset_dy1),
    .clk         (clk_50),
    .mcu_wr_n    (wr_n),
    .mcu_rd_n    (rd_n),
    .mcu_ale     (ale),
    .mcu_psen_n  (psen_n),
    .mcu_p0      (wport0),
    .mcu_p2      (wport2),
    .leds_o      (leds)
);

//--------------------------------------------
endmodule



