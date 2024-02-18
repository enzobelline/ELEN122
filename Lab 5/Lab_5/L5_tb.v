module L5_tb();
    //this is a tb for the L5_SM
    //state machine signals
    reg clk, exec, rst;
    wire extern, gout, ain, gin, din, rdx, rdy, wrx, add_sub, rf_select, sw_select, pc_en, ir_en, memwr, addrsel, jmpbranch, bz, bnz, jmp, savepc;
    wire [4:0] smstate; 
    
    wire [15:0] aout, adder_out, gdata, mout, IM_out;
    wire [15:0] dout;
	
	
	wire [7:0] pc_out;
	wire [15:0] mem_out; 
	wire [3:0] ir_op, ir_rd, ir_rs1, ir_rs2;

	wire [255:0] regdata;
    wire [15:0] rf_0, rf_1; 
    
    
	wire loadnewpc;
	wire [7:0] newpc;
	Lab5_PC pc(.clk(clk),
		  .countEn(pc_en),
		  .reset(rst),
		  .Address(pc_out),
		  .loadNewPC(loadnewpc),
		  .newPC(newpc));
	
	wire [7:0] chopped_rfaddr;	  
    LSByte lsb(.from_RF(rf_0),
               .mux_addr(chopped_rfaddr));
	
	wire [7:0] mm_out;
	MemMux mm(.AddrSel(addrsel),
              .PC_addr(pc_out),
              .RF_addr(chopped_rfaddr),
              .mem_addr(mm_out));
              	  
	Lab5_MEM mem(.clk(clk),
	             .address(mm_out),
	             .DataIn(rf_1),
	             .MemWr(memwr),
	             .DataOut(mem_out));
    
    		
	Lab5_IR ir(.mem_data(mem_out),
	      .clk(clk),
		  .IRin(ir_en),
		  .opcode(ir_op),
	      .dest_reg(ir_rd),
		  .src_reg1(ir_rs1),
		  .src_reg2(ir_rs2));
	
	wire [7:0] adjPC;
	Lab5_BranchPC bpc(.clk(clk),
			     .PC_addr(pc_out),
			     .offset(ir_rs2),
			     .adjustedPC(adjPC));
			 
	CT_mux ctm(.branch_addr(adjPC),
			   .jump_addr(chopped_rfaddr),
			   .jmp_branch(jmpbranch),
			   .newpc(newpc));
			   
			   
	BranchControl bc(.bz(bz),
					 .bnz(bnz),
					 .jmp(jmp),
					 .rf_data(rf_0),
					 .loadNewPc(loadnewpc));
			   
	wire [15:0] extendedPC;
	ZE_16 ze(.pc(pc_out),
						 .extended(extendedPC));
	
	wire [15:0] toRF;
	SPC_mux spcm(.mux_data(mout),
				 .PC_data(extendedPC),
				 .savepc(savepc),
				 .RF_data(toRF));
						 
		  
    wire [15:0] se_imm;
    SE_16 se(.imm(ir_rs2),
                         .extended(se_imm));
    
    L5_SM sm(.clk(clk),
             .reset(rst),
             .execute(exec),
             .operation(ir_op),
             ._Extern(extern),
             .Gout(gout),
             .Ain(ain),
             .Gin(gin),
			 .Din(din),
             .RdX(rdx),
             .RdY(rdy),
             .WrX(wrx),
             .add_sub(add_sub),
			 .rf_select(rf_select),
			 .sw_select(sw_select),
			 .pc_en(pc_en),
			 .ir_en(ir_en),
			 .MemWr(memwr),
			 .AddrSel(addrsel),
			 //inserted these
			 .jmp_branch(jmpbranch),
			 .bz(bz),
			 .bnz(bnz),
			 .jmp(jmp), 
			 .savepc(savepc),
			 //
             .cur_state(smstate));
     
     
    L4_RF RF(.clk(clk),
          .rst(rst),
          .DataIn(toRF),
          .raddr_0(ir_rs1),
          .raddr_1(ir_rs2),
          .waddr(ir_rd),
          .WrX(wrx),
          .out_data_0(rf_0),
          .out_data_1(rf_1),
		  .regdata(regdata));
                
    L1_ALU ALU(.in_A(aout),
                 .in_B(IM_out),
                 .add_sub(add_sub),
                 .adder_out(adder_out));
     
    //pre adder reg             
    L1_simple_reg A(.reg_in(rf_0), //3->0
                 .load_en(ain),
                 .clk(clk),
                 .reg_out(aout));
              
    //post addr reg
    L1_simple_reg G(.reg_in(adder_out), //3->0
                 .load_en(gin),
                 .clk(clk),
                 .reg_out(gdata));
                 
    L1_simple_reg D(.reg_in(rf_0), //3->0
          .load_en(din),
          .clk(clk),
          .reg_out(dout));
                 
    data_mux M1(.switch_data(mem_out),
                .G_data(gdata),
                .Gout(gout),
                ._Extern(extern),
                .mux_output(mout));
				
	imm_mux IM(.rf_data(rf_1),
               .sw_data(se_imm),
               .rf_select(rf_select),
               .sw_select(sw_select),
               .adder_b(IM_out));

             
    initial begin
        clk = 0;

		
		rst = 1;
		#20;
		rst = 0;
		
		//we just hold exec high so it executes the whole program
		exec = 1;
		#1000; //change to be longer as needed
		$finish;	
     end
                 
     always #1 clk = !clk;
     
endmodule