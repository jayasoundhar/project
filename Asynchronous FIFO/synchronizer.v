module sync #(parameter width = 3)(
  input clk,
  input rst,
  input [width: 0] din,
  output reg [width: 0] dout
);
  
  reg [width: 0] q1;
  
  always@(posedge clk) begin
    if(!rst) dout <= 0;
    else begin
      q1 <= din;
      dout <= q1;
    end
  end
  
endmodule
