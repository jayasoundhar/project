/////////////////////////////////TOP MODULE///////////////////////////////////////////////////////////////////////
module top_module(
  input clk1,clk2,rst,
  output reg baud_clk_T,baud_clk_R,
  input [7:0]data,
  output reg tx,done_t,
  output reg done_r,error
);
  baud_rate_T baudt(.clk1(clk1),.rst(rst),.baud_clk_T(baud_clk_T));
  baud_rate_R baudr(.clk2(clk2),.rst(rst),.baud_clk_R(baud_clk_R));
 
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

//////////////////////////TRANSMITTER/////////////////////////////////////////////
module transmitter(
  input clk1,baud_tclk,rst,
  input [7:0]data,
  output reg tx,done_t
);
  
  
  reg [1:0]ps,ns;
  reg [3:0]count;
  reg st = 1'b0;
  
  parameter idle = 2'b00, start = 2'b01, parity = 2'b10, stop = 2'b11;
  
  
  always@(posedge clk1) begin
    if(rst) begin
      ps <= idle;
      ns <= idle;
      tx <= 1'b1;
      count <= 4'd0;
      done_t <= 1'b0;
    end
    else begin
      ps <= ns;
    end
  end
  
  always@(posedge baud_tclk) begin
    case(ps)
      idle : begin 
        if(!st) begin 
          tx <= 1'b0;
          ns <= start;
          st <= 1'b1;
        end
        else ns <= idle;
      end
      start : begin
        if (count <= 7) begin
          tx <= data[count];
          count = count + 1'b1;
        end 
        else begin
          count <= 0;
          ns <= parity;
        end
      end
      parity : begin
        tx <= ^data;
        ns <= stop;
      end
      stop : begin
        tx <= 1'b1;
        done_t <= 1'b1;
        ns <= idle;
      end
    endcase
  end
  
endmodule

/////////////////////RECEIVER/////////////////////////////////////
module receiver(
  input clk2,rst,baud_rclk,rx,
  output reg done_r,error
);
  
  
  reg [1:0]ps,ns;
  reg [3:0]count;
  reg [7:0]data;
  
  parameter idle = 2'b00, start = 2'b01, parity = 2'b10;
  
  
  always@(posedge clk2) begin
    if(rst) begin
      ps <= idle;
      ns <= idle;
      count <= 4'd0;
      done_r <= 1'b0;
      data <= 8'd0;
    end
    else begin
      ps <= ns;
    end
  end
  
  always@(posedge baud_rclk) begin
    case(ps)
      idle : begin 
        if(!rx) begin
          ns <= start;
        end
        else ns <= idle;
      end
      start : begin
        if(count <= 8) begin
          data[count] <= rx;
          count <= count + 1'b1;
        end
        else begin
          ns <= parity;
        end
      end
      parity : begin
        if(((^data)^ rx) == 1'b0) begin 
          done_r <= 1'b1;
          error <= 0;
          ns <= idle;
        end
        else begin
          error <= 1'b1;
          ns <= idle;
        end
      end
      default ns <= idle;
    endcase
  end
endmodule
