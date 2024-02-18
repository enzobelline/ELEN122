`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2019 07:16:22 PM
// Design Name: 
// Module Name: L1_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module L1_tb();
//this is a tb for the L1_SM
    //purpose is to  be able to debug and/or visualize signals
    //this tb will test all of the functions necessary for lab1
    
    //external datat that would come from switches now comes from tb
    reg [2:0] op;
    reg [3:0] tb_data;
    reg [1:0] tb_addrx, tb_addry;
    
    //state machine signals
    reg clk, exec;
    wire extern, gout, ain, gin, rdx, rdy, wrx, add_sub;
    wire [3:0] smstate; 
    
    wire [3:0] rf_out;
    wire [6:0] seg;
    wire [7:0] an;
    wire [3:0] aout, adder_out, gdata, mout;
    
    Lab_1_Project sm(.Clock(clk),
             .Exec(exec),
             .Operation(op),
             ._Extern(extern),
             .Gout(gout),
             .Ain(ain),
             .Gin(gin),
             .RdX(rdx),
             .RdY(rdy),
             .WrX(wrx),
             .Add_sub(add_sub),
             .Cur_state(smstate));
    
    //no breakout of data, will need to look at internal signals to see reg content
    //bin_7seg and display_driver need to be included in the project       
    L1_RF RF(.fpga_clk(clk),
          .sw_clk(clk),
          .DataIn(mout),
          .AddrX(tb_addrx),
          .AddrY(tb_addry),
          .RdX(rdx),
          .RdY(rdy),
          .WrX(wrx),
          .sm_state(smstate),
          .Dataout(rf_out),
          .seg(seg), //6->0
          .an(an)); //7->0
                
    L1_ALU ALU(.in_A(aout),
                 .in_B(rf_out), //[3:0] 
                 .add_sub(add_sub),
                 .adder_out(adder_out));
     
    //pre adder reg             
    L1_simple_reg A(.reg_in(rf_out), //3->0
                 .load_en(ain),
                 .clk(clk),
                 .reg_out(aout));
              
    //post addr reg
    L1_simple_reg G(.reg_in(adder_out), //3->0
                 .load_en(gin),
                 .clk(clk),
                 .reg_out(gdata));
                 
    data_mux M1(.switch_data(tb_data),
                .G_data(gdata),
                .Gout(gout),
                ._Extern(extern),
                .mux_output(mout));

             
    initial begin
         clk = 0;
         #25; //small buffer to make things easier
         
         
         //load value of 2 into rf addr 0.
         //remember that load instr loads data into x
         tb_data = 2;
         tb_addrx = 0;
         op = 0; //load
         exec = 1;
         #25;
         exec = 0;
         //verify that the data goes in.
         
         
         //move the data we just loaded - from reg 0 to reg 3
         // this op will tkae multiple cycles
         // it needs to go though a staging reg, then the alu (and staging reg 2) and then writeback
         //mv loads x with y
         tb_addrx = 3;
         tb_addry = 0;
         #25
         op = 1;
         exec = 1;
         #25;
         exec = 0;
         
         
         //since the above 2 worked, lets try to do an add
         //we have 2 (reg 0) and 2 (reg 3), lets try and add and see if we get 4.
         //these arent changed, just re copying them to avoid confusion
         tb_addrx = 3; //this should get the value of 4
         tb_addry = 0;
         #25;
         op = 3; //add
         exec=1;
         #25;
         exec = 0;
         
         
         //now we have 4 in reg 3 and 2 in reg 2. do a subtract to get back 2 and 2
         //these arent changed, just re copying them to avoid confusion
         tb_addrx = 3; //this should get the value of 2
         tb_addry = 0;
         #25;
         op = 2; //sub
         exec=1;
         #25;
         exec = 0;
         
         
     end
                 
     always #5 clk = !clk;
     
endmodule
