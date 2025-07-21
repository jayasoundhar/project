`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 10:26:45
// Design Name: 
// Module Name: spi_tb
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


module spi_tb;

  reg clk;
  reg rst;
  reg s0, s1;
  // Instantiate the DUT
  spi_master uut (
    .clk(clk),
    .rst(rst),
    .s0(s0),
    .s1(s1)
  );

  // Generate 100 MHz clock (10 ns period)
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    s0 = 1;
    s1 = 1;
    #20rst = 0;
    #40$display("Starting transaction with slave 0...");
    s0 = 0;
    #900;
    s0 = 1;
    #100;
    $display("Starting transaction with slave 1...");
    s1 = 0;
    #1000;
    s1 = 1;
    $finish;
  end
  initial begin
  $monitor("Time=%0t | s0=%b s1=%b | master_out=%b | master_in=%b", $time, s0, s1, uut.master_out, uut.master_in);
    $dumpfile("dump.vcd");
    $dumpvars;
end


endmodule

