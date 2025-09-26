module w_hand #(parameter width = 3)(
  input clk,
  input rst,w_en,
  input [width:0]gr_ptr_s,
  output reg [width:0]bw_ptr,gw_ptr,
  output reg full
);
  reg [width:0] bw_ptr_next, gw_ptr_next;
  reg wfull;

  // Next pointer
  always @* begin
    bw_ptr_next = bw_ptr + (w_en & !full);
    gw_ptr_next = (bw_ptr_next >> 1) ^ bw_ptr_next;
    wfull = (gw_ptr_next == {~gr_ptr_s[width:width-1], gr_ptr_s[width-2:0]});
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      gw_ptr <= 0;
      bw_ptr <= 0;
      full   <= 0;
    end else begin
      gw_ptr <= gw_ptr_next;
      bw_ptr <= bw_ptr_next;
      full   <= wfull;
    end
  end
endmodule
