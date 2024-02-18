module SPC_mux(  input [15:0] mux_data,
				 input [15:0] PC_data,
				 input savepc,
				 output reg [15:0] RF_data);
				 
    always@(*)
    begin
        if(savepc==0)
            RF_data <= mux_data;
        else 
            RF_data <= PC_data;
    end
endmodule
