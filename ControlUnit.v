module ControlUnit (opcode, ALUop, MemRead, MemWrite, RegWrite, MemToReg, ALUsrc, Jump, LUIorAUIPC);
    
    input [6:0] opcode;
    output reg [1:0] ALUop, MemToReg, Jump;
    output reg MemRead, MemWrite, RegWrite, ALUsrc, LUIorAUIPC;

    always @(opcode) begin
        case(opcode)
            7'b0000011 : begin //LOAD
                LUIorAUIPC <= 1'b0; //useless
                Jump <= 2'b00;
                ALUop <= 2'b01;
                ALUsrc <= 1'b1; 
                MemRead <= 1'b1;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b00;
            end

            7'b0100011 : begin //STORE
                LUIorAUIPC <= 1'b0; //useless
                Jump <= 2'b00;
                ALUop <= 2'b01; 
                ALUsrc <= 1'b1; 
                MemRead <= 1'b0; 
                MemWrite <= 1'b1; 
                RegWrite <= 1'b0; 
                MemToReg <= 2'b00; //useless
            end

            7'b0110011 : begin //R-type
                LUIorAUIPC <= 1'bx; //useless
                Jump <= 2'b00;
                ALUop <= 2'b10;
                ALUsrc <= 1'b0;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b01;
            end

            7'b1100011 : begin //Branch
                LUIorAUIPC <= 1'b0; //useless
                Jump <= 2'b00; //useless
                ALUop <= 2'b11;
                ALUsrc <= 1'b0;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                MemToReg <= 2'b00; //useless
            end

            7'b0010011 : begin //Immediates
                LUIorAUIPC <= 1'b0; //useless
                Jump <= 2'b00;
                ALUop <= 2'b00;
                ALUsrc <= 1'b1;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b01;
            end

            7'b0110111 : begin //LUI
                LUIorAUIPC <= 1'b1;
                Jump <= 2'b00; //useless
                ALUop <= 2'b00; //useless
                ALUsrc <= 2'b0; //useless
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b11;
            end

            7'b0010111 : begin //AUIPC
                LUIorAUIPC <= 1'b0;
                Jump <= 2'b00; //useless
                ALUop <= 2'b00; //useless
                ALUsrc <= 2'b0; //useless
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b11;
            end

            7'b1100111 : begin //JALR
                LUIorAUIPC <= 1'b0; //useless
                Jump <= 2'b10;
                ALUop <= 2'b01;
                ALUsrc <= 2'b1;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b10;
            end

            7'b1101111 : begin //JAL
                LUIorAUIPC <= 1'b0; //useless
                Jump <= 2'b01;
                ALUop <= 2'b01; //useless
                ALUsrc <= 2'b1; //useless
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemToReg <= 2'b10;
            end

            default : begin
                LUIorAUIPC <= 1'b0;
                Jump <= 2'b00;
                ALUop <= 2'b00;
                ALUsrc <= 2'b0;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                MemToReg <= 2'b00;
            end
        endcase
    end



endmodule