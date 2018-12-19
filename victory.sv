module victory (winner, clk, reset, LED9, LED1, L, R);
	input logic clk, reset;
	input logic LED9, LED1, L, R;
	output logic [6:0] winner;
	
	enum {off, P1, P2} ps, ns;
	
	always_comb begin
		case(ps)
			off:   if(LED9 & L & ~R) ns = P1;
							
					 else if(LED1 & R & ~L) ns = P2;
					
					 else ns = off;
							
			P1: ns = P1;
			
			P2: ns = P2;
			
		endcase
	
		if(ns == P1) winner = 7'b1111001;
		else if (ns == P2) winner = 7'b0100100; 
		else winner = 7'b1111111;

	end
	
	always_ff @(posedge clk) begin
		if(reset)
			ps <= off;
		else
			ps <= ns;
	end
	
endmodule

module victory_testbench();
	logic clk, reset;
	logic LED9, LED1, L, R;
	logic [6:0] winner;
	
	victory dut (.winner, .clk, .reset, .LED9, .LED1, .L, .R);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;										@(posedge clk);
															@(posedge clk);
		reset <= 0;										@(posedge clk);
															@(posedge clk);
		LED9 <= 1; LED1 <= 0; L <= 1; R <= 0;	@(posedge clk);
															@(posedge clk);
		LED9 <= 0; LED1 <= 1;						@(posedge clk);
															@(posedge clk);
		LED9 <= 1; LED1 <= 1;						@(posedge clk);
															@(posedge clk);
					  LED1 <= 0;			R <= 1;  @(posedge clk);
															@(posedge clk);
		reset <= 1;										@(posedge clk);
															@(posedge clk);
		reset <= 0;										@(posedge clk);
															@(posedge clk);
		LED9 <= 0; LED1 <= 1; L <= 0; R <= 1;	@(posedge clk);
															@(posedge clk);
		LED9 <= 1;				 						@(posedge clk);
															@(posedge clk);
		LED9 <= 0; 				 L <= 1;				@(posedge clk);
															@(posedge clk);
		$stop;
	end
endmodule
