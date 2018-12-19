module userInput(out, clk, reset, button);
	output logic out;
	input logic clk, reset, button;
	
	enum {on, off} ps, ns;
	
	always_comb begin
		case(ps)
			on: 	if(button) ns = on;
						//out = 0;
					else ns = off;
						//out = 1;
				
			off: 	if(button) ns = on;
						//out = 0;
						
					else ns = off;
						//out = 0;
			
		endcase
	end
	
	assign out = (ps == on & ns == off);
	//assign pressed = (ns == on);
	
	always_ff @(posedge clk) begin
		if(reset) 
			ps <= off;
		else
			ps <= ns;
	end
endmodule

module userInput_testbench();
	logic clk, reset;
	logic button;
	logic out;
	
	userInput dut (.out, .clk, .reset, .button);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;						@(posedge clk);
											@(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0; 					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0; 					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
		$stop;
	end
endmodule 
