module data_mux(
	input [15:0] switch_data,
	input [15:0] G_data,
	input Gout,
	input _Extern,
	output reg [15:0] mux_output
);
    
    always@(*)
    begin
    
        if((Gout==0 && _Extern==0)||(Gout==1 && _Extern==1))
            mux_output <= 0;
            
        else if(Gout==1)
            mux_output <= G_data;

        else //_Extern
            mux_output <= switch_data;
            
    end
    
endmodule