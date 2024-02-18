module L3_tb();
    //this is a tb for the L3_SM
    //purpose is to  be able to debug and/or visualize signals
    //this tb will test all of the functions necessary for lab3
    
	//where the previous labs had registers for ops, this will use
	//the PC/MEM/IR combo
    
    //state machine signals
    
    reg clk, exec;
    wire extern, gout, ain, gin, din, rdx, rdy, wrx, add_sub, rf_select, sw_select;
    wire [3:0] smstate; 
    
    wire [3:0] rf_out;
    wire [3:0] aout, adder_out, gdata, mout, IM_out;
    wire [3:0] dout;
	
	wire [3:0] r0, r1, r2, r3;
	
	wire pc_en, ir_en;
	reg rst;
	wire [7:0] pc_out;
	wire [15:0]mem_out;
	wire [3:0] ir_data;
	wire [1:0] ir_addrx, ir_addry;
	wire [2:0] ir_op;
	wire [4:0] ir_zeros;
	
	Lab3_PC pc(.clk(clk),
		  .countEn(pc_en),
		  .reset(rst),
		  .Address(pc_out));
		  
	Lab3_MEM mem(.count(pc_out),
				 .Data(mem_out));
				
	Lab3_IR ir(.mem_data(mem_out),
	      .clk(clk),
		  .IRin(ir_en),
		  .data_out(ir_data),
	      .addrx(ir_addrx),
		  .addry(ir_addry),
		  .operation(ir_op),
		  .zeros(ir_zeros));
    
    L3_SM sm(.clk(clk),
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
             .cur_state(smstate));
         
    Lab2_RF RF(.clk(clk),
          .rst(rst),
          .DataIn(mout),
          .AddrX(ir_addrx),
          .AddrY(ir_addry),
          .RdX(rdx),
          .RdY(rdy),
          .WrX(wrx),
          .Dataout(rf_out),
		  .r_0(r0),
		  .r_1(r1),
		  .r_2(r2),
		  .r_3(r3));
                
    L3_ALU ALU(.in_A(aout),
                 .in_B(IM_out), //[3:0] 
                 .add_sub(add_sub),
                 .adder_out(adder_out));
     
    //pre adder reg             
    L3_simple_reg A(.reg_in(rf_out), //3->0
                 .load_en(ain),
                 .clk(clk),
                 .reg_out(aout));
              
    //post addr reg
    L3_simple_reg G(.reg_in(adder_out), //3->0
                 .load_en(gin),
                 .clk(clk),
                 .reg_out(gdata));
                 
    L3_simple_reg D(.reg_in(rf_out), //3->0
          .load_en(din),
          .clk(clk),
          .reg_out(dout));
                 
    data_mux M3(.switch_data(ir_data),
                .G_data(gdata),
                .Gout(gout),
                ._Extern(extern),
                .mux_output(mout));
				
	immed_mux IM(.rf_data(rf_out),
               .sw_data(ir_data),
               .rf_select(rf_select),
               .sw_select(sw_select),
               .adder_b(IM_out));

             
    initial begin
        clk = 0;

		//this testbench is a bit different from the others
		//the instructinos come entirely from the program
		//to verigy correctness, you will need to see that the 
		//results match what you expect from the program
		
		rst = 1;
		#20;
		rst = 0;
		
		//we just hold exec high so it executes the whole program
		exec = 1;
		#1000; //change to be longer as needed
			
     end
                 
     always #5 clk = !clk;
     
endmodule