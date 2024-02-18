module Lab6_DECODE(
    input [3:0] opcode,
    output reg D,
    output reg WrX,
    output reg MemWr,
    output reg MemRd,
    output reg imm,
    output reg bz,
    output reg bnz,
    output reg jmp,
    output reg sub,
    output reg spc,
    output reg halt
    );
    
    
    
    parameter opLd = 0;
    parameter opSub = 2;
    parameter opAdd = 3;
    parameter opDisplay = 4;
    parameter opAddi = 5;
    parameter opSubi = 6;
    parameter opHalt = 7;
    parameter opSTR = 1;
    parameter opNOP = 8;

    
    
    always @(*) 
        begin 
            case(opcode)
                opLd: begin
                    D	     =  0;
                    WrX		 =  1;
                    MemWr	 =  0;
                    MemRd	 =  1;
//                    imm	 	 =  0;
//                    bz		 =  0;
//                    bnz 	 =  0;
//                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  1;
                    halt	 =  0;
                end    
                opSub: begin
                    D	     =  0;
                    WrX		 =  1;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  0;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  1;
                    spc 	 =  0;
                    halt	 =  0;
                end
                opAdd: begin
                    D	     =  0;
                    WrX		 =  1;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  0;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  0;
                    halt	 =  0;
                end
                opDisplay: begin
                    D	     =  1;
                    WrX		 =  0;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  0;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  0;
                    halt	 =  0;
                end
                opAddi: begin
                    D	     =  0;
                    WrX		 =  1;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  1;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  0;
                    halt	 =  0;
                end
                opSubi: begin
                    D	     =  0;
                    WrX		 =  1;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  1;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  1;
                    spc 	 =  0;
                    halt	 =  0;
                end
                opHalt: begin
                    D	     =  0;
                    WrX		 =  0;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  0;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  0;
                    halt	 =  1;
                end
                opSTR: begin
                    D	     =  0;
                    WrX		 =  0;
                    MemWr	 =  1;
                    MemRd	 =  0;
                    imm	 	 =  0;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  0;
                    halt	 =  0;
                end
                opNOP: begin
                    D	     =  0;
                    WrX		 =  0;
                    MemWr	 =  0;
                    MemRd	 =  0;
                    imm	 	 =  0;
                    bz		 =  0;
                    bnz 	 =  0;
                    jmp      =  0;
                    sub 	 =  0;
                    spc 	 =  0;
                    halt	 =  0;
                end
            endcase
        end
endmodule
