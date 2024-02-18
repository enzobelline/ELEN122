module L5_SM(input clk,
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
			 output reg MemWr,   
			 output reg AddrSel, 
			 //new for L5
			 output reg bz,
			 output reg bnz,
			 output reg jmp,
			 output reg jmp_branch,   
			 output reg savepc,
			 //
			 output [4:0] cur_state);
			
	//defining all my states - 8 total
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
    
    //new
    parameter BZ 	    =  14; //e
    parameter BNZ       =  15; //f
    parameter JUMP      =  16; //10
    parameter SAVEPC    =  17; //11
	
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
		  //set all to zero
		  _Extern = 0;
          Gout = 0;
          Ain = 1;
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
          savepc = 0;
          jmp_branch = 0;
          bz = 0;
          bnz = 0;
          jmp = 0;
          next_state = FETCH;
		end
		
		else
		begin
	        next_state = state;
                                
            case(state)
                FETCH: begin  
                        ir_en = 1;
                        pc_en = 1;
                        Ain=1;          
                        if(execute==1)
                            next_state = DECODE;
                      end
                      
                DECODE : begin          
                            //should probably make a case statement
                            if(execute == 1 && operation == 0) next_state = LOAD;   //entry to load
                            if(execute == 1 && operation == 1) next_state = STORE;  //entry to store
                            if(execute == 1 && operation == 2) next_state = SUB; //entry to sub
                            if(execute == 1 && operation == 3) next_state = ADD; //entry to add
                            if(execute == 1 && operation == 4) next_state = DISP;
                            if(execute == 1 && operation == 5) next_state = ADDI; //entry to addi (x=x+i, need to read x first now)
                            if(execute == 1 && operation == 6) next_state = SUBI; //entry to subi
                            if(execute == 1 && operation == 7) next_state = HALT;
                            //new
                            if(execute == 1 && operation == 8) next_state = BZ;   
                            if(execute == 1 && operation == 9) next_state = BNZ; 
                            if(execute == 1 && operation == 10) next_state = JUMP;
                            if(execute == 1 && operation == 11) next_state = SAVEPC;
                         end   
                            
                HALT: begin
                          if (reset==1) next_state = FETCH;
                      end
                
                DISP: begin
                        Din = 1;
                        next_state = DONE;
                      end
                      
                LOAD: begin
                        _Extern = 1;
                        WrX = 1;
                        AddrSel = 1;
                        next_state = DONE;
                      end
                      
//                READ_Y: begin
//                            RdY = 1;
//                            Ain = 1;
//                            if(operation == 3) next_state = ADD;
//                        end
                        
//                READ_X: begin
//                            RdX = 1;
//                            Ain = 1;
//                            if(operation == 2) next_state = SUB;
//                            if(operation == 6) next_state = SUBI;
//                            if(operation == 5) next_state = ADDI;
//                        end
                        
                ADD: begin
                         Ain = 1;
                         rf_select = 1;
                         Gin = 1;
//                         RdY=1;
                         next_state = WRITE_X;
                     end
                
                ADDI: begin
                         sw_select = 1;
                         Gin = 1;
                         Ain=1;
                         _Extern=1;
//                         WrX=1;
                         next_state = WRITE_X;
                      end
                     
                SUB: begin
                        Ain = 1;
                        add_sub = 1;
                        rf_select = 1;
                        Gin = 1;
//                         RdY=1;
                        next_state = WRITE_X;
                     end
                     
                SUBI: begin
                         Ain = 1;
                         add_sub = 1;
                         sw_select = 1;
                         Gin = 1;
                         _Extern=1;
//                         WrX=1;
                         next_state = WRITE_X;
                      end
                      
                STORE: begin
                        MemWr = 1;
                        next_state = DONE;
                       end
                    
                WRITE_X: begin
                            add_sub = 0;
                            RdX = 0;
                            RdY = 0;
                            Ain = 0;
                            Gin = 0;
                            Gout = 1;
                            WrX = 1;
                            next_state = DONE;
                         end
                     
                //new states defined for lab 5         
                BZ: begin
                            bz=1;
                            jmp_branch=0;
                            next_state = DONE;
                         end
                BNZ: begin
                            bnz=1;
                            jmp_branch=0;
                            next_state = DONE;
                         end

                JUMP: begin
                            jmp=1;
                            jmp_branch=1;
                            next_state = DONE;
                         end
                         
                SAVEPC: begin
                            savepc=1;
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
                        AddrSel = 0;
                        savepc = 0;
                        jmp_branch = 0;
                        bz = 0;
                        bnz = 0;
                        jmp = 0;                        
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
1000 - bz
1001 - bnz
1010 - jump
1011 - savepc
*/