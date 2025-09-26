module meme #(parameter depth = 8, data_width = 8, width = 3)(
  input wclk, w_en, rclk, r_en,
  input [width:0] bw_ptr, br_ptr,
  input [data_width-1:0] din,
  input full, empty,
  output reg [data_width-1:0] dout
);
  
  reg [data_width-1:0] mem [0:depth-1];

  // Write
  always @(posedge wclk) begin
    if (w_en & !full)
      mem[bw_ptr[width-1:0]] <= din;
  end

  // Read
  always @(posedge rclk) begin
    if (r_en & !empty)
      dout <= mem[br_ptr[width-1:0]];
  end
endmodule
