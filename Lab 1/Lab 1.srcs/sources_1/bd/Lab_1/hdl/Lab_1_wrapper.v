//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Fri Jan 17 19:34:45 2020
//Host        : dcts-lc-2 running 64-bit major release  (build 9200)
//Command     : generate_target Lab_1_wrapper.bd
//Design      : Lab_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Lab_1_wrapper
   (a,
    b);
  input [31:0]a;
  input [31:0]b;

  wire [31:0]a;
  wire [31:0]b;

  Lab_1 Lab_1_i
       (.a(a),
        .b(b));
endmodule
