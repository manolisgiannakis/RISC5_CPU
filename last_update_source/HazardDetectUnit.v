module HazardDetectUnit (reset_haz, ID_EXrd, IF_IDrs1, IF_IDrs2, ID_EXmemRead, PCwrite, IF_IDwrite, ID_EXwrite, regWrite, memWrite);
    
    input ID_EXmemRead, reset_haz;
    input [4:0] ID_EXrd, IF_IDrs1, IF_IDrs2;
    output reg PCwrite, IF_IDwrite, ID_EXwrite, regWrite, memWrite;
    //output reg [1:0] rs1_MUX, rs2_MUX;
    
    //for load-use sequences of instructions
    always @(reset_haz, ID_EXmemRead, ID_EXrd, IF_IDrs1, IF_IDrs2) begin //this reset signal for alu, hazdetect, forwardUnit, branchUnit is only for initialization purposes.
        if (reset_haz) begin
            PCwrite = 1;
            IF_IDwrite = 1;
            ID_EXwrite = 1;
            regWrite = 1;
            memWrite = 1;
        end
        else begin
            if ((ID_EXmemRead == 1) && ((ID_EXrd == IF_IDrs1) || (ID_EXrd == IF_IDrs2))) begin 
                PCwrite = 0;
                IF_IDwrite = 0;
                ID_EXwrite = 0;
                regWrite = 0;
                memWrite = 0;
            end
            else begin
                PCwrite = 1;
                IF_IDwrite = 1;
                ID_EXwrite = 1;
                regWrite = 1;
                memWrite = 1;
            end
        end
	end
    
endmodule