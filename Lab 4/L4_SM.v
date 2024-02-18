module L4_SM(input clk,
			 input execute,
			 input [3:0] operation, 
			 input reset,
			 output reg _Extern,
			 output reg Gout,
			 output reg Ain,
			 output reg Gin,
			 output reg Din,
			 output reg RdX, 
			 output reg RdY,  
			 output reg WrX,
			 output reg add_sub,
			 output reg rf_select,
			 output reg sw_select,
			 output reg pc_en,
			 output reg ir_en,
			 output reg MemWr,   //new
			 output reg AddrSel, //new
			 output [3:0] cur_state);
			
	parameter FETCH 	=  0;
	parameter LOAD 		=  1;
	parameter READ_Y 	=  2;
	parameter READ_X 	=  3;
	parameter ADD 		=  4;
	parameter SUB 		=  5;	
	parameter STORE 	=  6;
	parameter WRITE_X 	=  7;
	parameter DONE 		=  8;
	parameter ADDI 	    =  9;
    parameter SUBI      =  10;
    parameter DISP      =  11;
    parameter HALT      =  12;
    parameter DECODE    =  13;
	
	reg [3:0] state = FETCH;
	reg [3:0] next_state;
	 
	assign cur_state = state;
		 
	always@(posedge clk)
	begin
		state <= next_state;
    end
    
	always@(*)
	begin
		if(reset)
		begin
		  _Extern = 0;
          Gout = 0;
          Ain = 0;
          Gin = 0;
          RdX = 0;
          RdY = 0;
          WrX=0;
          add_sub = 0;
          rf_select = 0;
          sw_select = 0;
          Din = 0;
          pc_en = 0;
          ir_en = 0;
          MemWr = 0;
          AddrSel = 0; 
          next_state = FETCH;
		end
		
		else
		begin
	        next_state = state;
                                
            case(state)
                FETCH: begin  
                        ir_en = 1;
                        pc_en = 1;          
                        next_state = DECODE;
                      end
                      
                DECODE : begin
                            ir_en = 0;
                            pc_en = 0;          
                            if(execute == 1 && operation == 0) next_state = LOAD;   //entry to load
                            if(execute == 1 && operation == 1) next_state = STORE;  //entry to store
                            if(execute == 1 && operation == 3) next_state = READ_Y; //entry to add
                            if(execute == 1 && operation == 2) next_state = READ_X; //entry to sub
                            if(execute == 1 && operation == 4) next_state = DISP;
                            if(execute == 1 && operation == 5) next_state = READ_X; //entry to addi (x=x+i, need to read x first now)
                            if(execute == 1 && operation == 6) next_state = READ_X; //entry to subi
                            if(execute == 1 && operation == 7) next_state = HALT;
                         end   
                            
                HALT: begin
                          _Extern = 0;
                          Gout = 0;
                          Ain = 0;
                          Gin = 0;
                          RdX = 0;
                          RdY = 0;
                          add_sub = 0;
                          rf_select = 0;
                          sw_select = 0;
                          Din = 0;
                          pc_en = 1;
                          ir_en = 1;
                          MemWr = 0;
                          AddrSel = 0; 
                      end
                
                DISP: begin
                        RdX = 1;     
                        Din = 1;
                        next_state = DONE;
                      end
                      
                LOAD: begin
                        _Extern = 1;
                        WrX = 1;
                        AddrSel = 1;
                        next_state = DONE;
                      end
                      
                READ_Y: begin
                            RdY = 1;
                            Ain = 1;
                            if(operation == 3) next_state = ADD;
                        end
                        
                READ_X: begin
                            RdX = 1;
                            Ain = 1;
                            if(operation == 2) next_state = SUB;
                            if(operation == 6) next_state = SUBI;
                            if(operation == 5) next_state = ADDI;
                        end
                        
                ADD: begin
                        RdY = 0;
                        Ain = 0;
                        RdX = 1;
                        add_sub = 0;
                        rf_select = 1;
                        Gin = 1;
                        next_state = WRITE_X;
                     end
                
                ADDI: begin
                         RdX = 0;
                         Ain = 0;
                         add_sub = 0;
                         sw_select = 1;
                         Gin = 1;
                         next_state = WRITE_X;
                      end
                     
                SUB: begin
                        RdX = 0;
                        Ain = 0;
                        RdY = 1;
                        add_sub = 1;
                        rf_select = 1;
                        Gin = 1;
                        next_state = WRITE_X;
                     end
                     
                SUBI: begin
                         RdX = 0;
                         Ain = 0;
                         add_sub = 1;
                         sw_select = 1;
                         Gin = 1;
                         next_state = WRITE_X;
                      end
                      
                STORE: begin
                        MemWr = 1;
                        AddrSel = 1; 
                        next_state = DONE;
                       end
                    
                WRITE_X: begin
                            add_sub = 0;
                            RdX = 0;
                            RdY = 0;
                            Gin = 0;
                            Gout = 1;
                            WrX = 1;
                            next_state = DONE;
                         end
                         
                DONE: begin
                        _Extern = 0;
                        WrX = 0;
                        Gout = 0;
                        RdY = 0;
                        RdX = 0;
                        Ain = 0;
                        Gin = 0;
                        add_sub = 0;
                        rf_select = 0;
                        sw_select = 0;
                        Din = 0;
                        AddrSel = 0;
                        MemWr = 0;
                        if(execute == 1) 
                            next_state = FETCH;
                      end
                default: next_state = FETCH;
            endcase
	   end 			
	end	 
endmodule

/*
0000 - load
0001 - store //new
0010 - subtract
0011 - add
0100 - display
0101 - addi
0110 - subi
0111 - halt

*/