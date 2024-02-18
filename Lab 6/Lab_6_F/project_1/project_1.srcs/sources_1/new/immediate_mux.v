module immediate_mux(input [15:0] RF,
                    input [3:0] imm,
                    input RF_imm,
                    output [15:0] B);
    
    //outputs imm if RF_imm == 1.
    //defualt to RF (RF_imm == 0)
    assign B = RF_imm ? { {12{imm[3]}}, imm} : RF;              
               
endmodule
