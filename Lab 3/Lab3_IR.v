module Lab3_IR(
	input [15:0] mem_data,
	input clk,
	input IRin,
    output reg [3:0] data_out,    
	output reg [1:0] addrx,   
	output reg [1:0] addry,   
	output reg [2:0] operation, 
	output reg [4:0] zeros     
);
	
	always@(posedge clk)
    begin
        if(IRin)
        begin
            zeros    <= mem_data[15:11];
            operation<= mem_data[10:8];
            addrx    <= mem_data[7:6];
            addry    <= mem_data[5:4];
            data_out <= mem_data[3:0];
        end
    end
	


endmodule