module Lab6_PC(
    input clk,
    output reg [7:0] PC_out
);
    reg [7:0] counter = 0;
    
    always@(posedge clk)
    begin
        PC_out = counter;
        counter = counter + 1;
    end

endmodule
