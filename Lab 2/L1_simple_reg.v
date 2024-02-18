module L1_simple_reg(input [3:0] reg_in,
					 input load_en,
					 input clk,
					 output reg [3:0] reg_out);


    always@(posedge clk)
    begin
        if(load_en)
			reg_out <= reg_in;
    end
	
endmodule