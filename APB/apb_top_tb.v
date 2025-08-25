module APB_topmodule_tb;
  reg clk;
  reg rst;
  reg transfer;
  reg pwrite;
  reg [7:0] r_addr;
  reg [7:0] w_addr;
  reg [7:0] w_data;
	
  wire [7:0]prdata;
  wire ready;

  APB_topmodule uut(.clk(clk),.rst(rst),.transfer(transfer),.pwrite(pwrite),.r_addr(r_addr),.w_addr(w_addr),.w_data(w_data),.prdata(prdata),.ready(ready));
	

  initial begin
	clk=0;
	forever #2 clk=~clk;
  end

  initial begin
    #1;
    rst = 1;
    transfer = 1; 
    pwrite = 0;
    r_addr = 0;
    w_addr = 0;
    w_data = 0;

    #4;
    rst = 0;
    pwrite = 1; 
    w_addr = 8'h10; 
    r_addr = 8'h10; 
    w_data = 8'hA5;
    #10
    transfer = 0;
    #17;
    transfer = 1;
    pwrite = 0;
    w_addr = 8'h10;
    #5;
    transfer = 0;
    #50 $finish;
  end 

  initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
    $monitor(clk,,rst,,r_addr,,w_addr,,w_data,,prdata);
  end
endmodule
