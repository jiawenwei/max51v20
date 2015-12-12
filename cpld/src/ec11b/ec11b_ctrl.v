
`timescale 1ns/10ps
module ec11b_ctrl
(
    clk_i   ,//50MHZ 
    rst_i   ,
    a_i     ,
    b_i     ,
    d_i     ,
    
    clr_i   ,
    lva_o8  ,
    rva_o8  ,
    debug_o8,

);
//---------------------------------------------------
    input           clk_i ;
    input           rst_i ;

    input           a_i   ;
    input           b_i   ;
    input           d_i   ;
    
    input           clr_i ;
    output [7:0]    lva_o8;
    output [7:0]    rva_o8;
    
    output [7:0]    debug_o8;
    
    reg    [7:0]    lva_r8;
    reg    [7:0]    rva_r8;
    reg    [15:0]    count;
    reg             clk_500khz;

    assign lva_o8=lva_r8;
    assign rva_o8=rva_r8;
//---------------------------------------------------
    always @(posedge clk_i or posedge rst_i) 
    if(rst_i) 
    begin 
        clk_500khz<=0;
        count<=0;
    end
    else
    begin
        if(count>=25000)
        begin
            clk_500khz<=~clk_500khz;
            count<=0;
        end
        else
        begin
            count<=count+1;
        end
    end
//---------------------------------------------------
    reg axi_dy1;
    reg axi_dy2;
    reg bxi_dy1;
    reg bxi_dy2;
    reg clr_dy1;
    reg clr_dy2;
        
    always @(posedge clk_500khz or posedge rst_i) 
    if(rst_i)
    begin
        axi_dy1<= 1'b1;
        axi_dy2<= 1'b1;
        bxi_dy1<= 1'b1;
        bxi_dy2<= 1'b1;
        clr_dy1<= 1'b0;
        clr_dy2<= 1'b0;
    end
    else
    begin
        axi_dy1<= a_i;
        axi_dy2<= axi_dy1;
        bxi_dy1<= b_i;
        bxi_dy2<= bxi_dy1;
        clr_dy1<= clr_i;
        clr_dy2<= clr_dy1;
    end
    
    assign axi_posedge = ~axi_dy1&axi_dy2&~bxi_dy2;
    assign axi_negedge = axi_dy1&~axi_dy2&~bxi_dy2;
    assign clr_posedge = ~clr_dy1&clr_dy2;
    
//---------------------------------------------------
    always @(posedge clk_500khz or posedge rst_i) 
    if(rst_i)
    begin
        rva_r8 <= 8'd0;
        lva_r8 <= 8'd0;
    end
    else
    begin
        if(clr_posedge)
        begin
            rva_r8 <= 8'd0;
            lva_r8 <= 8'd0;
        end
        else
        begin
            case({axi_posedge,axi_negedge})
            2'b01:
                begin
                    lva_r8 <= lva_r8+8'd1;
                end
            2'b10:
                begin
                    rva_r8 <= rva_r8+8'd1;
                end
            default: ;
            
            endcase
        end
        
    end

assign debug_o8 = {3'b0,clr_posedge,clk_500khz,bxi_dy2,axi_posedge,axi_negedge};

//---------------------------------------------------
endmodule
