module doubleFlip (clk, reset, button, out);

input logic clk, reset;
input logic button;
output logic out;

logic out_ff1;

	always_ff @(posedge clk) begin
		out_ff1 <= button;
	end
	
	always_ff @(posedge clk) begin
		out <= out_ff1;
	end
endmodule
