module Lab2_tb();

    //this is a tb for the L2_SM
    //purpose is to  be able to debug and/or visualize signals
    //this tb will test all of the functions necessary for lab2
    
    
    reg [2:0] op;
    reg [3:0] tb_data;
    reg [1:0] tb_addrx, tb_addry;
    
    reg clk, exec;
    wire extern, gout, ain, gin, din, rdx, rdy, wrx, add_sub, rf_select, sw_select;
    wire [3:0] smstate; 
    
    wire [3:0] rf_out;
    wire [3:0] aout, adder_out, gdata, mout, IM_out;
    wire [3:0] dout;
	
	wire [3:0] r0, r1, r2, r3;
    
    main sm(.Clock(clk),
             .Exec(exec),
             .Operation(op),
             ._Extern(extern),
             .Gout(gout),
             .Ain(ain),
             .Gin(gin),
			 .Din(din),
             .RdX(rdx),
             .RdY(rdy),
             .WrX(wrx),
             .Add_sub(add_sub),
			 .Rf_select(rf_select),
			 .Sw_select(sw_select),
             .Cur_state(smstate));
         
    Lab2_RF RF(.clk(clk),
          .DataIn(mout),
          .AddrX(tb_addrx),
          .AddrY(tb_addry),
          .RdX(rdx),
          .RdY(rdy),
          .WrX(wrx),
          .Dataout(rf_out),
		  .r_0(r0),
		  .r_1(r1),
		  .r_2(r2),
		  .r_3(r3));
                
    L1_ALU ALU(.in_A(aout),
                 .in_B(IM_out),
                 .add_sub(add_sub),
                 .adder_out(adder_out));
     
                
    L1_simple_reg A(.reg_in(rf_out), 
                 .load_en(ain),
                 .clk(clk),
                 .reg_out(aout));
              
    
    L1_simple_reg G(.reg_in(adder_out), 
                 .load_en(gin),
                 .clk(clk),
                 .reg_out(gdata));
                 
    L1_simple_reg D(.reg_in(rf_out), 
          .load_en(din),
          .clk(clk),
          .reg_out(dout));
                 
    data_mux M1(.switch_data(tb_data),
                .G_data(gdata),
                .Gout(gout),
                ._Extern(extern),
                .mux_output(mout));
				
	imme_mux IM(.rf_data(rf_out),
               .sw_data(tb_data),
               .rf_select(rf_select),
               .sw_select(sw_select),
               .adder_b(IM_out));

             
    initial begin
         clk = 0;
         #25;
         
         
         //load value of 2 into rf addr 0.
         tb_data = 2;
         tb_addrx = 0;
         op = 0;
         exec = 1;
         #25;
         exec = 0;
         //verify that the data goes in.
         
         
         //move the data we just loaded - from reg 0 to reg 3
         tb_addrx = 3;
         tb_addry = 0;
         #25;
         op = 1;
         exec = 1;
         #25;
         exec = 0;
         
         //add an imm (3) to reg 3 to get 5
         tb_addrx = 3;
         tb_addry = 0;
         tb_data = 3;
         #25;
         op = 4;
         exec = 1;
         #25;
         exec = 0;
		 
		 //sub an imm (1) to reg 3 to get 4
         tb_addrx = 3;
         tb_addry = 0;
         tb_data = 1;
         #25;
         op = 5;
         exec = 1;
         #25;
         exec = 0;
         
         //display data
         tb_addrx = 3;
         tb_addry = 0;
         tb_data = 0;
         #25;
         op = 6;
         exec = 1;
         #25;
         exec = 0;
         
     end
                 
     always #5 clk = !clk;
     
endmodule