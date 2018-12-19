module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	 input logic 			CLOCK_50; // 50MHz clock.
	 output logic 	[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic 	[9:0] LEDR;
	 input logic 	[3:0] KEY; // True when not pressed, False when pressed
	 input logic 	[9:0] SW;

	 
	 //logic reset;
	 logic key0, key3;
	 logic key0_Stable, key3_Stable;
	 
	 //Assign HEX 5 - 1 to default display
	 
	 assign HEX5 = 7'b1111111;
	 assign HEX4 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
	 assign HEX2 = 7'b1111111;
	 assign HEX1 = 7'b1111111;
	 
	 doubleFlip ff1 (.clk(CLOCK_50), .reset(SW[9]), .button(~KEY[0]), .out(key0_Stable));
	 doubleFlip ff2 (.clk(CLOCK_50), .reset(SW[9]), .button(~KEY[3]), .out(key3_Stable));
	 
	 userInput switchZero (.clk(CLOCK_50), .reset(SW[9]), .button(key0_Stable), .out(key0));
	 userInput switchThree (.clk(CLOCK_50), .reset(SW[9]), .button(key3_Stable), .out(key3));
	
	 //Light instantiations
	 
	 normalLight one (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	 normalLight two (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	 normalLight three (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	 normalLight four (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	 
	 centerLight five (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	 
	 normalLight six (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	 normalLight seven (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	 normalLight eight (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	 normalLight nine (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	 
	 //Who wins?
	 
	 victory gameEnds (.clk(CLOCK_50), .reset(SW[9]), .LED9(LEDR[9]), .LED1(LEDR[1]), .L(key3), .R(key0), .winner(HEX0));
	 
	 
endmodule

 //divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	 input logic 			clock; //reset?
	 output logic [31:0] divided_clocks = 0; 

	 always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	 end

endmodule 

module DE1_SoC_testbench();
	logic 		CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		SW[9] <= 1;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		SW[9] <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		$stop;
	end
endmodule
