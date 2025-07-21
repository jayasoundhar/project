`timescale 1ns / 1ps
module spi_master(
  input clk,
  input rst,
  input s0, s1 // slave selects (s0 used for slave0, s1 for slave1)
);
//////////////////////////// slave clk generation ///////////////////////////
  reg slave_clk;
  reg [1:0] clk_div;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      clk_div <= 2'b00;
      slave_clk <= 1'b0;
    end else begin
      clk_div <= clk_div + 1;
      if (clk_div == 2'b10)
        slave_clk <= ~slave_clk;
    end
  end
/////////////////////////////////////////////////////////////////////////////

  reg master_out0, master_out1;
  wire master_in0, master_in1;
  reg master_in, master_out;
  reg ps, ns, busy;
  parameter idle = 1'b0, transmit = 1'b1;
  reg [7:0] storage;
  reg [3:0] count;

  always @(posedge slave_clk or posedge rst) begin
    if (rst) begin
      ps <= idle;
      ns <= idle;
      busy <= 1'b0;
      count <= 4'd0;
      storage <= 8'b01010101;
      master_out <= 1'b0;
    end
    else ps <= ns;
  end
  always@(posedge slave_clk) begin
      case (ps)
        idle : begin
          if (!s0 || !s1) begin
            ns <= transmit;
            busy <= 1'b1;
            count <= 4'd7;
          end 
          else begin
            ns <= idle;
            busy <= 1'b0;
          end
        end
        transmit : begin
          master_out <= storage[7];
          storage <= {storage[6:0], master_in};
          if (count == 0) begin
            ns <= idle;
            busy <= 1'b0;
          end 
          else begin
            count <= count - 1;
            ns <= transmit;
          end
        end
      endcase
  end

  ///////////////////////////// slave instance //////////////////////////////
  spi_slave0 slave0(
    .clk(slave_clk),
    .rst(rst),
    .slave_in(master_out0),
    .selected(s0),
    .slave_out(master_in0)
  );

   spi_slave1 slave1(
     .clk(slave_clk),
     .rst(rst),
     .slave_in(master_out1),
     .selected(s1),
     .slave_out(master_in1)
   );

  always @(*) begin
    if (!s0) begin
      master_in = master_in0;
    end else if (!s1) begin
      master_in = master_in1;
    end else begin
      master_in = 1'b0;
    end

    master_out0 = (!s0) ? master_out : 1'bz;
    master_out1 = (!s1) ? master_out : 1'bz;
  end
/////////////////////////////////////////////////////////////////////////////

endmodule