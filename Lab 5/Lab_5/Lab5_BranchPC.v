module Lab5_BranchPC(
	input clk,
	input [7:0] PC_addr,
	input [3:0] offset,
	output reg [7:0] adjustedPC
                    );
		
        
    always@(posedge clk)
    begin
		adjustedPC <= PC_addr + { {4{offset[3]}}, offset}; //need to sign extend the offset value
    end
	
endmodule