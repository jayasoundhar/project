module r_hand #(parameter width = 3)(
  input clk,
  input rst,r_en,
  input [width:0]gw_ptr_s,
  output reg [width:0]br_ptr,gr_ptr,
  output reg empty
);
  reg [width:0] br_ptr_next, gr_ptr_next;
  reg rempty;

  // Next pointer
  always @* begin
    br_ptr_next = br_ptr + (r_en & !empty);
    gr_ptr_next = (br_ptr_next >> 1) ^ br_ptr_next;
    rempty = (gr_ptr_next == gw_ptr_s);
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      gr_ptr <= 0;
      br_ptr <= 0;
      empty  <= 1;
    end else begin
      gr_ptr <= gr_ptr_next;
      br_ptr <= br_ptr_next;
      empty  <= rempty;
    end
  end
endmodule
