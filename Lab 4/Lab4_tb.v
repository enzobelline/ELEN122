module L4_tb();
    //this is a tb for the L4_SM
    //since this lab changed the datapath size, many of the widths change here
    
    
    //state machine signals
    reg clk, exec, rst;
    wire extern, gout, ain, gin, din, rdx, rdy, wrx, add_sub, rf_select, sw_select, pc_en, ir_en, memwr, addrsel;
    wire [3:0] smstate; 
    
    wire [15:0] aout, adder_out, gdata, mout, IM_out;
    wire [15:0] dout;
	
	
	wire [7:0] pc_out;
	wire [15:0] mem_out;
	wire [3:0] ir_op, ir_rd, ir_rs1, ir_rs2;

	wire [255:0] regdata;
    wire [15:0] rf_0, rf_1; 
    
    
	Lab3_PC pc(.clk(clk),
		  .countEn(pc_en),
		  .reset(rst),
		  .Address(pc_out));
	
	wire [7:0] chopped_rfaddr;	  
    LSByte lsb(.from_RF(rf_0),
               .mux_addr(chopped_rfaddr));
	
	wire [7:0] mm_out;
	MemMux mm(.AddrSel(addrsel),
              .PC_addr(pc_out),
              .RF_addr(chopped_rfaddr),
              .mem_addr(mm_out));
              	  
	Lab4_MEM mem(.clk(clk),
	             .address(mm_out),
	             .DataIn(rf_1),
	             .MemWr(memwr),
	             .DataOut(mem_out));
    
    		
	Lab3_IReg ir(.mem_data(mem_out),
	      .clk(clk),
		  .IRin(ir_en),
		  .opcode(ir_op),
	      .dest_reg(ir_rd),
		  .src_reg1(ir_rs1),
		  .src_reg2(ir_rs2));
		  
    wire [15:0] se_imm;
    SE_16 se(.imm(ir_rs2),
                         .extended(se_imm));
    
    L4_SM sm(.clk(clk),
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
             .cur_state(smstate));
     
     
    L4_RF RF(.clk(clk),
          .rst(rst),
          .DataIn(mout),
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
                 
    L1_simple_reg D(.reg_in(rf_1), //3->0
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

		//this testbench is a bit different from the others
		//the instructinos come entirely from the program
		//to verify correctness, you will need to see that the 
		//results match what you expect from the program
		
		rst = 1;
		#20;
		rst = 0;
		
		//we just hold exec high so it executes the whole program
		exec = 1;
		#1000; 
		$finish;	
     end
                 
     always #1 clk = !clk;
     
endmodule