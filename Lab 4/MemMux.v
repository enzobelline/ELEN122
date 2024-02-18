module MemMux(input AddrSel,
              input [7:0] PC_addr,
              input [7:0] RF_addr,
              output [7:0] mem_addr);
              
    assign mem_addr = AddrSel ? RF_addr : PC_addr; 
    
endmodule