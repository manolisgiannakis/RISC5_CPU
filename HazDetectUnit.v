module HazDetectUnit (ID_EXmemRead, ID_EXrd, IF_IDrs1, IF_IDrs2, PCwrite, IF_IDwrite, regWrite, memWrite);
    
    input ID_EXmemRead;
    input [4:0] ID_EXrd, IF_IDrs1, IF_IDrs2;
    output reg PCwrite, IF_IDwrite, regWrite, memWrite;

    initial begin
        PCwrite = 1;
        IF_IDwrite = 1;
        regWrite = 1;
        memWrite = 1;
    end

    always @(ID_EXmemRead, ID_EXrd, IF_IDrs1, IF_IDrs2) begin
        
        if ((ID_EXmemRead == 1) && ((ID_EXrd == IF_IDrs1) || (ID_EXrd == IF_IDrs2))) begin //for load-use 
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

    
endmodule