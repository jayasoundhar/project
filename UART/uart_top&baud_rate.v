module top_module(
  input clk1,clk2,rst,
  output reg baud_clk_T,baud_clk_R,
  input [7:0]data,
  output reg tx,done_t,
  output reg done_r,error
);
  baud_rate_T baudt(.clk1(clk1),.rst(rst),.baud_clk_T(baud_clk_T));
  baud_rate_R baudr(.clk2(clk2),.rst(rst),.baud_clk_R(baud_clk_R));
  
//   wire baud_tclk;
//   assign baud_tclk = baud_clk;
//   assign baud_rclk = baud_clk;
  
  transmitter trans(.clk1(clk1),.rst(rst),.data(data),.baud_tclk(baud_clk_T),.tx(tx),.done_t(done_t));
  
  wire rx;
  assign rx = tx;
  receiver res(.clk2(clk2),.rst(rst),.baud_rclk(baud_clk_R),.rx(rx),.done_r(done_r),.error(error));
endmodule

module baud_rate_T(
  input clk1,rst,
  output reg baud_clk_T
);
  parameter integer baud_rate = 921600;
  parameter integer fqr = 50000000;
  integer count;
  parameter integer clk_div = fqr / baud_rate;
  
  always@(posedge clk1 ) begin
    if(rst) begin
      count <= 0;
      baud_clk_T <= 0;
    end
    else begin
      if(count == clk_div) begin
      count <= 0;
      baud_clk_T <= 1;
    end
    else begin
      count =count + 1;
      baud_clk_T <= 0;
    end
    end
  end
endmodule

module baud_rate_R(
  input clk2,rst,
  output reg baud_clk_R
);
  parameter integer baud_rate = 921600;
  parameter integer fqr = 40000000;
  integer count;
  parameter integer clk_div = fqr / baud_rate;
  
  always@(posedge clk2 ) begin
    if(rst) begin
      count <= 0;
      baud_clk_R <= 0;
    end
    else begin
      if(count == clk_div) begin
      count <= 0;
      baud_clk_R <= 1;
    end
    else begin
      count =count + 1;
      baud_clk_R <= 0;
    end
    end
  end
endmodule
