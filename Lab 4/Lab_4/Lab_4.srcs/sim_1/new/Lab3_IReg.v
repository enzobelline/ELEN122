module Lab3_IReg(
	input [15:0] mem_data,
	input clk,
	input IRin,
	output reg [3:0] opcode,
	output reg [3:0] dest_reg,
	output reg [3:0] src_reg1,
	output reg [3:0] src_reg2
);

	always@(posedge clk)
    begin
        if(IRin==1)
        begin
            src_reg2 <= mem_data[3:0];
            src_reg1 <= mem_data[7:4];
            dest_reg <= mem_data[11:8];
            opcode <= mem_data[15:12];
        end
    end
	

endmodule