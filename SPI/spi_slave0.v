`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 10:24:28
// Design Name: 
// Module Name: spi_slave0
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module spi_slave0(
  input clk,
  input rst,
  input slave_in,
  input selected,
  output reg slave_out
);
  parameter idle = 1'b0, transmit = 1'b1;
  reg ps, ns, busy;
  reg [7:0] storage;
  reg [3:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      ps <= idle;
      ns <= idle;
      busy <= 1'b0;
      slave_out <= 1'd0;
      count <= 4'd0;
      storage <= 8'b10101010;
    end 
    else ps <= ns;
  end
  always@(posedge clk) begin
      case (ps)
        idle : begin
          if (!selected) begin
            ns <= transmit;
            busy <= 1'b1;
            count <= 4'd9;
          end 
          else begin
            ns <= idle;
            busy <= 1'b0;
          end
        end
        transmit : begin
          if (count > 0) begin
            slave_out <= storage[7];
            storage <= {storage[6:0], slave_in};
            count <= count - 1;
            ns <= transmit;
          end 
          else begin
            ns <= idle;
            busy <= 1'b0;
          end
        end
      endcase
    end
endmodule