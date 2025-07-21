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
