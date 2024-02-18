module Lab5_PC(
	input clk,
	input countEn,
	input reset,
	input loadNewPC,
	input [7:0] newPC,
	output reg [7:0] Address
);        
    always@(posedge clk)
    begin
        if(reset)
        begin
            Address <= 0;
        end
        
        else if(loadNewPC)
		begin
			Address <= newPC;
		end
        
        else if(countEn)
        begin
              Address <= Address + 1;
        end
    end
	
endmodule