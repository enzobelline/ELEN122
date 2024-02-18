module WB_staging(input WrX_in,
                  input [3:0] dst_in,
                  input [3:0] LD_EN,
                  input clk,
                  output reg WrX_out,
                  output reg [3:0] dst_out);

    always@(posedge clk)
    begin
        if(LD_EN)
			WrX_out <= WrX_in;
			dst_out <= dst_in;
    end
    
endmodule
