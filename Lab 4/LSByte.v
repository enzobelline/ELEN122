module LSByte(
	input [15:0] from_RF,
	output [7:0] mux_addr
);
              
    assign mux_addr = from_RF[7:0];
    
endmodule