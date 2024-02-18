module MemMux(input AddrSel,
              input [7:0] PC_addr,
              input [7:0] RF_addr,
              output [7:0] mem_addr);
              
    //condition ? iftrue : iffalse
    
    //AddrSel = 1, we want RF addr to go thru
    assign mem_addr = AddrSel ? RF_addr : PC_addr; 
    
endmodule