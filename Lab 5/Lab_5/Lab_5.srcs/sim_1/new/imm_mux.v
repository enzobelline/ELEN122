`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2020 02:06:58 PM
// Design Name: 
// Module Name: immed_mux
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


module imm_mux(     input [15:0] rf_data,
                    input [15:0] sw_data,
                    input rf_select,
                    input sw_select,
                    output reg [15:0] adder_b);

    always@(*)
    begin
    
        if((rf_select==0 && sw_select==0)||(rf_select==1 && sw_select==1))
            adder_b <= 0;
            
        else if(sw_select==0&&rf_select==1)
            adder_b <= rf_data;

        else //_Extern
            adder_b <= sw_data;
            
    end
        
endmodule

