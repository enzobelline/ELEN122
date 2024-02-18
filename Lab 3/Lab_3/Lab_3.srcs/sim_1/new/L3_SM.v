`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2020 02:00:04 PM
// Design Name: 
// Module Name: L3_SM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//changed the parameters to correspond with lab 3 tb

/*make sure that the order of instructions which that you put for the SM coincides with that 
which is called in the tb*/

module L3_SM(           input clk,  
			            input reset,         //NEW
                        input execute,
                        input [2:0] operation,
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
			            output reg pc_en,   //NEW
		                output reg ir_en,   //NEW  
                        output [3:0] cur_state);
    
    parameter opLoad =0;
    parameter opMove =1;
    parameter opSub =2;
    parameter opAdd =3;
    parameter opAddi =4;
    parameter opSubi =5;
    parameter opDisp =6;
    parameter opHalt =7;
    
                        
    parameter decode = 0; //0
    parameter load =   1; //1
    parameter move =   2; //2
    parameter read_x = 3; //3
    parameter read_y = 4; //4
    parameter write_x =5;//5
    parameter add  =   6;//6
    parameter sub  =   7;//7
    parameter addi =   8;//8
    parameter subi =   9;//9
    parameter disp =   10;//a 
    parameter done =   11;//b
    //added for lab 3
    parameter fetch =   12;//c
    parameter halt =   13;//d
    
    reg [3:0] state = decode;
    reg [3:0] next_state;
    assign cur_state = state;
   
    initial begin
            _Extern<=0;
            Gout<=0;
            Ain<=0;
            Gin<=0;
            Din<=0;
            RdX<=0;
            RdY<=0;
            WrX<=0;
            add_sub<=0;
            rf_select<=0;
            sw_select<=0;
            pc_en <=1;
            ir_en <=1;
            next_state <= fetch;
        end
            
    always@(posedge clk) begin
            state <= next_state;
        end
        
    always@(*) begin
            if(reset)
                begin
                _Extern=0;
                Gout=0;
                Ain=0;
                Gin=0;
                Din=0;
                RdX=0;
                RdY=0;
                WrX=0;
                add_sub=0;
                rf_select=0;
                sw_select=0;
                pc_en=0;
                ir_en=0;
                next_state = fetch;
                end 
             
            else
                begin
                next_state=state;
                
                
        case (state)
            fetch:begin
                ir_en=1;
                pc_en=1;
                if(execute==1)
                    next_state=decode;
               end

            decode:begin                
                ir_en=0;
                pc_en=0;
                if(execute==1)
                    begin
                    if(operation==opLoad)    //load
                        next_state = load;
                    else if(operation==opMove||operation==opAdd)  //move//add
                        next_state=read_y;
                    else if(operation==opSub||operation==opAddi||operation==opSubi)   //sub//addi//subi
                        next_state=read_x;
                    else if(operation==opDisp)   //disp
                        next_state=disp;   
                    else if(operation==opHalt)   //halt
                        next_state=halt;   
                    end     
                end
                
            //halt state added for lab 3
            halt: begin
                    if(reset==1)
                        next_state = fetch;
                  end
            load: begin
                WrX = 1;
                _Extern=1;
                next_state=done;
               end
               
            read_y: begin
                RdY = 1;
                Ain = 1;
                if(operation== 3) // add
                    next_state=add;
                else if(operation==1) //move
                    next_state=move;
               end
                
            add: begin
                RdY = 0;
                Ain = 0;
                RdX=1;
                add_sub=0;
                Gin=1;
                rf_select=1;
                next_state=write_x;
               end
            
            move: begin
                RdY = 0;
                Ain = 0;
                Gin = 1;
                next_state = write_x;
               end
            
            write_x: begin
                _Extern=0;
                RdX=0;
                RdY=0;
                Gin=0;
                Gout=1;
                rf_select=0;
                sw_select=0;
                WrX=1;
                next_state=done;
               end
                
            read_x: begin
                RdX=1;
                Ain=1;         
                if(operation== opSub)   // sub
                    next_state = sub;
                else if(operation==opAddi)// addi 
                    next_state=addi;
                else if(operation==opSubi)// subi
                    next_state=subi;
               end
                
            sub: begin
                RdX=0;
                Ain=0;
                RdY=1;
                add_sub=1;
                rf_select=1;
                Gin=1;
                next_state = write_x;
               end

            addi: begin
                RdX=0;
                _Extern=1;
                Ain=0;
                sw_select=1;
                _Extern=1;
                add_sub=0;
                Gin=1;
                next_state = write_x;
               end
               
            subi: begin
                RdX=0;
                _Extern=1;
                Ain=0;
                sw_select=1;
                add_sub=1;
                Gin=1;
                next_state = write_x;
               end     
               
            disp: begin
                RdX=1;
                Din=1;
                next_state=done;
                end
                
            //ADDED FOR LAB 3
                   
            done: begin
                _Extern=0;
                RdX=0;
                RdY=0;
                Gin=0;
                WrX=0;
                Ain=0;
                Gout=0;
                add_sub=0;
                //lab 2 
                Din=0;
                rf_select=0;
                sw_select=0;
                next_state = fetch;
                end
        endcase 
    end
    end
endmodule

/*operations
000 - Load 0
001 - Move 1
010 - Sub 2
011 - Add 3
100 - Addi 4
101 - Subi 5
110 - Display 6
111 - Halt */