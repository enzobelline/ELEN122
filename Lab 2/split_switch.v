module split_switch(input [15:0] switches_in,
                    output [3:0] data,
                    output [1:0] addrx,
                    output [1:0] addry,
                    output [1:0] operation,
                    output execute,
                    output clk_standin
					);
                    
    assign data = switches_in[3:0];
    assign addrx = switches_in[5:4];
    assign addry = switches_in[7:6];
    assign operation = switches_in[9:8];
    assign execute = switches_in[10];
    assign clk_standin = switches_in[15];
	//some switches left over not being used.
    
endmodule
