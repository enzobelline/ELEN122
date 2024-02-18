module STAGING(
input clk,
input LD_EN,
input D_in,
input WrX_in,
input MemWr_in,
input MemRd_in,
input sub_in,
input spc_in,
input rfdata_in,
input [15:0]rf_1_in,
input [15:0]rf_0_in,
input [3:0]dst_in,
//input op_in,

output reg Wrx_out, //Delayed 2 Cycles 
output reg sub_out, //Delayed 1 Cycle
//output reg op_out,
output reg MemRd_out, //Delay 1 Cycle
output reg MemWr_out, //Delayed 2 Cycle
output reg [3:0] dst_out,   //Delayed 2 Cycles
output reg [15:0] rf_0_out,  //Delayed 1 Cycle
output reg [15:0] rf_1_out,  //Delayed 1 Cycle
output reg D_out,      
output reg rfdata_out, //Delayed 1 Cycle
output reg spc_out     //Delayed 2 Cycles?????

    );
    //Regs that need 2 Cycle Delay
  
    always@(posedge clk) begin
        Wrx_out <= WrX_in;
       
        
        sub_out <= sub_in;
        
        MemRd_out <= MemRd_in;
        
        MemWr_out <= MemWr_in;
       
        
        dst_out <= dst_in;
    
        
        rf_0_out <= rf_0_in;
        rf_1_out <= rf_1_in;
        
        rfdata_out <= rfdata_in;
        spc_out <= spc_in;
        
    end
endmodule   