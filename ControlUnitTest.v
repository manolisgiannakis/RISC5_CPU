module ControlUnitTest();
    reg [6:0] opcode;
    
    wire [1:0] ALUop;
    wire Branch, MemRead, MemWrite, RegWrite, MemToReg, ALUsrc;
    
    ControlUnit control (opcode, ALUop, Branch, MemRead, MemWrite, RegWrite, MemToReg, ALUsrc);

    initial begin
        #0 opcode <= 7'b0000011;
        #50 opcode <= 7'b0110011;
    end

endmodule