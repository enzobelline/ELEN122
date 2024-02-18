module Lab5_MEM(
	input clk,
	input [7:0] address,
	input [15:0] DataIn,
	input MemWr,
	output reg [15:0] DataOut
);


	//capping programs to 256 (16 bit) instructions
	//this will make synthesis/implementation faster
	reg [15:0] instructions [256:0]; 
	
	initial begin
		//$readmemb("instructions.mem", instructions); 
		$readmemh("instructions.mem", instructions); 
		
		//lab5
		instructions[48] = 16'h000B; //count address. count = 11
		instructions[49] = 16'h0001; 
		instructions[50] = 16'h0002; 
		instructions[51] = 16'h0003; 
		instructions[52] = 16'h0004; 
		instructions[53] = 16'h0005; 
		instructions[54] = 16'h0006; 
		instructions[55] = 16'h0007; 
		instructions[56] = 16'h0008; 
		instructions[57] = 16'h0009; 
		instructions[58] = 16'h000A; 
		instructions[59] = 16'h000B;
		//sum should be 66, or 0x42 
	end
	
	always@(posedge clk)
	begin
		if (MemWr) instructions[address] <= DataIn;
	end
	
	always@(*)
	begin
		DataOut <= instructions[address];
	end
	
	
endmodule