module Lab3_sw_ctrl(
	input [15:0] switches,
	input btnC, //center button
	input fpga_clk,
	output sw_clk,
	output reg execute,
	output reg reset
);
    
    reg [19:0] counter = 0; //20 bit gives 0->1,048,576
    
    assign sw_clk = (counter<999999/2)?1'b0:1'b1;
    
    always@(posedge fpga_clk)
    begin
    
        //counter for 1hz clock
        counter <= counter + 1;
        if( counter >= 999999 )
        begin
            counter <= 0;
        end
        
        if(switches[0] == 1) //reset
        begin
            reset <= 1;
            execute <= 1;
        end
        
        else        //not reset
        begin
        
            if(switches[1] == 0) //1 instr mode
            begin
                reset <= 0;
                execute <= 1;
            end
            
            else // 1 cycle mode
            begin
                reset <= 0;
                execute <= btnC;
            end
            
        end
        
    end

    
endmodule
