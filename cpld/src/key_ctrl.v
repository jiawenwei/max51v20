//key board,
//sound,
//
//module periph_ctrl
//(
//  
//
//);
//
//  input         clk_i     ;
//  input         rst_i     ;
//  input [2:0]   column_i3 ;
//  input [1:0]   row_i2    ;
//  input         sb_a      ;
//  input         sb_b      ;
//  input         sb_e      ;
//
//
//endmodule
module key_ctrl
( 
    clk_i       ,   //50MHZ 
    rst_i       ,   
    col_i3      ,   //��
    row_o2      ,   //��
    key_o           //��ֵ
);
    input           clk_i;
    input           rst_i;
    input   [2:0]   col_i3;
    output  [1:0]   row_o2;
    output  [2:0]   key_o; 
    
    reg [1:0]   row_r2; 
    reg [3:0]   key_r; 
    reg [5:0]   count;      //delay_20ms 
    
    reg [2:0]   state;      //״̬��־
    reg         key_flag;   //������־λ
    reg         clk_500khz; //500KHZʱ���ź�
    reg [2:0]   col_reg;    //�Ĵ�ɨ����ֵ
    reg [1:0]   row_reg;    //�Ĵ�ɨ����ֵ
    
    assign      row_o2  =row_r2;
    assign      key_o   =key_r;
    
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
            if(col_i3[2:0]!=3'b111) 
            begin
                state<=1;
                row_r2[1:0]<=2'b10;
            end //�м����£�ɨ���һ��
            else 
                state<=0; 
        end
        1:
        begin 
            if(col_i3[2:0]!=3'b111) //�ж��Ƿ��ǵ�һ��
            begin 
                state<=5;
            end 
            else 
            begin 
                state<=2;
                row_r2[1:0]<=2'b01; //ɨ��ڶ���
            end 
        end 
        
        2: 
        begin 
            if(col_i3[2:0]!=3'b111) //�ж��Ƿ��ǵڶ���
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
            if(col_i3[2:0]!=3'b111) 
            begin 
                col_reg <=col_i3;   //����ɨ����ֵ
                row_reg <=row_r2;   //����ɨ����ֵ
                state   <=5; 
                key_flag<=1'b1;     //�м�����
            end 
            else 
            begin 
                state<=0;
            end 
        end
        endcase 
    end 

    always @(clk_500khz or col_reg or row_reg) 
    begin 
        if(key_flag==1'b1) 
        begin 
            case ({col_reg,row_reg}) 
            5'b110_10: key_r<=0; 
            5'b110_01: key_r<=1; 
            5'b101_10: key_r<=2; 
            5'b101_01: key_r<=3; 
            5'b011_10: key_r<=4; 
            5'b011_01: key_r<=5; 
            endcase
        end
    end
endmodule



//module key 
//( 
//    clk         ,   //50MHZ 
//    reset       ,   
//    row         ,   //��
//    col         ,   //��
//    key_value       //��ֵ
//); 
//
//    input           clk;
//    input           reset;
//    input   [3:0]   row;
//    output  [3:0]   col;
//    output  [3:0]   key_value; 
//    
//    reg [3:0] col; 
//    reg [3:0] key_value; 
//    reg [5:0] count;    //delay_20ms 
//    
//    reg [2:0] state;    //״̬��־
//    reg key_flag;       //������־λ
//    reg clk_500khz;     //500KHZʱ���ź�
//    reg [3:0] col_reg;  //�Ĵ�ɨ����ֵ
//    reg [3:0] row_reg;  //�Ĵ�ɨ����ֵ
//    
//    always @(posedge clk or negedge reset) 
//    if(!reset) 
//        begin 
//            clk_500khz<=0; 
//            count<=0; 
//        end
//    else
//    begin
//        if(count>=50) 
//        begin 
//            clk_500khz<=~clk_500khz;
//            count<=0;
//        end 
//        else 
//            count<=count+1; 
//    end 
//
//    always @(posedge clk_500khz or negedge reset) 
//    if(!reset) 
//        begin 
//            col<=4'b0000;
//            state<=0;
//        end 
//    else 
//    begin 
//        case (state) 
//        0: 
//        begin 
//            col[3:0]<=4'b0000; 
//            key_flag<=1'b0; 
//            if(row[3:0]!=4'b1111) 
//            begin 
//                state<=1;
//                col[3:0]<=4'b1110;
//            end //�м����£�ɨ���һ��
//            else 
//                state<=0; 
//        end 
//        1: 
//        begin 
//            if(row[3:0]!=4'b1111) 
//            begin 
//                state<=5;
//            end //�ж��Ƿ��ǵ�һ��
//            else 
//            begin 
//                state<=2;
//                col[3:0]<=4'b1101;
//            end //ɨ��ڶ���
//        end 
//        
//        2: 
//        begin 
//            if(row[3:0]!=4'b1111) 
//            begin 
//                state<=5;
//            end //�ж��Ƿ��ǵڶ���
//            else 
//            begin 
//                state<=3;
//                col[3:0]<=4'b1011;
//            end //ɨ�������
//        end 
//        
//        3: 
//        begin 
//            if(row[3:0]!=4'b1111) 
//            begin 
//                state<=5;
//            end //�ж��Ƿ��ǵ���һ��
//            else 
//            begin 
//                state<=4;
//                col[3:0]<=4'b0111;
//            end //ɨ�������
//        end 
//        
//        4: 
//        begin 
//            if(row[3:0]!=4'b1111) 
//            begin 
//                state<=5;
//            end //�ж��Ƿ��ǵ�һ��
//            else 
//                state<=0; 
//        end 
//        
//        5: 
//        begin 
//            if(row[3:0]!=4'b1111) 
//            begin 
//                col_reg<=col; //����ɨ����ֵ
//                row_reg<=row; //����ɨ����ֵ
//                state<=5; 
//                key_flag<=1'b1; //�м�����
//            end 
//            else 
//            begin 
//                state<=0;
//            end 
//        end 
//        endcase 
//    end 
//
//    always @(clk_500khz or col_reg or row_reg) 
//    begin 
//        if(key_flag==1'b1) 
//        begin 
//            case ({col_reg,row_reg}) 
//            8'b1110_1110:key_value<=0; 
//            8'b1110_1101:key_value<=1; 
//            8'b1110_1011:key_value<=2; 
//            8'b1110_0111:key_value<=3; 
//            8'b1101_1110:key_value<=4; 
//            8'b1101_1101:key_value<=5; 
//            8'b1101_1011:key_value<=6; 
//            8'b1101_0111:key_value<=7; 
//            8'b1011_1110:key_value<=8; 
//            8'b1011_1101:key_value<=9; 
//            8'b1011_1011:key_value<=10; 
//            8'b1011_0111:key_value<=11; 
//            8'b0111_1110:key_value<=12; 
//            8'b0111_1101:key_value<=13; 
//            8'b0111_1011:key_value<=14; 
//            8'b0111_0111:key_value<=15; 
//            endcase 
//        end 
//    end
//endmodule

