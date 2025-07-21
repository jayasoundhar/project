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
