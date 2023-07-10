module ID_EX (
    clk,
    ID_Flush,
    id_ex_LUIorAUIPC_i,
    id_ex_Jump_i,
    id_ex_RegWrite_i ,
    id_ex_MemToReg_i ,
    id_ex_MemRead_i  ,
    id_ex_MemWrite_i ,
    id_ex_ALUop_i  ,
    id_ex_ALUsrc_i   , 
    branchAddr_i       ,
    id_ex_pc_i,
    id_ex_pcPlusFour_i , 
    rd1_i      , 
    rd2_i      ,
    imm_i      , 
    ALUctrl_funct7_i  ,
    ALUctrl_funct3_i  ,
    wr_i       ,
    rs1_i      ,
    rs2_i      ,
    id_ex_LUIorAUIPC_o,
    id_ex_Jump_o,
    id_ex_RegWrite_o ,
    id_ex_MemToReg_o ,  
    id_ex_MemRead_o  ,
    id_ex_MemWrite_o ,
    id_ex_ALUop_o    ,
    id_ex_ALUsrc_o  ,
    branchAddr_o      ,
    id_ex_pc_o,
    id_ex_pcPlusFour_o ,
    rd1_o     ,
    rd2_o     ,
    imm_o     ,
    ALUctrl_funct7_o  , 
    ALUctrl_funct3_o  , 
    wr_o      ,
    rs1_o      ,
    rs2_o      
);

    input clk, ID_Flush, id_ex_RegWrite_i, id_ex_MemRead_i, id_ex_MemWrite_i, id_ex_ALUsrc_i, id_ex_LUIorAUIPC_i;
    input [1:0] id_ex_ALUop_i, id_ex_MemToReg_i, id_ex_Jump_i;
    input [31:0] id_ex_pcPlusFour_i, branchAddr_i, rd1_i, rd2_i, imm_i, id_ex_pc_i; 
    input [6:0] ALUctrl_funct7_i;
    input [2:0] ALUctrl_funct3_i;
    input [4:0] wr_i, rs1_i, rs2_i;

    output reg id_ex_RegWrite_o, id_ex_MemRead_o, id_ex_MemWrite_o, id_ex_ALUsrc_o, id_ex_LUIorAUIPC_o;
    output reg [1:0] id_ex_ALUop_o, id_ex_MemToReg_o, id_ex_Jump_o;
    output reg [31:0] id_ex_pcPlusFour_o, branchAddr_o, rd1_o, rd2_o, imm_o, id_ex_pc_o; 
    output reg [6:0] ALUctrl_funct7_o;
    output reg [2:0] ALUctrl_funct3_o;
    output reg [4:0] wr_o, rs1_o, rs2_o;

    always @(posedge clk) begin
        if(ID_Flush == 0) begin
            id_ex_LUIorAUIPC_o <= id_ex_LUIorAUIPC_i;
            id_ex_Jump_o <= id_ex_Jump_i;
            id_ex_RegWrite_o <= id_ex_RegWrite_i;
            id_ex_MemToReg_o <= id_ex_MemToReg_i;
            id_ex_MemRead_o <= id_ex_MemRead_i;
            id_ex_MemWrite_o <= id_ex_MemWrite_i;
            id_ex_ALUop_o <= id_ex_ALUop_i;
            id_ex_ALUsrc_o <= id_ex_ALUsrc_i;
            branchAddr_o <= branchAddr_i;
            id_ex_pc_o <= id_ex_pc_i;
            id_ex_pcPlusFour_o <= id_ex_pcPlusFour_i;
            rd1_o <= rd1_i;
            rd2_o <= rd2_i;
            imm_o <= imm_i;
            ALUctrl_funct7_o <= ALUctrl_funct7_i;
            ALUctrl_funct3_o <= ALUctrl_funct3_i;
            wr_o <= wr_i;
            rs1_o <= rs1_i;
            rs2_o <= rs2_i;
        end
        else begin
            id_ex_LUIorAUIPC_o <= 0;
            id_ex_Jump_o <= 0;
            id_ex_RegWrite_o <= 0;
            id_ex_MemToReg_o <= 0;
            id_ex_MemRead_o <= 0;
            id_ex_MemWrite_o <= 0;
            id_ex_ALUop_o <= 0;
            id_ex_ALUsrc_o <= 0;
            branchAddr_o <= 0;
            id_ex_pc_o <= 0;
            id_ex_pcPlusFour_o <= 0;
            rd1_o <= 0;
            rd2_o <= 0;
            imm_o <= 0;
            ALUctrl_funct7_o <= 0;
            ALUctrl_funct3_o <= 0;
            wr_o <= 0;
            rs1_o <= 0;
            rs2_o <= 0;
        end
    end

endmodule
