module Lab4_MEM(
	input clk,
	input [7:0] address,
	input [15:0] DataIn,
	input MemWr,
	output reg [15:0] DataOut
);
			  
	reg [15:0] instructions [256:0]; 
	
	initial begin
		//$readmemb("instructions.mem", instructions); 
		$readmemh("instructions.mem", instructions); 
		
		//lab 4 loads constants into locations of 48,49,50
		instructions[48] = 16'h1234; //decimal 4660
		instructions[49] = 16'h789A; //decimal 30874
		instructions[50] = 16'd128;  //4660+30874=35534 (hex 8ACE) into address 128 
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