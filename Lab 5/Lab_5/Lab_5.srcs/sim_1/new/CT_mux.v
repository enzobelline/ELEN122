module CT_mux( input [7:0] branch_addr,
			   input [7:0] jump_addr,
			   input jmp_branch,
			   output reg [7:0] newpc);
			   	 
    always@(*)
    begin
        if((jmp_branch==0))
            newpc <= branch_addr;

        else //_Extern
            newpc <= jump_addr;
    end
            
endmodule
