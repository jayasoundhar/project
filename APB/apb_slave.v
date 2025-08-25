module APB_slave(
  input clk,
  input rst,
  input sel,
  input enable,
  input pwrite,
  input [7:0]rw_addr,
  input [7:0]w_data,
  
  output reg ready,
  output reg [7:0]prdata
);
  
  reg [7:0]mem[255:0];
  
  always@(posedge clk)begin
    if(rst)begin
      prdata = 8'h0 ;
      ready = 0 ;
    end
    else if (sel && enable)begin
      ready = 1;
      if(pwrite)
        mem[rw_addr] = w_data ;
	  else
        prdata = mem[rw_addr] ;
	end
    else ready = 0;
  end
endmodule
