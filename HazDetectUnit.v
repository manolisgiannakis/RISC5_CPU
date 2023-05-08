module HazDetectUnit (ID_EXrd, IF_IDrs1, IF_IDrs2, branch, ID_EXmemRead, ID_EXregWrite, ID_EXmemToReg ,ID_EXmemWrite,
                rs1_MUX, rs2_MUX,
                PCwrite, IF_IDwrite, regWrite, memWrite);
    
    input ID_EXmemRead, branch, id_ex_RegWrite, id_ex_MemToReg, id_ex_MemRead;
    input [4:0] ID_EXrd, IF_IDrs1, IF_IDrs2;
    output reg PCwrite, IF_IDwrite, regWrite, memWrite;
    output reg [1:0] rs1_MUX, rs2_MUX;

    initial begin
        PCwrite = 1;
        IF_IDwrite = 1; 
        regWrite = 1;
        memWrite = 1;
    end
    
    //for load-use sequences of instructions
    always @(ID_EXmemRead, ID_EXrd, IF_IDrs1, IF_IDrs2) begin
        
        if ((ID_EXmemRead == 1) && ((ID_EXrd == IF_IDrs1) || (ID_EXrd == IF_IDrs2))) begin 
            PCwrite = 0;
            IF_IDwrite = 0;
            regWrite = 0;
            memWrite = 0;
        end
        else begin
            PCwrite = 1;
            IF_IDwrite = 1;
            regWrite = 1;
            memWrite = 1;
        end
	end

    initial begin
        rs1_MUX = 2'b00;
        rs2_MUX = 2'b00;
    end

    //for conditional branches, //control lines from id_ex because i want to know the previous instruction //this always block is for
    // ALU instruction before the Branch instruction and branch uses the register that the ALU inst is writing.
    always @(branch, ID_EXmemRead, ID_EXregWrite, ID_EXmemToReg, ID_EXmemWrite, ID_EXrd, IF_IDrs1, IF_IDrs2) begin
        if (branch == 1 && ID_EXmemRead == 0 && ID_EXregWrite == 1 && ID_EXmemToReg == 0 && ID_EXmemWrite == 0) begin
            if (ID_EXrd == IF_IDrs1) begin
                PCwrite = 0;
                IF_IDwrite = 0;
                regWrite = 0;
                memWrite = 0;
                rs1_MUX = 2'b01;
            end
            else if (ID_EXrd == IF_IDrs2) begin
                PCwrite = 0;
                IF_IDwrite = 0;
                regWrite = 0;
                memWrite = 0;
                rs2_MUX = 2'b01;
            end
            else begin
                rs1_MUX = 2'b00;
                rs2_MUX = 2'b00;
            end
        end
    end

    //this always block is for Load instruction before the Branch instruction and branch uses the register that the Load inst is writing.
    always @(branch, ID_EXmemRead, ID_EXregWrite, ID_EXmemToReg, ID_EXmemWrite, ID_EXrd, IF_IDrs1, IF_IDrs2) begin
        if (branch == 1 && ID_EXmemRead == 1 && ID_EXregWrite == 1 && ID_EXmemToReg == 1 && ID_EXmemWrite == 0) begin
            if (ID_EXrd == IF_IDrs1) begin
                PCwrite = 0;
                IF_IDwrite = 0; //false, i need a second stall cycle, not only one
                regWrite = 0;
                memWrite = 0;
                rs1_MUX = 2'b10;
            end
            else if (ID_EXrd == IF_IDrs2) begin
                PCwrite = 0;
                IF_IDwrite = 0;
                regWrite = 0;
                memWrite = 0;
                rs2_MUX = 2'b10;
            end
            else begin
                rs1_MUX = 2'b00;
                rs2_MUX = 2'b00;
            end
        end
    end

    
endmodule