module L4_ALU(
	input [15:0] in_A,
	input [15:0] in_B,
	input add_sub,
	output reg [15:0] adder_out
);

	always@(*)
	begin
	
		if(add_sub == 0) //0 means add_sub
		begin
			adder_out <= in_A + in_B;
		end
		
		else
		begin
			adder_out <= in_A - in_B;
		end
		
	end
	
endmodule