module L4_DD_frontend(
	input fpga_clk,
	input [15:0] switches,
	input [15:0] display_digit,
	input [255:0] regdata,
	output [3:0] h_0,
	output [3:0] h_1,
	output [3:0] h_2,
	output [3:0] h_3
);
					  
	//using 5 switches. 
	//switch 15 is like a display select. if its high, display the display_digit
	//if its low, switches 14:11 select which reg addr to display from				 
	wire [3:0] addrcontrol;
	assign addrcontrol = switches[14:11]; 
	
	wire select;
	assign select = switches[15];
	
	reg [15:0] data;
	always@(posedge fpga_clk)
	begin
		
		case(addrcontrol)
			4'd0:  data = regdata[15:0];
			4'd1:  data = regdata[31:16];
			4'd2:  data = regdata[47:32];
			4'd3:  data = regdata[63:48];
			4'd4:  data = regdata[79:64];
			4'd5:  data = regdata[95:80];
			4'd6:  data = regdata[111:96];
			4'd7:  data = regdata[127:112];
			4'd8:  data = regdata[143:128];
			4'd9:  data = regdata[159:144];
			4'd10: data = regdata[175:160];
			4'd11: data = regdata[191:176];
			4'd12: data = regdata[207:192];
			4'd13: data = regdata[223:208];
			4'd14: data = regdata[239:224];
			4'd15: data = regdata[255:240];
		endcase
		
	end
	
	//select == 1 -> want dd
	assign h_0 = select ? display_digit[3:0]   : data[3:0];
	assign h_1 = select ? display_digit[7:4]   : data[7:4];
	assign h_2 = select ? display_digit[11:8]  : data[11:8];
	assign h_3 = select ? display_digit[15:12] : data[15:12];
	
endmodule

/*
assuming regdata is exported like so:

assign regdata = {datastorage[15],
				  datastorage[14],
				  datastorage[13],
				  datastorage[12],
				  datastorage[11],
				  datastorage[10],
				  datastorage[9],
				  datastorage[8],
				  datastorage[7],
				  datastorage[6],
				  datastorage[5],
				  datastorage[4],
				  datastorage[3],
				  datastorage[2],
				  datastorage[1],
				  datastorage[0]};
*/