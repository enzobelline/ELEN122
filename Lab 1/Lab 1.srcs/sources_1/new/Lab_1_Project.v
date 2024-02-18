`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: Santa Clara University 
// Engineer: Laurence Kim
// 
// Create Date: 01/17/2020 02:58:41 PM
// Design Name: 
// Module Name: Lab_1_Project
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

module Lab_1_Project (  input Clock,
                        input Exec,
                        input [1:0] Operation,
                        output reg _Extern,
                        output reg Gout,
                        output reg Gin,
                        output reg Ain,
                        output reg RdX,
                        output reg RdY,
                        output reg WrX,
                        output reg Add_sub,
                        output [3:0] Cur_state);
   
    parameter idle =   4'b0000;
    parameter load =   4'b0001;
    parameter move =   4'b0010;
    parameter read_x = 4'b0011;
    parameter read_y = 4'b0100;
    parameter write_x =4'b0101;
    parameter add =    4'b0110;
    parameter sub =    4'b0111;
    parameter done =   4'b1000;
    
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
                next_state = sub;
               end
                
            sub: begin
                RdX=0;
                Ain=0;
                RdY=1;
                Add_sub=1;
                Gin=1;
                next_state = write_x;
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
                next_state = idle;
                end
        endcase 
    end
endmodule
