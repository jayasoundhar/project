module tb();
  
  reg clk1, clk2, rst;
  reg [7:0] data;
  
  wire baud_clk_R, baud_clk_T, tx, done_t, done_r, error;
  
  initial begin 
    clk1 = 1;
    clk2 = 1;
  end
  
  always #10 clk1 = ~clk1;
  always #5 clk2 = ~clk2;
  
  top_module dut(
    .clk1(clk1),
    .clk2(clk2),
    .rst(rst),
    .baud_clk_T(baud_clk_T),
    .baud_clk_R(baud_clk_R),
    .data(data),
    .tx(tx),
    .done_t(done_t),
    .done_r(done_r),
    .error(error)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
  initial begin
    #10 rst = 1;
    #20 rst = 0;
    #10 data = 8'b10010101;

    #100000;
    
    $finish;
  end
  
endmodule
