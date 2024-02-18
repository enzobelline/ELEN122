module Lab6_IMEM(input clk,
                 input [7:0] address,
			     output reg [15:0] DataOut);
			  

	reg [15:0] instructions [256:0]; 
	
	initial begin
		$readmemh("TensorFlow.mem", instructions); 
		//$readmemh("debug_instr.mem", instructions);
	end
	
	always@(*)
	begin
		DataOut <= instructions[address];
	end
	
	
endmodule