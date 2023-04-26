module MEM_WB (
    clk         , 
    readMem_i    , 
    ALUresult_i  , 
    wr_i         ,
    mem_wb_RegWrite_i ,
    mem_wb_MemToReg_i , 
    readMem_o     , 
    ALUresult_o   , 
    wr_o          , 
    mem_wb_RegWrite_o , 
    mem_wb_MemToReg_o 
);

    input clk;
    input mem_wb_RegWrite_i, mem_wb_MemToReg_i;
    input [31:0] readMem_i, ALUresult_i;
    input [4:0] wr_i;

    output reg mem_wb_RegWrite_o, mem_wb_MemToReg_o;
    output reg [31:0] readMem_o, ALUresult_o;
    output reg [4:0] wr_o;

    always @(posedge clk) begin
        readMem_o <= readMem_i;
        ALUresult_o <= ALUresult_i;
        wr_o <= wr_i;
        mem_wb_RegWrite_o <= mem_wb_RegWrite_i;
        mem_wb_MemToReg_o <= mem_wb_MemToReg_i;
    end

endmodule
