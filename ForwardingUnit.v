module ForwardingUnit (ID_EXrs1, ID_EXrs2, EX_MEMrd, EX_MEMregWrite, MEM_WBrd, MEM_WBregWrite, FW0, FW1);
    
    input EX_MEMregWrite, MEM_WBregWrite;
    input [4:0] ID_EXrs1, ID_EXrs2, EX_MEMrd, MEM_WBrd;
    output reg [1:0] FW0, FW1;

    initial begin
        FW0 = 2'b00;
        FW1 = 2'b00;
    end

    always @(ID_EXrs1, EX_MEMrd, EX_MEMregWrite, MEM_WBregWrite, MEM_WBrd) begin
        
        if ( EX_MEMregWrite && (EX_MEMrd != 0) && (EX_MEMrd == ID_EXrs1) ) //EX_MEMrd != 0 because want to avoid forwarding its possibly nonzero result value to x0. x0 is must always be equal to 0 in RISC5.
            begin
                FW0 = 2'b10;
            end
        else if ( MEM_WBregWrite && (MEM_WBrd != 0) 
                  && !(EX_MEMregWrite && (EX_MEMrd != 0) && (EX_MEMrd == ID_EXrs1)) 
                  && (MEM_WBrd == ID_EXrs1) ) 
            begin
                FW0 = 2'b01;
            end
        else 
            begin
                FW0 = 2'b00;
            end
	end

    always @(ID_EXrs2, EX_MEMrd, EX_MEMregWrite, MEM_WBregWrite, MEM_WBrd) begin
        
        if ( EX_MEMregWrite && (EX_MEMrd != 0) && (EX_MEMrd == ID_EXrs2) ) 
            begin
                FW1 = 2'b10;
            end
        else if ( MEM_WBregWrite && (MEM_WBrd != 0)
                  && !(EX_MEMregWrite && (EX_MEMrd != 0) && (EX_MEMrd == ID_EXrs2))
                  && (MEM_WBrd == ID_EXrs2) ) 
            begin
                FW1 = 2'b01;
            end
        else 
            begin
                FW1 = 2'b00;
            end
	end

    
endmodule