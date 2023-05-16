// `include "Adder32.v"
// `include "ALU_control.v"
// `include "ALU.v"
// `include "ControlUnit.v"
// `include "DataMem.v"
// `include "EX_MEM.v"
// `include "ID_EX.v"
// `include "IF_ID.v"
// `include "ImmGen.v"
// `include "InstructionMem.v"
// `include "MEM_WB.v"
// `include "MUX32_2to1.v"
// `include "PC.v"
// `include "RegFile.v"

module PipelineDatapath (clk, reset);


    //------------------------------I/O ports---------------------------------
    input clk, reset; //FIX RESET SIGNAL
    //input [31:0] address;
    //------------------------Wires for datapath-----------------------------

    //---------IF
     //wire PCsrc;
    wire [31:0] add4, branchAddr, mux_to_pc, pc_out, instMemOut;

    
    //---------ID
    wire [31:0] if_id_pc_o, if_id_inst_o, rd1_id_ex, rd2_id_ex, Immed;
    wire [1:0] ImmGenCtrl, ALUop, ALUsrc;
    wire Branch, MemRead, MemWrite, RegWrite, MemToReg;
    wire hazDetect_PC, hazDetect_IF_ID, reg_write, mem_write;
    wire regWrite_to_ID_EX, memWrite_to_ID_EX;
    //wire [9:0] ALUctrl_id_ex;


    //---------EX
    wire zeroFlag, zero_EX_MEM;
    wire [31:0] rd1_MUX, rd2_MUX, imm_MUX, pc_to_Adder, ALU_0, ALU_1, result, adder_res, ALUres_EX_MEM;
    //wire [9:0] ALU_ctrl;
    wire [2:0] funct3_to_out;
    wire [6:0] funct7_to_out;
    wire [4:0] wr_to_EX_MEM, rs1_FW_in, rs2_FW_in;
    wire [1:0] ALUop_out, ALUsrc_out;
    wire RegWrite_to_ex_mem, MemToReg_to_ex_mem, Branch_to_ex_mem, MemRead_to_ex_mem, MemWrite_to_ex_mem;
    //wire [1:0] WB_to_EX_MEM;
    //wire [2:0] MEM_to_EX_MEM;
    //wire [3:0] EX_out;
    wire [3:0] ALUctrl_lines;
    wire [1:0] fw0, fw1;


    //---------MEM----------------
    wire zero_AND;
    //wire [2:0] MEM_out;
    wire RegWrite_to_mem_wb, MemToReg_to_mem_wb, Branch_out, MemRead_out, MemWrite_out;
    wire [31:0] res_to_DataMem_Addr, rd2_to_DataMem_wd, DataMem_out, Data_from_Mem, ALUres_toMUX;
    wire [4:0] wr_to_MEM_WB, wr_to_regFile;
    wire [2:0] f3_to_dataMem;
    //wire [1:0] WB_out;
    //wire [1:0] WB_to_MEM_WB;


    //----------WB-----------------
    wire [31:0] writeData_to_regFile;
    wire RegWrite_out, MemToReg_out;


    //--------------------------------------------------------------MODULES--------------------------------------------------------    
    
    
    //IF
    PC pc (
        .clk        (clk),
        .reset      (reset),
        .pc_input   (add4), //mux_to_pc
        .hazDetect_PC (hazDetect_PC),
        .pc_output  (pc_out)
    );

    initial begin
        $monitor ("[$monitor] time = %t, pc_write = %h, inst = %h, memRead_haz = %h, ALU_out = %h, fw0 = %h, fw1 = %h, mem_write = %b, dataMemOut = %h", $time, hazDetect_PC, instMemOut, MemRead_to_ex_mem, result, fw0, fw1, MemWrite_out, DataMem_out);
    end

    Adder32 PCadd4 (
        .data1   (pc_out),
        .data2   (32'd4),
        .data_o  (add4)
    );

    MUX32_2to1 pc_input_select (
        .select_i (1'b0), //sel 
        .data0_i  (add4),
        .data1_i  (adder_res),
        .data_o   (mux_to_pc)
    );

    InstructionMem instMem (
        .addr   (pc_out),
        .reset  (reset),
        .inst   (instMemOut)
    );
    

    //--------------------------------ID----------------------------
    IF_ID if_id (
        .clk    (clk),
        .hazDetect_IF_ID (hazDetect_IF_ID),
        .pc_i   (pc_out), 
        .inst_i (instMemOut), 
        .pc_o   (if_id_pc_o), 
        .inst_o (if_id_inst_o)
    );

    
    RegFile registers (
        .clk        (clk),
        .RegWrite   (RegWrite_out),
        .rr1        (if_id_inst_o[19:15]),
        .rr2        (if_id_inst_o[24:20]),
        .wr         (wr_to_regFile),
        .wd         (writeData_to_regFile),
        .rd1        (rd1_id_ex),
        .rd2        (rd2_id_ex)
    );


    HazDetectUnit hazDetection (
        .ID_EXrd        (wr_to_EX_MEM),
        .IF_IDrs1       (if_id_inst_o[19:15]),
        .IF_IDrs2       (if_id_inst_o[24:20]),
        .branch         (),
        .ID_EXmemRead   (MemRead_to_ex_mem),
        .ID_EXregWrite  (), 
        .ID_EXmemToReg  (),
        .ID_EXmemWrite  (),
        .rs1_MUX        (),
        .rs2_MUX        (),
        .PCwrite        (hazDetect_PC), //wire hazDetect_PC, hazDetect_IF_ID, reg_write, mem_write;
        .IF_IDwrite     (hazDetect_IF_ID), 
        .regWrite       (reg_write), 
        .memWrite       (mem_write)
    );

    ControlUnit control (
        .opcode      (if_id_inst_o[6:0]), 
        .ImmGenCtrl  (ImmGenCtrl), 
        .ALUop       (ALUop),
        .ALUsrc      (ALUsrc),
        .Branch      (Branch), 
        .MemRead     (MemRead),
        .MemWrite    (MemWrite), 
        .RegWrite    (RegWrite),
        .MemToReg    (MemToReg)
    );

    MUX_2to1 regWrite (
        .select_i  (reg_write), 
        .data0_i   (1'b0), 
        .data1_i   (RegWrite), 
        .data_o    (regWrite_to_ID_EX) //wire regWrite_to_ID_EX, memWrite_to_ID_EX;
    );

    MUX_2to1 memWrite (
        .select_i  (mem_write), 
        .data0_i   (1'b0), 
        .data1_i   (MemWrite), 
        .data_o    (memWrite_to_ID_EX)
    );

    ImmGen immediates (
        .inst    (if_id_inst_o),
        .ctrl    (ImmGenCtrl),
        .imm     (Immed)
    );

    Adder32 branchAddress (
        .data1   (Immed),
        .data2   (if_id_pc_o),
        .data_o  (adder_res)
    );


    //-----------------------------------------------------------EX---------------------------------------------------------------
    ID_EX id_ex (
        .clk        (clk), //.WB_i       ({RegWrite, MemToReg}), //.MEM_i      ({Branch, MemRead, MemWrite}), //.EX_i       ({ALUop, ALUsrc}),
        .id_ex_RegWrite_i (regWrite_to_ID_EX),
        .id_ex_MemToReg_i (MemToReg),
        .id_ex_Branch_i   (Branch),
        .id_ex_MemRead_i  (MemRead),
        .id_ex_MemWrite_i (memWrite_to_ID_EX),
        .id_ex_ALUop_i    (ALUop),
        .id_ex_ALUsrc_i   (ALUsrc), 
        .pc_i       (if_id_pc_o), 
        .rd1_i      (rd1_id_ex), 
        .rd2_i      (rd2_id_ex),
        .imm_i      (Immed), 
        .ALUctrl_funct7_i  (if_id_inst_o[31:25]),
        .ALUctrl_funct3_i  (if_id_inst_o[14:12]),
        .wr_i       (if_id_inst_o[11:7]), //.WB_o       (WB_to_EX_MEM),//.MEM_o      (MEM_to_EX_MEM),//.EX_o       (EX_out),
        .rs1_i      (if_id_inst_o[19:15]),
        .rs2_i      (if_id_inst_o[24:20]),
        .id_ex_RegWrite_o (RegWrite_to_ex_mem),
        .id_ex_MemToReg_o (MemToReg_to_ex_mem),
        .id_ex_Branch_o   (Branch_to_ex_mem),    //wire RegWrite_to_ex_mem, MemToReg_to_ex_mem, Branch_to_ex_mem, MemRead_to_ex_mem, MemWrite_to_ex_mem;
        .id_ex_MemRead_o  (MemRead_to_ex_mem),
        .id_ex_MemWrite_o (MemWrite_to_ex_mem),
        .id_ex_ALUop_o    (ALUop_out), //wire [1:0] ALUop_out, ALUsrc_out;
        .id_ex_ALUsrc_o   (ALUsrc_out),
        .pc_o       (pc_to_Adder), //useless cause the branch adress is computed in ID phase
        .rd1_o      (rd1_MUX),
        .rd2_o      (rd2_MUX),
        .imm_o      (imm_MUX),//.ALUctrl_o  (ALU_ctrl),
        .ALUctrl_funct7_o  (funct7_to_out), //wire [6:0] funct7_to_out;
        .ALUctrl_funct3_o  (funct3_to_out), //wire [2:0] funct3_to_out;
        .wr_o       (wr_to_EX_MEM),
        .rs1_o      (rs1_FW_in), //wire [4:0] rs1_FW_in, rs2_FW_in;
        .rs2_o      (rs2_FW_in)
    );

    
    MUX32_4to1 FW_data0 (
        .select_i   (fw0),
        .data0_i    (rd1_MUX),
        .data1_i    (writeData_to_regFile),
        .data2_i    (res_to_DataMem_Addr),
        .data3_i    (),
        .data_o     (ALU_0)
    );

    MUX32_4to1 FW_data1 (
        .select_i   (fw1),
        .data0_i    (rd2_MUX),
        .data1_i    (writeData_to_regFile),
        .data2_i    (res_to_DataMem_Addr),
        .data3_i    (),
        .data_o     (ALU_1)
    );

    ForwardingUnit FW (
        .ID_EXrs1   (rs1_FW_in), 
        .ID_EXrs2   (rs2_FW_in), 
        .EX_MEMrd   (wr_to_MEM_WB), 
        .EX_MEMregWrite (RegWrite_to_mem_wb), 
        .MEM_WBrd       (wr_to_regFile), 
        .MEM_WBregWrite (RegWrite_out), 
        .FW0        (fw0), //wire [1:0] fw0, fw1;
        .FW1        (fw1)
    );

    ALU_control ALUcontrol (
        .ALUctrl_f7        (funct7_to_out),
        .ALUctrl_f3        (funct3_to_out),
        .ALUop          (ALUop_out), 
        .ALUctrl_lines  (ALUctrl_lines)
    );

    ALU alu (
        .data0      (ALU_0),
        .data1      (ALU_1),
        .ctrl       (ALUctrl_lines),
        .result     (result),
        .zeroFlag   (zeroFlag) //check ALU for the signal logic(if exists)
    );

    
    
    
    //-----------------------------------------------------MEM-------------------------------------------
    EX_MEM ex_mem (
        .clk        (clk), //.WB_i       (WB_to_EX_MEM), //.MEM_i      (MEM_to_EX_MEM),
        .ex_mem_RegWrite_i (RegWrite_to_ex_mem),
        .ex_mem_MemToReg_i (MemToReg_to_ex_mem),
        .ex_mem_Branch_i   (Branch_to_ex_mem),    
        .ex_mem_MemRead_i  (MemRead_to_ex_mem),
        .ex_mem_MemWrite_i (MemWrite_to_ex_mem),
        //.BA_i       (adder_res), //delete
        .FlagZero_i (zeroFlag),
        .ALUresult_i(result),
        .rd2_i      (rd2_MUX),
        .wr_i       (wr_to_EX_MEM),//.WB_o       (WB_to_MEM_WB),//.MEM_o      (MEM_out),
        .funct3_i    (funct3_to_out), //input for f3 
        .ex_mem_RegWrite_o (RegWrite_to_mem_wb), //wire RegWrite_to_mem_wb, MemToReg_to_mem_wb, Branch_out, MemRead_out, MemWrite_out;
        .ex_mem_MemToReg_o (MemToReg_to_mem_wb),
        .ex_mem_Branch_o   (Branch_out),    
        .ex_mem_MemRead_o  (MemRead_out),
        .ex_mem_MemWrite_o (MemWrite_out),
        //.BA_o       (branchAddr), //delete
        .FlagZero_o (zero_AND),
        .ALUresult_o(res_to_DataMem_Addr),
        .rd2_o      (rd2_to_DataMem_wd),
        .wr_o       (wr_to_MEM_WB),
        .funct3_o   (f3_to_dataMem)     //output for f3 , wire [2:0] f3_to_dataMem
    );

    

    DataMem dataMemory (
        .clk        (clk), 
        .addr       (res_to_DataMem_Addr), 
        .MemWrite   (MemWrite_out), 
        .MemRead    (MemRead_out), 
        .WriteData  (rd2_to_DataMem_wd),
        .funct3     (f3_to_dataMem),
        .ReadData   (DataMem_out)
    );


    //-----------------------------------------WB-----------------------------------------
    MEM_WB mem_wb (
        .clk            (clk), 
        .readMem_i      (DataMem_out), 
        .ALUresult_i    (res_to_DataMem_Addr), 
        .wr_i           (wr_to_MEM_WB), //.WB_i           (WB_to_MEM_WB),
        .mem_wb_RegWrite_i (RegWrite_to_mem_wb),
        .mem_wb_MemToReg_i (MemToReg_to_mem_wb), 
        .readMem_o      (Data_from_Mem), 
        .ALUresult_o    (ALUres_toMUX), 
        .wr_o           (wr_to_regFile), //.WB_o           (WB_out)
        .mem_wb_RegWrite_o (RegWrite_out), //wire RegWrite_out, MemToReg_out;
        .mem_wb_MemToReg_o (MemToReg_out)
    );

   
    MUX32_2to1 writeData_regFile (
        .select_i   (MemToReg_out),
        .data0_i    (ALUres_toMUX),
        .data1_i    (Data_from_Mem),
        .data_o     (writeData_to_regFile)
    );

endmodule