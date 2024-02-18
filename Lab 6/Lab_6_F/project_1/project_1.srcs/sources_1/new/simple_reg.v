module simple_reg(input [15:0] Ain,
                  input load_en,
                  input clk,
                  output reg [15:0] Aout);

    always@(posedge clk)
    begin
        if(load_en)
			Aout <= Ain;
    end
    
endmodule
