module SimpleReg8(input [7:0] Ain,
                  input load_en,
                  input clk,
                  output reg [7:0] Aout);

    always@(posedge clk)
    begin
        if(load_en)
			Aout <= Ain;
    end
    
endmodule
