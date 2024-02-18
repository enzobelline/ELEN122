module L4_SM(input clk,
			 input execute,
			 input [3:0] operation, //changed
			 input reset,
			 output reg _Extern,
			 output reg Gout,
			 output reg Ain,
			 output reg Gin,
			 output reg Din,
			 output reg RdX, //wont be connected anymore
			 output reg RdY, //wont be connected anymore 
			 output reg WrX,
			 output reg add_sub,
			 output reg rf_select,
			 output reg sw_select,
			 output reg pc_en,
			 output reg ir_en,
			 output reg MemWr,   //new
			 output reg AddrSel, //new
			 output [3:0] cur_state);
			
	//defining all my states - 8 total
	parameter FETCH 	=  4'b0000;
	parameter LOAD 		=  4'b0001;
	parameter READ_Y 	=  4'b0010;
	parameter READ_X 	=  4'b0011;
	parameter ADD 		=  4'b0100;
	parameter SUB 		=  4'b0101;
	
	//parameter MV 		=  4'b0110; //no longer needed, done with addi/subi with imm=0
	parameter STORE 	=  4'b0110;
	
	parameter WRITE_X 	=  4'b0111;
	parameter DONE 		=  4'b1000;
	
	parameter ADDI 	    =  4'b1001;
    parameter SUBI      =  4'b1010;
    parameter DISP      =  4'b1011;
    
    parameter HALT      =  4'b1100;
    parameter DECODE    =  4'b1101;
	
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
          add_sub = 0;
          rf_select = 0;
          sw_select = 0;
          Din = 0;
          pc_en = 1;
          ir_en = 1;
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
                            //should probably make a case statement
                            if(execute == 1 && operation == 0) next_state = LOAD;   //entry to load
                            if(execute == 1 && operation == 1) next_state = STORE; //entry to store
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
                          pc_en = 0;
                          ir_en = 0;
                          MemWr = 0;
                          AddrSel = 0; 
                      end
                
                DISP: begin
                        RdX = 1;     //defining dsiplay from X in this
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
                            //if(operation == 1) next_state = MV;
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
                
                //addi comes from readx	 
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
                /*     
                MV: begin
                        RdX = 0;
                        RdY = 0;
                        Gin = 1;
                        Ain = 0;
                        rf_select = 1;
                        next_state = WRITE_X;
                    end
                */
                
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
                
                        //reset from load
                        _Extern = 0;
                        WrX = 0;
                        
                        //reset from WRITE_X
                        WrX = 0;
                        Gout = 0;
                        
                        //set everything else low
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
                              
                        ///new - we only return to fetch if execute is still high
                        if(execute == 1) next_state = FETCH;
                        
                      end
                      
                default: next_state = FETCH;
                
            endcase
       
	   end //end else			
	end //end always
	
	
			 
			 
			 
endmodule

/*
encodings - moved to 4 bit

0000 - load
0001 - store (used to be move)
0010 - subtract
0011 - add
0100 - display
0101 - addi
0110 - subi
0111 - HALT

*/