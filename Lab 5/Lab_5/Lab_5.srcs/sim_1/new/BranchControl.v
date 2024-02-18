module BranchControl(input bz,
                     input bnz,
                     input jmp,
                     input [15:0] rf_data,
                     output reg loadNewPc
                     );
    always @(*) begin
        if(jmp)
            loadNewPc=1;
        else if(bz&&(rf_data==0))
            loadNewPc=1;
        else if(bnz&&(rf_data!=0))
            loadNewPc=1;
        else 
            loadNewPc=0;
    end
endmodule