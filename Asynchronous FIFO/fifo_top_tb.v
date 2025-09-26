module async_fifo_TB;

    parameter DATA_WIDTH = 8;

    reg [DATA_WIDTH-1:0] din = 0;
    wire [DATA_WIDTH-1:0] dout;
    reg w_en = 0, r_en = 0;
    reg wclk = 0, rclk = 0;
    reg wrst = 0, rrst = 0;
    wire full, empty;

    asynch #(
        .data_width(DATA_WIDTH)
    ) fifo_inst (
        .wclk(wclk),
        .wrst(wrst),
        .rclk(rclk),
        .rrst(rrst),
        .w_en(w_en),
        .r_en(r_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    always #5 wclk = ~wclk;
    always #7 rclk = ~rclk;

    initial begin
	    $dumpfile("dump.vcd");
	    $dumpvars;
    end
    initial begin
	    wrst = 0;
	    rrst = 0;
	    #10;
	    wrst = 1;
	    rrst = 1;
    end
    initial begin

	    repeat(20) begin
		    if(!full) begin
			    din = $random;
			    w_en = 1;
		    end
		    #10;
		    w_en = 0;
		    #10;
	    end
	    #50;
	    repeat(20) begin
		    if(!empty) begin
			    r_en = 1;
		    end
		    #14;
		    r_en = 0;
		    #14;
	    end
	    #50;
	    repeat(20) begin
		    if(!full) begin
			    din = $random;
			    w_en = 1;
		    end
		    #10;
		    w_en = 0;
		    #10;
	    end

	    #50;
        $finish;
    end

endmodule
