module centerLight (lightOn, clk, reset, L, R, NL, NR);
	output logic lightOn;
	input logic clk, reset;
	input logic L, R, NL, NR;
	
	enum {on, off} ps, ns;
	
	always_comb begin 
		case(ps)
			on:    if(~R & L | R & ~L) ns = off;
					 else ns = on; 
				 
			off: 	 if(NR & L & ~R | NL & R & ~L) ns = on;
					 else ns = off; 
			
		endcase
		//lightOn = (ps == on);
	end
	always_comb begin
		case(ps)
			on: lightOn = 1;
			
			off: lightOn = 0;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) 
			ps <= on;
		else
			ps <= ns;
	end
	
endmodule

module centerLight_testbench();
	logic L, R, NL, NR;
	logic lightOn;
	logic clk, reset; 
	
	centerLight dut (.lightOn, .clk, .reset, .L, .R, .NL, .NR);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	//Set up the inputs to the design. Each line is a clock cycle
	initial begin
														@(posedge clk)
		reset <= 1;									@(posedge clk)
														@(posedge clk)
		reset <= 0;									@(posedge clk)
														@(posedge clk)
		L <= 1; R <= 0; NL <= 0; NR <= 1;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
							 NL <= 1; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; 							@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
							 NL <= 0; NR <= 1; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 1; 			 NL <= 1; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		reset <= 1;									@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; NL <= 1; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 1; R <= 0; NL <= 0; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; NL <= 0; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		$stop; 
	end 
endmodule 
