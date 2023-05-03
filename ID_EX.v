module ID_EX (
    clk,
    id_ex_RegWrite_i ,
    id_ex_MemToReg_i ,
    id_ex_Branch_i   ,
    id_ex_MemRead_i  ,
    id_ex_MemWrite_i ,
    id_ex_ALUop_i  ,
    id_ex_ALUsrc_i   , 
    pc_i       , 
    rd1_i      , 
    rd2_i      ,
    imm_i      , 
    ALUctrl_funct7_i  ,
    ALUctrl_funct3_i  ,
    wr_i       ,
    rs1_i      ,
    rs2_i      ,
    id_ex_RegWrite_o ,
    id_ex_MemToReg_o ,
    id_ex_Branch_o   ,  
    id_ex_MemRead_o  ,
    id_ex_MemWrite_o ,
    id_ex_ALUop_o    ,
    id_ex_ALUsrc_o  ,
    pc_o      ,
    rd1_o     ,
    rd2_o     ,
    imm_o     ,
    ALUctrl_funct7_o  , 
    ALUctrl_funct3_o  , 
    wr_o      ,
    rs1_o      ,
    rs2_o      
);

    input clk, id_ex_RegWrite_i, id_ex_MemToReg_i, id_ex_Branch_i, id_ex_MemRead_i, id_ex_MemWrite_i;
    input [1:0] id_ex_ALUop_i, id_ex_ALUsrc_i;
    input [31:0] pc_i, rd1_i, rd2_i, imm_i; 
    input [6:0] ALUctrl_funct7_i;
    input [2:0] ALUctrl_funct3_i;
    input [4:0] wr_i, rs1_i, rs2_i;

    output reg id_ex_RegWrite_o, id_ex_MemToReg_o, id_ex_Branch_o, id_ex_MemRead_o, id_ex_MemWrite_o;
    output reg [1:0] id_ex_ALUop_o, id_ex_ALUsrc_o;
    output reg [31:0] pc_o, rd1_o, rd2_o, imm_o; 
    output reg [6:0] ALUctrl_funct7_o;
    output reg [2:0] ALUctrl_funct3_o;
    output reg [4:0] wr_o, rs1_o, rs2_o;

    always @(posedge clk) begin
        id_ex_RegWrite_o <= id_ex_RegWrite_i;
        id_ex_MemToReg_o <= id_ex_MemToReg_i;
        id_ex_Branch_o <= id_ex_Branch_i;
        id_ex_MemRead_o <= id_ex_MemRead_i;
        id_ex_MemWrite_o <= id_ex_MemWrite_i;
        id_ex_ALUop_o <= id_ex_ALUop_i;
        id_ex_ALUsrc_o <= id_ex_ALUsrc_i;
        pc_o <= pc_i;
        rd1_o <= rd1_i;
        rd2_o <= rd2_i;
        imm_o <= imm_i;
        ALUctrl_funct7_o <= ALUctrl_funct7_i;
        ALUctrl_funct3_o <= ALUctrl_funct3_i;
        wr_o <= wr_i;
        rs1_o <= rs1_i;
        rs2_o <= rs2_i;
    end

endmodule
