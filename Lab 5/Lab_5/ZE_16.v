module ZE_16(
	input [7:0] pc,
	output [15:0] extended
);
                         
    assign extended = { {8{1'b0}}, pc};
    
endmodule