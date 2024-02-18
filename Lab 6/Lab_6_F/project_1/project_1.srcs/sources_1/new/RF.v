module RF(input clk,
          input rst,
          input [15:0] DataIn,
          input [3:0] raddr_0,
          input [3:0] raddr_1,
          input [3:0] waddr,
          input WrX,
          output [15:0] out_data_0,
          output [15:0] out_data_1,
          output [255:0] regdata);

	
   reg [15:0] datastorage [15:0]; 

    always@(posedge clk)
    begin
    
        if(rst)
        begin
            datastorage[0]  <= $urandom;
            datastorage[1]  <= $urandom;
            datastorage[2]  <= $urandom;
            datastorage[3]  <= $urandom;
            datastorage[4]  <= $urandom;
            datastorage[5]  <= $urandom;
            datastorage[6]  <= $urandom;
            datastorage[7]  <= $urandom;
            datastorage[8]  <= $urandom;
            datastorage[9]  <= $urandom;
            datastorage[10] <= $urandom;
            datastorage[11] <= $urandom;
            datastorage[12] <= $urandom;
            datastorage[13] <= $urandom;
            datastorage[14] <= $urandom;
            datastorage[15] <= $urandom;
        end

        else if(WrX) //write high
            datastorage[waddr] <= DataIn;

    end

    assign out_data_0 = datastorage[raddr_0];
    assign out_data_1 = datastorage[raddr_1];
    
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
  
    

endmodule