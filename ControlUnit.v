module ControlUnit (opcode, ALUop, Branch, MemRead, MemWrite, RegWrite, MemToReg, ALUsrc);
    
    input [6:0] opcode;
    output reg [1:0] ALUop;
    output reg Branch, MemRead, MemWrite, RegWrite, MemToReg, ALUsrc;

    always @(opcode) begin
        case(opcode)
            7'b0000011 : begin //LOAD
                ALUop = 2'b01;
                ALUsrc = 1'b1; //fix all of them
                Branch = 1'b0; //might be useless...........................
                MemRead = 1'b1;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b1; //WB
            end

            7'b0100011 : begin //STORE
                ALUop = 2'b01; //EX
                ALUsrc = 1'b1; //EX
                Branch = 1'b0;
                MemRead = 1'b0; //MEM
                MemWrite = 1'b1; //MEM
                RegWrite = 1'b0; //WB
                MemToReg = 1'bx; //useless //WB
            end

            7'b0110011 : begin //R-type(ADD, XOR)
                ALUop = 2'b10;
                ALUsrc = 1'b0;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b1100011 : begin //Branch
                ALUop = 2'b11;
                ALUsrc = 1'b0; 
                Branch = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b0;
                MemToReg = 1'bx; //useless
            end

            7'b0010011 : begin //Immediates
                ALUop = 2'b00;
                ALUsrc = 1'b1;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b0110111 : begin //LUI
                ALUop = 2'b11;
                ALUsrc = 2'b0;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b1100111 : begin //JALR //wrong values, TODO
                ALUop = 2'b11;
                ALUsrc = 2'b0;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b1101111 : begin //JAL //wrong values, TODO
                ALUop = 2'b11;
                ALUsrc = 2'b0;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end
        endcase
    end



endmodule