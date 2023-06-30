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

    //------------------------Wires for datapath-----------------------------

    //---------IF
    wire [31:0] add4, branchAddr, mux_to_pc, pc_out, instMemOut;

    
    //---------ID
    wire [31:0] if_id_pc_o, if_id_inst_o, rd1_id_ex, rd2_id_ex, Immed;
    wire [1:0] ImmGenCtrl, ALUop;
    wire Branch, MemRead, MemWrite, RegWrite, MemToReg, ALUsrc;
    wire hazDetect_PC, hazDetect_IF_ID, reg_write, mem_write;
    wire regWrite_to_ID_EX, memWrite_to_ID_EX;
    


    //---------EX
    wire zeroFlag, ALUsrc_out, to_branchUnit, sel_mux_to_pc, IFreg_flush, IDreg_flush;
    wire [31:0] rd1_MUX, rd2_MUX, imm_MUX, branch_address, ALU_0, ALU_1, result, adder_res, ALU_2nd_in;
    wire [2:0] funct3_to_out;
    wire [6:0] funct7_to_out;
    wire [4:0] wr_to_EX_MEM, rs1_FW_in, rs2_FW_in;
    wire [1:0] ALUop_out;
    wire RegWrite_to_ex_mem, MemToReg_to_ex_mem, Branch_to_ex_mem, MemRead_to_ex_mem, MemWrite_to_ex_mem;
    wire [3:0] ALUctrl_lines;
    wire [1:0] fw0, fw1;


    //---------MEM
    wire zero_AND;
    wire RegWrite_to_mem_wb, MemToReg_to_mem_wb, Branch_out, MemRead_out, MemWrite_out;
    wire [31:0] res_to_DataMem_Addr, rd2_to_DataMem_wd, DataMem_out, Data_from_Mem, ALUres_toMUX;
    wire [4:0] wr_to_MEM_WB, wr_to_regFile;
    wire [2:0] f3_to_dataMem;


    //----------WB
    wire [31:0] writeData_to_regFile;
    wire RegWrite_out, MemToReg_out;


    //----------------------------------------------MODULES---------------------------------------------------    
    
    
    //IF
    PC pc (
        .clk        (clk),
        .reset      (reset),
        .pc_input   (mux_to_pc), //add4
        .hazDetect_PC (hazDetect_PC),
        .pc_output  (pc_out)
    );

    Adder32 PCadd4 (
        .data1   (pc_out),
        .data2   (32'd4),
        .data_o  (add4)
    );

    MUX32_2to1 pc_input_select (
        .select_i (sel_mux_to_pc), //1'b0
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
        .IF_Flush (IFreg_flush),
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


    HazardDetectUnit hazDetection (
        .ID_EXrd        (wr_to_EX_MEM),
        .IF_IDrs1       (if_id_inst_o[19:15]),
        .IF_IDrs2       (if_id_inst_o[24:20]),
        .ID_EXmemRead   (MemRead_to_ex_mem),
        .PCwrite        (hazDetect_PC), //wire hazDetect_PC, hazDetect_IF_ID, reg_write, mem_write;
        .IF_IDwrite     (hazDetect_IF_ID), 
        .regWrite       (reg_write), 
        .memWrite       (mem_write)
    );

    ControlUnit control (
        .opcode      (if_id_inst_o[6:0]),
        .ALUop       (ALUop),
        .Branch      (Branch), 
        .MemRead     (MemRead),
        .MemWrite    (MemWrite), 
        .RegWrite    (RegWrite),
        .MemToReg    (MemToReg),
        .ALUsrc      (ALUsrc)
    );

    MUX_2to1 regWrite (
        .select_i  (reg_write),
        .data0_i   (1'b0), 
        .data1_i   (RegWrite), 
        .data_o    (regWrite_to_ID_EX)
    );

    MUX_2to1 memWrite (
        .select_i  (mem_write), 
        .data0_i   (1'b0), 
        .data1_i   (MemWrite), 
        .data_o    (memWrite_to_ID_EX)
    );

    ImmGen immediates (
        .inst    (if_id_inst_o),
        .imm     (Immed)
    );

    Adder32 branchAddress (
        .data1   (Immed),
        .data2   (if_id_pc_o),
        .data_o  (adder_res)
    );


    //-----------------------------------------------------------EX---------------------------------------------------------------
    ID_EX id_ex (
        .clk        (clk),
        .ID_Flush   (IDreg_flush),
        .id_ex_RegWrite_i (RegWrite), 
        .id_ex_MemToReg_i (MemToReg),          
        .id_ex_Branch_i   (Branch),
        .id_ex_MemRead_i  (MemRead),
        .id_ex_MemWrite_i (MemWrite),
        .id_ex_ALUop_i    (ALUop),
        .id_ex_ALUsrc_i   (ALUsrc), 
        .branchAddr_i     (adder_res),
        .rd1_i      (rd1_id_ex),
        .rd2_i      (rd2_id_ex),
        .imm_i      (Immed),
        .ALUctrl_funct7_i  (if_id_inst_o[31:25]),
        .ALUctrl_funct3_i  (if_id_inst_o[14:12]),
        .wr_i       (if_id_inst_o[11:7]),
        .rs1_i      (if_id_inst_o[19:15]),
        .rs2_i      (if_id_inst_o[24:20]),
        .id_ex_RegWrite_o (RegWrite_to_ex_mem),
        .id_ex_MemToReg_o (MemToReg_to_ex_mem),
        .id_ex_Branch_o   (Branch_to_ex_mem),    
        .id_ex_MemRead_o  (MemRead_to_ex_mem),
        .id_ex_MemWrite_o (MemWrite_to_ex_mem),
        .id_ex_ALUop_o    (ALUop_out), 
        .id_ex_ALUsrc_o   (ALUsrc_out),
        .branchAddr_o     (branch_address), //branch_address
        .rd1_o      (rd1_MUX),
        .rd2_o      (rd2_MUX),
        .imm_o      (imm_MUX),
        .ALUctrl_funct7_o  (funct7_to_out), 
        .ALUctrl_funct3_o  (funct3_to_out), 
        .wr_o       (wr_to_EX_MEM),
        .rs1_o      (rs1_FW_in), 
        .rs2_o      (rs2_FW_in)
    );

    ForwardingUnit FW (
        .ID_EXrs1   (rs1_FW_in), 
        .ID_EXrs2   (rs2_FW_in), 
        .EX_MEMrd   (wr_to_MEM_WB), 
        .EX_MEMregWrite (RegWrite_to_mem_wb), 
        .MEM_WBrd       (wr_to_regFile), 
        .MEM_WBregWrite (RegWrite_out), 
        .FW0        (fw0), 
        .FW1        (fw1)
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

    MUX32_2to1 ALU_2nd_input (
        .select_i   (ALUsrc_out),
        .data0_i    (ALU_1),
        .data1_i    (imm_MUX),
        .data_o     (ALU_2nd_in)
    );

    ALU_control ALUcontrol (
        .ALUctrl_f7        (funct7_to_out),
        .ALUctrl_f3        (funct3_to_out),
        .ALUop          (ALUop_out), 
        .ALUctrl_lines  (ALUctrl_lines)
    );

    ALU alu (
        .data0      (ALU_0),
        .data1      (ALU_2nd_in),
        .ctrl       (ALUctrl_lines),
        .result     (result),
        .zeroFlag   (zeroFlag),
        .branch  (to_branchUnit) //wire to_branchUnit;
    );

    BranchUnit branch (
        .branch     (to_branchUnit),
        .mux_to_pc  (sel_mux_to_pc), //wire sel_mux_to_pc;
        .IF_Flush   (IFreg_flush), //wire IFreg_flush, IDreg_flush;
        .ID_Flush   (IDreg_flush)
    );

    

    
    
    
    //-----------------------------------------------------MEM-------------------------------------------
    EX_MEM ex_mem (
        .clk        (clk),
        .ex_mem_RegWrite_i (RegWrite_to_ex_mem),
        .ex_mem_MemToReg_i (MemToReg_to_ex_mem),
        .ex_mem_Branch_i   (Branch_to_ex_mem),    
        .ex_mem_MemRead_i  (MemRead_to_ex_mem),
        .ex_mem_MemWrite_i (MemWrite_to_ex_mem),
        .FlagZero_i (zeroFlag),
        .ALUresult_i(result),
        .rd2_i      (ALU_1),
        .wr_i       (wr_to_EX_MEM),
        .funct3_i    (funct3_to_out), //input for f3 
        .ex_mem_RegWrite_o (RegWrite_to_mem_wb), 
        .ex_mem_MemToReg_o (MemToReg_to_mem_wb),
        .ex_mem_Branch_o   (Branch_out),    
        .ex_mem_MemRead_o  (MemRead_out),
        .ex_mem_MemWrite_o (MemWrite_out),
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



    initial begin
        $monitor ("[$monitor_IF] time = %t, inst = %h, rs1_FW_in = %b, rs2_FW_in = %b, Alu_res = %h, wr_to_MEM_WB = %b, fw0 = %b, fw1 = %b", $time, instMemOut, rs1_FW_in, rs2_FW_in, result, wr_to_MEM_WB, fw0, fw1);
        //$monitor ("[$monitor] time = %t, RegWrite = %b, rs1_FW_in = %b, rs2_FW_in = %b, id_ex_RegWrite_o = %b, EX_MEMrd = %b, EX_MEMregWrite = %b, MEM_WBrd = %b, MEM_WBregWrite = %b, fw0 = %b, fw1 = %b", $time, RegWrite, rs1_FW_in, rs2_FW_in, RegWrite_to_ex_mem, wr_to_MEM_WB, RegWrite_to_mem_wb, wr_to_regFile, RegWrite_out, fw0, fw1);
    end

endmodule