module WBMux( input [15:0] MDR_data,
			  input [15:0] G_data,
			  input SavePC,
			  output reg [15:0] mux_output);

        always@(*) begin
            if(SavePC==1)
            mux_output <= MDR_data;
            else //(savePC==0)
            mux_output <= G_data;
        end
endmodule
