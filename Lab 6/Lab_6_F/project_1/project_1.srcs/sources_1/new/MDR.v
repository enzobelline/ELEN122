module MDR(input [15:0] MD_in,
           input load_en,
           input clk,
           output reg [15:0] MD_out);

    always@(posedge clk)
    begin
        if(load_en)
			MD_out <= MD_in;
    end


endmodule
