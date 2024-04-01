module PipelineDatapath (clk, reset, mux_to_pc, instMemOut, rd1_id_ex, hazDetect_IF_ID, RegWrite_to_ex_mem, fw0, fw1, ALU_0, ALU_2nd_in, result, f3_to_dataMem, DataMem_out); // add outputs


    //------------------------------I/O ports---------------------------------
    input clk, reset;
    output [31:0] mux_to_pc, instMemOut, rd1_id_ex, ALU_0, ALU_2nd_in, result, DataMem_out;
    output [1:0] fw0, fw1;
    output [2:0] f3_to_dataMem;
    output hazDetect_IF_ID, RegWrite_to_ex_mem;
    //------------------------Wires for datapath-----------------------------

    //---IF
    wire [31:0] add4, branchAddr, mux_to_pc, pc_out, instMemOut, inst;
    wire [255:0] block_out;

    
    //---ID
    wire [31:0] if_id_pc_o, if_id_inst_o, if_id_pcPlusFour, rd1_id_ex, rd2_id_ex, Immed;
    wire [1:0] ImmGenCtrl, ALUop, MemToReg, Jump;
    wire Branch, MemRead, MemWrite, RegWrite, ALUsrc, LUIorAUIPC;
    wire hazDetect_PC, hazDetect_IF_ID, reg_write, mem_write;
    wire regWrite_to_ID_EX, memWrite_to_ID_EX;
    


    //---EX
    wire zeroFlag, ALUsrc_out, to_branchUnit, IFreg_flush, IDreg_flush;
    wire [31:0] rd1_MUX, rd2_MUX, imm_MUX, branch_address, ALU_0, ALU_1, result, adder_res;
    wire [31:0] ALU_2nd_in, id_ex_pcPlusFour, out_AND, id_ex_pc_out, pcPlusImm_U_type, Utype_res;
    wire [63:0] mul_res;
    wire [2:0] funct3_to_out;
    wire [6:0] funct7_to_out;
    wire [4:0] wr_to_EX_MEM, rs1_FW_in, rs2_FW_in;
    wire [1:0] ALUop_out, MemToReg_to_ex_mem, sel_mux_to_pc, jump_to_branchUnit;
    wire RegWrite_to_ex_mem, Branch_to_ex_mem, MemRead_to_ex_mem, MemWrite_to_ex_mem, LUIorAUIPC_to_mux;
    wire [3:0] ALUctrl_lines;
    wire [1:0] fw0, fw1;


    //---MEM
    wire zero_AND;
    wire [1:0] MemToReg_to_mem_wb;
    wire RegWrite_to_mem_wb, Branch_out, MemRead_out, MemWrite_out;
    wire [31:0] res_to_DataMem_Addr, rd2_to_DataMem_wd, DataMem_out, Data_from_Mem, ALUres_toMUX; 
    wire [31:0] ex_mem_pcPlusFour, ex_mem_Utype_res;
    wire [4:0] wr_to_MEM_WB, wr_to_regFile;
    wire [2:0] f3_to_dataMem;


    //---WB
    wire [31:0] writeData_to_regFile, mem_wb_pcPlusFour, mem_wb_Utype_res;
    wire [1:0] MemToReg_out;
    wire RegWrite_out;


    //----------------------------------------------MODULES---------------------------------------------------    
    
    
    //-------------------------------------------------IF-----------------------------------------------------
    PC pc (
        .clk        (clk),
        .reset      (reset),
        .pc_input   (mux_to_pc), //add4
        .hazDetect_PC (hazDetect_PC),
        .pc_output  (pc_out)
    );

    Adder32 PCadd4 (
        .data1   (pc_out),
        .data2   (32'd1), //4 when InstructionMem
        .data_o  (add4)
    );

    // MUX32_2to1 pc_input_select (
    //     .select_i (sel_mux_to_pc), //1'b0
    //     .data0_i  (add4),
    //     .data1_i  (branch_address), //adder_res
    //     .data_o   (mux_to_pc)
    // );

    MUX32_4to1 pc_input_select (
        .select_i   (sel_mux_to_pc),
        .data0_i    (add4),
        .data1_i    (branch_address),
        .data2_i    (out_AND),
        .data3_i    (),
        .data_o     (mux_to_pc)
    );

    InstCache instruction_cache (
        .clk    (clk),
        .addr   (pc_out),
        .reset  (reset),
        .inst   (instMemOut)
    );

    /* InstructionMem instMem (
        .clk    (clk),
        .addr   (pc_out),
        .reset  (reset),
        .inst   (instMemOut)
    ); */
    // INSTRUCTION MEM
    

    //--------------------------------------------------ID--------------------------------------------------
    IF_ID if_id (
        .clk    (clk),
        .hazDetect_IF_ID (hazDetect_IF_ID),
        .IF_Flush (IFreg_flush),
        .pcPlusFour_i (add4),
        .pc_i   (pc_out), 
        .inst_i (instMemOut),
        .pcPlusFour_o (if_id_pcPlusFour), //wire [31:0] if_id_pcPlusFour;
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
        .reset_haz      (reset),
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
        .MemRead     (MemRead),
        .MemWrite    (MemWrite), 
        .RegWrite    (RegWrite),
        .MemToReg    (MemToReg),
        .ALUsrc      (ALUsrc),
        .Jump        (Jump),
        .LUIorAUIPC  (LUIorAUIPC)
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


    //--------------------------------------------------------EX-------------------------------------------------------
    ID_EX id_ex (
        .clk        (clk),
        .ID_Flush   (IDreg_flush),
        .id_ex_LUIorAUIPC_i (LUIorAUIPC),
        .id_ex_Jump_i     (Jump),
        .id_ex_RegWrite_i (regWrite_to_ID_EX), 
        .id_ex_MemToReg_i (MemToReg),          
        .id_ex_MemRead_i  (MemRead),
        .id_ex_MemWrite_i (memWrite_to_ID_EX),
        .id_ex_ALUop_i    (ALUop),
        .id_ex_ALUsrc_i   (ALUsrc), 
        .branchAddr_i     (adder_res),
        .id_ex_pc_i       (if_id_pc_o),
        .id_ex_pcPlusFour_i (if_id_pcPlusFour),
        .rd1_i      (rd1_id_ex),
        .rd2_i      (rd2_id_ex),
        .imm_i      (Immed),
        .ALUctrl_funct7_i  (if_id_inst_o[31:25]),
        .ALUctrl_funct3_i  (if_id_inst_o[14:12]),
        .wr_i       (if_id_inst_o[11:7]),
        .rs1_i      (if_id_inst_o[19:15]),
        .rs2_i      (if_id_inst_o[24:20]),
        .id_ex_LUIorAUIPC_o (LUIorAUIPC_to_mux),
        .id_ex_Jump_o     (jump_to_branchUnit), 
        .id_ex_RegWrite_o (RegWrite_to_ex_mem),
        .id_ex_MemToReg_o (MemToReg_to_ex_mem),    
        .id_ex_MemRead_o  (MemRead_to_ex_mem),
        .id_ex_MemWrite_o (MemWrite_to_ex_mem),
        .id_ex_ALUop_o    (ALUop_out), 
        .id_ex_ALUsrc_o   (ALUsrc_out),
        .branchAddr_o     (branch_address), //branch_address
        .id_ex_pc_o       (id_ex_pc_out),
        .id_ex_pcPlusFour_o (id_ex_pcPlusFour), //wire [31:0] id_ex_pcPlusFour;
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
        .reset_fw (reset),
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
        .ALUop             (ALUop_out), 
        .ALUctrl_lines     (ALUctrl_lines)
    );

    ALU alu (
        .reset_alu  (reset),
        .data0      (ALU_0),
        .data1      (ALU_2nd_in),
        .ctrl       (ALUctrl_lines),
        .mul_res    (mul_res), //wire [63:0] mul_res;
        .result     (result),
        .zeroFlag   (zeroFlag),
        .branch     (to_branchUnit) //wire to_branchUnit;
    );

    Adder32 pcPlusImm_Utype (
        .data1   (id_ex_pc_out),
        .data2   (imm_MUX),
        .data_o  (pcPlusImm_U_type)
    );

    MUX32_2to1 LUIorAUIPC_mux (
        .select_i   (LUIorAUIPC_to_mux),
        .data0_i    (pcPlusImm_U_type),
        .data1_i    (imm_MUX),
        .data_o     (Utype_res)
    );

    BitwiseAnd AND_Bitwise (
        .data0      (result),
        .data1      (32'hFFFFFFFE),
        .out        (out_AND) //wire [31:0] out_AND;
    );

    BranchUnit branch (
        .clk        (clk),
        .reset_br   (reset),
        .jump       (jump_to_branchUnit),
        .branch     (to_branchUnit),
        .mux_to_pc  (sel_mux_to_pc), //wire sel_mux_to_pc;
        .IF_Flush   (IFreg_flush), //wire IFreg_flush, IDreg_flush;
        .ID_Flush   (IDreg_flush)
    );

    
    
    //---------------------------------------------------------MEM-----------------------------------------------------
    EX_MEM ex_mem (
        .clk        (clk),
        .ex_mem_RegWrite_i (RegWrite_to_ex_mem),
        .ex_mem_MemToReg_i (MemToReg_to_ex_mem),   
        .ex_mem_MemRead_i  (MemRead_to_ex_mem),
        .ex_mem_MemWrite_i (MemWrite_to_ex_mem),
        .ex_mem_pcPlusFour_i (id_ex_pcPlusFour),
        .ex_mem_Utype_res_i  (Utype_res),
        .ALUresult_i(result),
        .rd2_i      (ALU_1),
        .wr_i       (wr_to_EX_MEM),
        .funct3_i    (funct3_to_out), //input for f3 
        .ex_mem_RegWrite_o (RegWrite_to_mem_wb), 
        .ex_mem_MemToReg_o (MemToReg_to_mem_wb),    
        .ex_mem_MemRead_o  (MemRead_out),
        .ex_mem_MemWrite_o (MemWrite_out),
        .ex_mem_pcPlusFour_o (ex_mem_pcPlusFour), //ex_mem_pcPlusFour
        .ex_mem_Utype_res_o  (ex_mem_Utype_res),
        .ALUresult_o(res_to_DataMem_Addr),
        .rd2_o      (rd2_to_DataMem_wd),
        .wr_o       (wr_to_MEM_WB),
        .funct3_o   (f3_to_dataMem)     //output for f3 , wire [2:0] f3_to_dataMem
    );

    

    /* DataMem dataMemory (
        .clk        (clk), 
        .addr       (res_to_DataMem_Addr), 
        .MemWrite   (MemWrite_out), 
        .MemRead    (MemRead_out), 
        .WriteData  (rd2_to_DataMem_wd),
        .funct3     (f3_to_dataMem),
        .ReadData   (DataMem_out)
    ); */

    DataCache dataMemory (
        .clk           (clk), 
        .addr          (res_to_DataMem_Addr), 
        .MemWrite      (MemWrite_out), 
        .MemRead       (MemRead_out), 
        .WriteData     (rd2_to_DataMem_wd),
        .funct3        (f3_to_dataMem),
        .output_data   (DataMem_out)
    );


    //------------------------------------------------------WB-----------------------------------------------------
    MEM_WB mem_wb (
        .clk            (clk), 
        .readMem_i      (DataMem_out), 
        .ALUresult_i    (res_to_DataMem_Addr), 
        .wr_i           (wr_to_MEM_WB), //.WB_i           (WB_to_MEM_WB),
        .mem_wb_RegWrite_i (RegWrite_to_mem_wb),
        .mem_wb_MemToReg_i (MemToReg_to_mem_wb),
        .mem_wb_pcPlusFour_i (ex_mem_pcPlusFour),
        .mem_wb_Utype_res_i  (ex_mem_Utype_res),
        .readMem_o      (Data_from_Mem), 
        .ALUresult_o    (ALUres_toMUX), 
        .wr_o           (wr_to_regFile), //.WB_o           (WB_out)
        .mem_wb_RegWrite_o (RegWrite_out), //wire RegWrite_out, MemToReg_out;
        .mem_wb_MemToReg_o (MemToReg_out),
        .mem_wb_pcPlusFour_o (mem_wb_pcPlusFour), //mem_wb_pcPlusFour
        .mem_wb_Utype_res_o  (mem_wb_Utype_res)
    );

   
    // MUX32_4to1 writeData_regFile (
    //     .select_i   (MemToReg_out),
    //     .data0_i    (Data_from_Mem),
    //     .data1_i    (ALUres_toMUX),
    //     .data_o     (writeData_to_regFile)
    // );

    MUX32_4to1 writeData_regFile (
        .select_i   (MemToReg_out),
        .data0_i    (Data_from_Mem),
        .data1_i    (ALUres_toMUX),
        .data2_i    (mem_wb_pcPlusFour),
        .data3_i    (mem_wb_Utype_res),
        .data_o     (writeData_to_regFile)
    );


    initial begin
        //$monitor ("[$monitor_IF] time = %t, sel_mux_to_pc = %b, inst = %h, if_id_pc_o = %h, branch_address = %h, Alu_res = %h, branch = %h, IDreg_flush = %b", $time, sel_mux_to_pc, instMemOut, if_id_pc_o, branch_address, result, to_branchUnit, IDreg_flush);
        $monitor ("[$monitor_IF] time = %t, pc_out = %h, inst = %h, branchAddr = %h, rd1_id_ex = %h, hazDetect_IF_ID = %h, RegWrite_to_ex_mem = %h, fw0 = %b, fw1 = %b, data0 = %d, data1 = %d, Alu_res = %d, f3_to_dataMem = %b, res_to_DataMem_Addr = %h, DataMem_out = %h", $time, pc_out, instMemOut, adder_res, rd1_id_ex, hazDetect_IF_ID, RegWrite_to_ex_mem, fw0, fw1, ALU_0, ALU_2nd_in, result, f3_to_dataMem, res_to_DataMem_Addr, DataMem_out);
        //$monitor ("[$monitor] time = %t, rs1_FW_in = %b, rs2_FW_in = %b, Alu_res = %h, fw0 = %b, fw1 = %b", $time, rs1_FW_in, rs2_FW_in, result, fw0, fw1);

    end

endmodule