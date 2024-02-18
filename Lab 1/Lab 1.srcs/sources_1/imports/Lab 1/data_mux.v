module data_mux(input [3:0] switch_data,
                input [3:0] G_data,
                input Gout,
                input _Extern,
                output reg [3:0] mux_output);

    always@(*)
    begin
    
        if((Gout==0 && _Extern==0)||(Gout==1 && _Extern==1))
            mux_output <= 0;
            
        else if(Gout)
            mux_output <= G_data;

        else //_Extern
            mux_output <= switch_data;
            
    end
        
endmodule