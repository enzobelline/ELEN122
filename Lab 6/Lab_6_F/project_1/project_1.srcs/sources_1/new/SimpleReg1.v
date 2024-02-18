module SimpleReg1(input Ain,
                  input load_en,
                  input clk,
                  output reg[0:0] Aout);

    always@(posedge clk)
    begin
        if(load_en)
			Aout <= Ain;
    end
    
endmodule
