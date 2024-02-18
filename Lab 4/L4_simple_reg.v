module L4_simple_reg(
	input [15:0] reg_in,
	input load_en,
	input clk,
	output reg [15:0] reg_out
);


    always@(posedge clk)
    begin
        if(load_en)
			reg_out <= reg_in;
    end
    
endmodule