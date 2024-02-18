module HALT(input halt,
//            output reg not_stall,
            output reg LE
            );
    initial begin
        LE = 1;
    end
    always @(*) begin
    if(halt==0)
        LE <= 1;
    else
        LE <= 0;
//        not_stall <= 0;
        
    end
    
endmodule
