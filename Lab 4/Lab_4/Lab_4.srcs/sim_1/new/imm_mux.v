module imm_mux(   input [15:0] rf_data,
                    input [15:0] sw_data,
                    input rf_select,
                    input sw_select,
                    output reg [15:0] adder_b);

    always@(*)
    begin
    
        if((rf_select==0 && sw_select==0)||(rf_select==1 && sw_select==1))
            adder_b <= 0;
            
        else if(rf_select==1)
            adder_b <= rf_data;

        else //_Extern
            adder_b <= sw_data;
            
    end
        
endmodule


