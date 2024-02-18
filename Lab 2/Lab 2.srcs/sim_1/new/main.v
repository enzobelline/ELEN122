`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara University
// Engineer: Laurence Kim
// 
// Create Date: 01/23/2020 10:33:52 PM
// Design Name: State Machine for Lab 2
// Module Name: main
// Project Name: Lab 2
// Target Devices: Nexys 4
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
module main (           input Clock,
                        input Exec,
                        input [2:0] Operation,
                        output reg _Extern,
                        output reg Gout,
                        output reg Ain,
                        output reg Gin,
                        output reg RdX,
                        output reg RdY,
                        output reg WrX,
                        output reg Add_sub,

                        output reg Din,   //added                        
                        output reg Rf_select,
                        output reg Sw_select,
                        
                        output [3:0] Cur_state);
   
    parameter idle =   4'b0000;
    parameter load =   4'b0001;
    parameter move =   4'b0010;
    parameter read_x = 4'b0011;
    parameter read_y = 4'b0100;
    parameter write_x =4'b0101;
    parameter add  =   4'b0110;
    parameter sub  =   4'b0111;
    //new boys
    parameter addi =   4'b1000;
    parameter subi =   4'b1001;
    parameter disp =   4'b1010;
    
    parameter done =   4'b1011;
    
    reg [3:0] state = idle;
    reg [3:0] next_state;
    assign Cur_state = state;//set the cur_state as a wire and had to use the syntax assign because you cant physicaly change it for a register
   
    initial begin
            _Extern<=0;
            Gout<=0;
            Ain<=0;
            Gin<=0;
            RdX<=0;
            RdY<=0;
            Add_sub<=0;
            next_state<=idle;
        end
            
    always@(posedge Clock)
        begin
            state <= next_state;
        end
        
always@(*)
    begin
        next_state=state;
        case (state)
            idle:begin
                if(Exec == 1 && Operation==0)
                    next_state = load;
                if(Exec==1&&Operation==1)
                    next_state=read_y;
                if(Exec==1&&Operation==3)
                    next_state=read_y;
                if(Exec==1&&Operation==2)
                    next_state=read_x;
                    
                if(Exec==1&&Operation==4)   //addi
                    next_state=read_x;
                if(Exec==1&&Operation==5)   //subi
                    next_state=read_x;  
                if(Exec==1&&Operation==6)   //subi
                    next_state=disp;   
                end
            
            //load state idle
            load: begin
                WrX = 1;
                _Extern=1;
                next_state=done;
               end
               
            //read y state idle
            read_y: begin
                RdY = 1;
                Ain = 1;
                if(Operation== 3)
                    next_state=add;
                else if(Operation==1)
                    next_state=move;
               end
                
            add: begin
                RdY = 0;
                Ain = 0;
                RdX=1;
                Gin=1;
                Rf_select=1;
                next_state=write_x;
               end
            
            move: begin
                RdY = 0;
                Ain = 0;
                Gin = 1;
                next_state = write_x;
               end
            
            write_x: begin
                RdX=0;
                Gin=0;
                Gout=1;
                WrX=1;
                next_state=done;
               end
                
            read_x: begin
                RdX=1;
                Ain=1;         
                if(Operation== 3)
                    next_state = sub;
                else if(Operation==4)
                    next_state=addi;
                else if(Operation==5)
                    next_state=subi;
               end
                
            sub: begin
                RdX=0;
                Ain=0;
                RdY=1;
                Add_sub=1;
                Rf_select=1;
                Gin=1;
                next_state = write_x;
               end

            addi: begin
                RdX=0;
                Ain=0;
                
                Sw_select=1;
                Add_sub=0;
                
                Gin=1;
                
                next_state = write_x;
               end
               
            subi: begin
                RdX=0;
                Ain=0;
                Sw_select=1;
                Add_sub=1;
                
                Gin=1;
                
                next_state = write_x;
               end     
               
            disp: begin
                RdX=0;
                Din=1;
                next_state=done;
                end
                   
            done: begin
                RdX=0;
                RdY=0;
                Gout=0;
                Gin=0;
                WrX=0;
                Ain=0;
                _Extern=0;
                Add_sub=0;
                //lab 2 
                Din=0;
                Rf_select=0;
                Sw_select=0;
                
                next_state = idle;
                end
        endcase 
    end
endmodule

/*Operations
000 - Load
001 - Move
010 - Sub
011 - Add
100 - Addi
101 - Subi
110 - Display */