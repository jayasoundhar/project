`include "apb_master.sv"
`include "apb_slave.sv"
module APB_topmodule(
  input clk,
  input rst,
  input transfer,
  input pwrite,
  input [7:0] r_addr,
  input [7:0] w_addr,
  input [7:0] w_data,

  output [7:0]prdata,
  output ready);


  wire p_sel;
  wire penable;
  wire [7:0] prw_addr;
  wire pready;
  wire write_data;
//   wire pr_data;

APB_master master(.clk(clk),
                  .rst(rst),
                  .transfer(transfer),
                  .pwrite(pwrite),
                  .r_addr(r_addr),
                  .w_addr(w_addr),
                  .w_data(w_data),
                  .pready(pready),
                  .p_sel(p_sel),
                  .penable(penable),
                  .prw_addr(prw_addr),
                  .write_data(write_data)
//                   .prdata(pr_data)  
               );

APB_slave slave(.clk(clk),
                .rst(rst),
                .sel(p_sel),
                .enable(penable),
                .pwrite(pwrite),
                .rw_addr(prw_addr),
                .w_data(write_data),
                .ready(pready),
                .prdata(prdata)
              );

assign ready = pready;

endmodule
