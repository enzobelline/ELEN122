module L4_dd
    (
    input fpga_clk,
	input [3:0] sm_state,
	input [3:0] hex_0,
	input [3:0] hex_1,
	input [3:0] hex_2,
	input [3:0] hex_3,
   
    
    //7 segment outputs.
    output reg [6:0]seg = 7'b0000000,
    output [7:0]an
    );
    
    wire [6:0] h0, h1, h2, h3, sm;
	bin_7seg state_decode(.data(sm_state), .seg(sm));
    bin_7seg h0_decode(.data(hex_0), .seg(h0));
    bin_7seg h1_decode(.data(hex_1), .seg(h1));
    bin_7seg h2_decode(.data(hex_2), .seg(h2));
    bin_7seg h3_decode(.data(hex_3), .seg(h3));
    
    
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
        
		//using digit 7, 3, 2, 1, 0
        if(ce1k) begin
			an_driver[0] <= an_driver[7];
            an_driver[7] <= an_driver[3];
			an_driver[3] <= an_driver[2];
			an_driver[2] <= an_driver[1];
			an_driver[1] <= an_driver[0];
        end
    end 
    
    //Choose which part of number to display.
    always @(*) begin
        case(an_driver)
		
			8'b01111111 : seg = sm;
			
			8'b11111110 : seg = h0;
			8'b11111101 : seg = h1;
			8'b11111011 : seg = h2;
			8'b11110111 : seg = h3;
			
            
            default : seg = 7'b0000000;       
        endcase
    end
    
endmodule
