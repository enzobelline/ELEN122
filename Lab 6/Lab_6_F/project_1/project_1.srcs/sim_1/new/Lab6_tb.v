module L6_tb();
	
	reg clk, rst;
	wire const1 = 1'b1;
	
	//outputs above each module unless they woul dbe marked implicitly declared
	wire [7:0] pc;	
	wire [3:0] opcode, dst, src1, offset;
	wire D, WrX, MemWr, MemRd, imm, bz, bnz, jmp, sub, spc, halt;
	wire [15:0] rf_0, rf_1;
	wire branch, not_stall;
	wire stall; 
	reg not_stall_1;
	wire WrX_s2;
	wire [3:0] dst_s2;
	wire [15:0] wbdata;
	
    Lab6_PC pcm(.clk(clk),
		       .PC_out(pc));
    
			   
	wire [15:0] instruction;
	Lab6_IMEM imem(.clk(clk),
                   .address(pc),
			       .DataOut(instruction));
	
    wire ir_le;
    HALT h(.halt(halt),
//           .not_stall(not_stall_1),
           .LE(ir_le));
           
	IR ir(.mem_data(instruction),
		  .clk(clk),
		  .IRin(ir_le),
		  .opcode(opcode),
          .dest_reg(dst),
          .src_reg1(src1),
          .src_reg2(offset));
		
	wire [7:0] pc_1stage;
	SimpleReg8 pcstage1(.Ain(pc),
						.load_en(not_stall_1),
						.clk(clk),
						.Aout(pc_1stage));
		  
	Lab6_DECODE decoder(.opcode(opcode),
						.D(D),       
						.WrX(WrX),
						.MemWr(MemWr),   
						.MemRd(MemRd),
						.imm(imm),     
						.bz(bz),      
						.bnz(bnz),     
						.jmp(jmp),     
						.sub(sub),     
						.spc(spc),
						.halt(halt));	

	wire [255:0] regdata;
	RF rf(.clk(clk),
          .rst(rst),
          .DataIn(wbdata),
          .raddr_0(src1),
          .raddr_1(offset),
          .waddr(dst_s2),
          .WrX(WrX_s2),
          .out_data_0(rf_0),
          .out_data_1(rf_1),
          .regdata(regdata));
          
         
		
	wire [15:0] B_in;
	immediate_mux im(.RF(rf_1),
                     .imm(offset),
                     .RF_imm(imm),
                     .B(B_in));
	
	wire [15:0] A_out;
	simple_reg A(.Ain(rf_0),
                 .load_en(not_stall_1),
                 .clk(clk),
                 .Aout(A_out));
	
	wire [15:0] B_out;	
	simple_reg B(.Ain(B_in),
                 .load_en(not_stall_1),
                 .clk(clk),
                 .Aout(B_out));
	
	//_s dented staged 1 time
	wire WrX_s, sub_s, MemRd_s, MemWr_s, D_s, spc_s;
	wire [3:0] opcode_s, dst_s;
	wire [15:0] rf_0_s, rf_1_s;
	wire [255:0] regdata_s;
	STAGING stg(.clk(clk),
				.LD_EN(const1),
				.WrX_in(WrX),
				.Wrx_out(WrX_s),
				.sub_in(sub),
				.sub_out(sub_s),
//				.op_in(opcode),
//				.op_out(opcode_s),
				.MemRd_in(MemRd),
				.MemRd_out(MemRd_s),
				.MemWr_in(MemWr),
				.MemWr_out(MemWr_s),
				.dst_in(dst),
				.dst_out(dst_s),
				.rf_0_in(rf_0),
				.rf_1_in(rf_1),
				.rf_0_out(rf_0_s),
				.rf_1_out(rf_1_s),
				.D_in(D),
				.D_out(D_s),
				.rfdata_in(regdata),
				.rfdata_out(regdata_s),
				.spc_in(spc),
				.spc_out(spc_s));
				
	wire [7:0] pc_2stage;
	SimpleReg8 pcstage2(.Ain(pc_1stage),
						.load_en(not_stall_1),
						.clk(clk),
						.Aout(pc_2stage));
		
	wire [15:0] aluResult;
	ALU alu(.in_A(A_out),
		    .in_B(B_out),
		    .add_sub(sub_s),
		    .adder_out(aluResult));
		
	wire [15:0] G;
	simple_reg Gr(.Ain(aluResult),
                 .load_en(const1),
                 .clk(clk),
                 .Aout(G));
	
	wire datavalid;
	wire [15:0] dmem_data;
    lab6_DMEM dmem(.clk(clk),
                   .Address(rf_0_s),
                   .DataIn(rf_1_s),
                   .MemWr(MemWr_s),
                   .MemRd(MemRd_s),
                   .DataValid(datavalid),
			       .DataOut(dmem_data));
				
	wire [7:0] pc_3stage;
	SimpleReg8 pcstage3(.Ain(pc_2stage),
						.load_en(const1),
						.clk(clk),
						.Aout(pc_3stage));
		
	wire spc_s2;
	SimpleReg1 spcstage(.Ain(spc_s),
						.load_en(const1),
						.clk(clk),
						.Aout(spc_s2));
	wire MemRd_s2;					
	SimpleReg1 memrdstage(.Ain(MemRd_s),
						 .load_en(const1),
						 .clk(clk),
						 .Aout(MemRd_s2));
						 
				
	wire [15:0] memdata;
	MDR mdr(.MD_in(dmem_data),
            .load_en(const1),
            .clk(clk),
            .MD_out(memdata));
		
	WB_staging wbs(.clk(clk),
				   .LD_EN(const1),
				   .WrX_in(WrX_s),
				   .WrX_out(WrX_s2),
				   .dst_in(dst_s),
				   .dst_out(dst_s2));

	WBMux wbm(.MDR_data(memdata),
			  .G_data(G),
//			  .PC_data(pc_3stage),
//			  .load(MemRd_s2),
			  .SavePC(spc_s2), //may need to stage again
			  .mux_output(wbdata));
	
	
	initial begin
		clk = 0;
		rst = 1;
		#2
		not_stall_1 = 1;
		#2;
		rst = 0;
	end
	
	always #1 clk = !clk;

endmodule