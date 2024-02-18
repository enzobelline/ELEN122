module lab6_DMEM(input clk,
                 input [15:0] Address, //only lsbyte is used
                 input [15:0] DataIn,
                 input MemWr,
                 input MemRd,
                 output reg DataValid,
			     output reg [15:0] DataOut);

	reg [15:0] Data [256:0]; 
	
	initial begin
		Data[48] = 16'h000B; //count address. count = 11
		Data[49] = 16'h0001; 
		Data[50] = 16'h0002; 
		Data[51] = 16'h0003; 
		Data[52] = 16'h0004; 
		Data[53] = 16'h0005; 
		Data[54] = 16'h0006; 
		Data[55] = 16'h0007; 
		Data[56] = 16'h0008; 
		Data[57] = 16'h0009; 
		Data[58] = 16'h000A; 
		Data[59] = 16'h000B;
		//sum should be 66, or 0x42 
		DataOut <= 0;
	end
	
	always@(posedge clk)
	begin
		if (MemWr) Data[Address] <= DataIn;
	end
	
	always@(*)
	begin
		if(MemRd)
		begin
			DataOut <= Data[Address];
			DataValid <= 1;
		end
		else
			DataValid <= 0;
	end
	
	
endmodule