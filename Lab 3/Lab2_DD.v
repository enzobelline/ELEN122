//this is the debug version of the display driver
//it allows you to see the register contents and SM state
//along with the digit you want to display.

module Lab2_DD
    (
    input fpga_clk,
    input [3:0] display_digit,
	input [3:0] reg_0,
	input [3:0] reg_1,
	input [3:0] reg_2,
	input [3:0] reg_3,
    input [3:0] sm_state,
    
    //7 segment outputs.
    output reg [6:0]seg = 7'b0000000,
    output [7:0]an
    );
    
    wire [6:0] dd, r0, r1, r2, r3, sm;
    bin_7seg disp_decode(.data(display_digit), .seg(dd));
    bin_7seg r0_decode(.data(reg_0), .seg(r0));
    bin_7seg r1_decode(.data(reg_1), .seg(r1));
    bin_7seg r2_decode(.data(reg_2), .seg(r2));
    bin_7seg r3_decode(.data(reg_3), .seg(r3));
    bin_7seg state_decode(.data(sm_state), .seg(sm));
    
    //7 segment display regs and wires.
    reg [16:0]clk_div = 17'h00000;
    reg [7:0]an_driver = 8'b11111110;
    reg ce1k = 1'b0;
    
    //Assign anode to drive.
    assign an = an_driver;
              
    //Create 1kHz clock enable
    always @(posedge fpga_clk) begin
        clk_div <= clk_div + 1'b1;
        
        //Count to 100000 and reset.
        if(clk_div == 17'd99999) begin
            clk_div <= 0;
            ce1k <= 1'b1;
        end
        
        //Reset.
        else begin
            ce1k <= 1'b0;
        end
        
        //Drive the next anode. Only cycle thru 4 "assertions"
		// since there are only four digits to drive
        if(ce1k) begin
            an_driver[0] <= an_driver[7];
            an_driver[7] <= an_driver[5];
			an_driver[5] <= an_driver[4];
			an_driver[4] <= an_driver[3];
			an_driver[3] <= an_driver[2];
			an_driver[2] <= an_driver[0];
        end
    end 
    
    //Choose which part of number to display.
    always @(*) begin
        case(an_driver)
            8'b11111110 : seg = dd;
			
			8'b11111011 : seg = r0;
			8'b11110111 : seg = r1;
			8'b11101111 : seg = r2;
			8'b11011111 : seg = r3;
			
            8'b01111111 : seg = sm;
            default : seg = 7'b0000000;       
        endcase
    end
    
endmodule