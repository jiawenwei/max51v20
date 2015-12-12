module rm_jitter
(
  	clk_i   ,
  	rst_i   ,
  	signal_i,
  	signal_o
);

  input   clk_i   ;
  input   rst_i   ;
  input   signal_i;
  output  signal_o;

//--------------------------------------
  reg [7:0] clk_cnt;
  
  always @(posedge clk_i)
  if(rst_i)
  begin
    clk_cnt <= 0;
  end
  else if(signal_c|signal_b)
  begin
    clk_cnt <= clk_cnt+1;
    signal_d = 1'b1;
  end
  else if (clk_cnt[7] == 1'b1)
  begin
    signal_d = 1'b0;
  end
  else
  begin
    clk_cnt <= 0;
  end
  
  assign cnt_sig = clk_cnt[7]

//--------------------------------------
  always @(posedge signal_d or posedge rst_i)
  if(rst_i)
    signal_o <= 1'b0;
  else 
    signal_o <= ~signal_o;
  
//--------------------------------------
  always @(posedge clk_i)
  if(cnt_sig)
  begin
    signal_b <= 1'b0;
    signal_c <= 1'b0;
  end
  else if (signal_i)
  begin
    signal_b <= 1'b1;
    signal_c <= signal_c;
  end
  else 
  begin
  	signal_c <= 1'b1;
  	signal_b <= signal_b;
  end
  
//--------------------------------------
endmodule
