module ControlUnit (opcode, ImmGenCtrl, ALUop, ALUsrc, Branch, MemRead, MemWrite, RegWrite, MemToReg);
    
    input [6:0] opcode;
    output reg [1:0] ALUop, ImmGenCtrl, ALUsrc; //ALUsrc -> {ALUsrc1, ALUsrc0}
    output reg Branch, MemRead, MemWrite, RegWrite, MemToReg;

    always @(*) begin
        case(opcode)
            7'b0000011 : begin //LOAD
                ImmGenCtrl = 2'b00;
                ALUop = 2'b01;
                ALUsrc = 2'b11;
                Branch = 1'b0;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b1;
            end

            7'b0100011 : begin //STORE
                ImmGenCtrl = 2'b01;
                ALUop = 2'b01;
                ALUsrc = 2'b11;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                RegWrite = 1'b0;
                MemToReg = 1'b1; //useless
            end

            7'b0110011 : begin //R-type(ADD, XOR)
                ImmGenCtrl = 2'b00; //useless
                ALUop = 2'b10;
                ALUsrc = 2'b01;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b1100011 : begin //Branch
                ImmGenCtrl = 2'b10;
                ALUop = 2'b01;
                ALUsrc = 2'b01;
                Branch = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b0;
                MemToReg = 1'b0; //useless
            end

            7'b0010011 : begin //Immediates
                ImmGenCtrl = 2'b00;
                ALUop = 2'b00;
                ALUsrc = 2'b11;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b0110111 : begin //LUI
                ImmGenCtrl = 2'b11;
                ALUop = 2'b11;
                ALUsrc = 2'b10;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b1100111 : begin //JALR //wrong values, TODO
                ImmGenCtrl = 2'b11;
                ALUop = 2'b11;
                ALUsrc = 2'b10;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            7'b1101111 : begin //JAL //wrong values, TODO
                ImmGenCtrl = 2'b11;
                ALUop = 2'b11;
                ALUsrc = 2'b10;
                Branch = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end
        endcase
    end



endmodule