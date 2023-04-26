/* BA : Branch Address*/

module EX_MEM (
    clk,
    ex_mem_RegWrite_i ,
    ex_mem_MemToReg_i ,
    ex_mem_Branch_i   ,    
    ex_mem_MemRead_i  ,
    ex_mem_MemWrite_i ,
    BA_i  ,
    FlagZero_i ,
    ALUresult_i,
    rd2_i      ,
    wr_i       ,
    funct3_i,
    ex_mem_RegWrite_o ,
    ex_mem_MemToReg_o ,
    ex_mem_Branch_o   ,    
    ex_mem_MemRead_o  ,
    ex_mem_MemWrite_o ,
    BA_o       ,
    FlagZero_o ,
    ALUresult_o,
    rd2_o      ,
    wr_o,
    funct3_o
);

    input clk, FlagZero_i, ex_mem_RegWrite_i, ex_mem_MemToReg_i, ex_mem_Branch_i, ex_mem_MemRead_i, ex_mem_MemWrite_i;
    input [31:0] BA_i, ALUresult_i, rd2_i;
    input [4:0] wr_i;
    input [2:0] funct3_i;

    output reg FlagZero_o, ex_mem_RegWrite_o, ex_mem_MemToReg_o, ex_mem_Branch_o, ex_mem_MemRead_o, ex_mem_MemWrite_o;
    output reg [31:0] BA_o, ALUresult_o, rd2_o;
    output reg [4:0] wr_o;
    output reg [2:0] funct3_o;

    always @(posedge clk) begin
        ex_mem_RegWrite_o <= ex_mem_RegWrite_i;
        ex_mem_MemToReg_o <= ex_mem_MemToReg_i;
        ex_mem_Branch_o   <= ex_mem_Branch_i;
        ex_mem_MemRead_o  <= ex_mem_MemRead_i;
        ex_mem_MemWrite_o <= ex_mem_MemWrite_i;
        BA_o <= BA_i;
        FlagZero_o <= FlagZero_i;
        ALUresult_o <= ALUresult_i;
        rd2_o <= rd2_i;
        wr_o <= wr_i;
        funct3_o <= funct3_i;
    end

endmodule
