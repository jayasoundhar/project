module asynch #(parameter depth = 8, data_width = 8)(
  input wclk,
 input wrst,
  input rclk,
 input rrst,
  input w_en,
 input r_en,
  input [data_width-1:0] din,
  output [data_width-1:0] dout,
  output full, empty
);
  
  parameter ptr_width = $clog2(depth);
  
  wire [ptr_width:0] gw_ptr_s, gr_ptr_s;
  wire [ptr_width:0] bw_ptr, br_ptr;
  wire [ptr_width:0] gw_ptr, gr_ptr;

  wire [ptr_width-1:0] waddr, raddr;

  sync #(ptr_width) wptr_sync ( .clk(rclk), .rst(rrst), .din(gw_ptr), .dout(gw_ptr_s) ); // write->read
  sync #(ptr_width) rptr_sync ( .clk(wclk), .rst(wrst), .din(gr_ptr), .dout(gr_ptr_s) ); // read->write

  w_hand #(ptr_width) wptr_h ( .clk(wclk), .rst(wrst), .w_en(w_en), .gr_ptr_s(gr_ptr_s),
                               .bw_ptr(bw_ptr), .gw_ptr(gw_ptr), .full(full) );

  r_hand #(ptr_width) rptr_h ( .clk(rclk), .rst(rrst), .r_en(r_en), .gw_ptr_s(gw_ptr_s),
                               .br_ptr(br_ptr), .gr_ptr(gr_ptr), .empty(empty) );

 meme #(depth, data_width, ptr_width) fifom ( .wclk(wclk), .w_en(w_en), .rclk(rclk), .r_en(r_en),
                                               .bw_ptr(bw_ptr), .br_ptr(br_ptr),
                                               .din(din), .full(full), .empty(empty), .dout(dout) );
endmodule
