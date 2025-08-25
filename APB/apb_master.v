module APB_master(
  input clk,
  input rst,
  input pwrite,
  input transfer,
  input [7:0] r_addr,
  input [7:0] w_addr,
  input [7:0] w_data,
  input pready,
  
  output reg penable,
  output p_sel,
  output write_data,
//   output prdata,
  output reg [7:0] prw_addr
);

  parameter IDLE   = 2'b00,SETUP  = 2'b01,ACCESS = 2'b10;
  reg [1:0]ps,ns;

  always@(posedge clk)begin
    if(rst)
      ps <= IDLE;
    else
      ps <= ns;
  end


  always @(*) begin    
    case(ps)     
      IDLE:begin
        penable <= 0;
        if(transfer) ns = SETUP;
        else ns = IDLE;
      end  
      SETUP: begin
		penable <= 1'b0;
        ns = ACCESS;    	
      end
      ACCESS: begin
		penable <= 1'b1;        
        if(pready && transfer) begin	
          ns = SETUP;
        end
        else if(pready && !transfer)
		  ns = IDLE;
        else if(!pready) begin
          ns = ACCESS;
        end
	    else
		  ns = IDLE;    
      end
      default:ns = IDLE;
    endcase
  end
  assign p_sel = (ps!= IDLE) ? 1 : 0;
  assign write_data = ((ps == ACCESS) && pwrite) ? w_data:0;
  assign prw_addr = pwrite ? w_addr : r_addr;
//   assign prdata = ((ps == ACCESS) && (pready)) ? ;

endmodule
