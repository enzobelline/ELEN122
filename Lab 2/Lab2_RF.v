module Lab2_RF
(
	input clk,
	input [3:0] DataIn,
	input [1:0] AddrX,
	input [1:0] AddrY,
	input RdX,
	input RdY,
	input WrX,
	output [3:0] Dataout,
	
	//these 4 signals will provide the current contents of the 
	//register file for displaying on the nexys board.
	output [3:0] r_0,
	output [3:0] r_1,
	output [3:0] r_2,
	output [3:0] r_3
);
	
	reg [3:0] datastorage [3:0]; 
	
	initial begin

		datastorage[0] = 0;
		datastorage[1] = 0;
		datastorage[2] = 0;
		datastorage[3] = 0;
	end
   
	assign r_0 = datastorage[0];
	assign r_1 = datastorage[1];
	assign r_2 = datastorage[2];
	assign r_3 = datastorage[3];

	always@(posedge clk)
	begin

		if(WrX & !(RdX||RdY)) //write high, not reading
			datastorage[AddrX] <= DataIn;   

	end

    
	wire both;
	assign both = ((RdX == 0 && RdY == 0) || (RdX == 1 && RdY == 1));
    
    
	assign Dataout = both ? 0 : ( RdX ? datastorage[AddrX] : datastorage[AddrY]); 

endmodule