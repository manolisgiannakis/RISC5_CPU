module ALU_control (ALUctrl_f7, ALUctrl_f3, ALUop, ALUctrl_lines);

    input [6:0] ALUctrl_f7; //funct7[9:3] + funct3[2:0]
    input [2:0] ALUctrl_f3;
    input [1:0] ALUop;
    output reg [3:0] ALUctrl_lines;


    always @(*) begin
        case(ALUop)
            2'b00 : begin
                case({ALUctrl_f3, ALUctrl_f7[5]})
                    4'b0000 : begin //ADDI
                        ALUctrl_lines <= 4'b0000;
                    end
                    4'b0001 : begin //ADDI
                        ALUctrl_lines <= 4'b0000;
                    end
                    4'b0010 : begin //SLLI
                        ALUctrl_lines <= 4'b0010;
                    end
                    4'b1000 : begin //XORI
                        ALUctrl_lines <= 4'b0011;
                    end
                    4'b1001 : begin //XORI
                        ALUctrl_lines <= 4'b0011;
                    end
                    4'b1010 : begin //SRLI
                        ALUctrl_lines <= 4'b0100;
                    end
                    4'b1011 : begin //SRAI
                        ALUctrl_lines <= 4'b0101;
                    end
                    4'b1100 : begin //ORI
                        ALUctrl_lines <= 4'b0110;
                    end
                    4'b1101 : begin //ORI
                        ALUctrl_lines <= 4'b0110;
                    end
                    4'b1110 : begin //ANDI
                        ALUctrl_lines <= 4'b0111;
                    end
                    4'b1111 : begin //ANDI
                        ALUctrl_lines <= 4'b0111;
                    end
                    4'b0100 : begin //SLTI
                        ALUctrl_lines <= 4'b1110;
                    end
                    4'b0101 : begin //SLTI
                        ALUctrl_lines <= 4'b1110;
                    end
                    4'b0110 : begin //SLTIU
                        ALUctrl_lines <= 4'b1111;
                    end
                    4'b0111 : begin //SLTIU
                        ALUctrl_lines <= 4'b1111;
                    end
                    default : begin
                        ALUctrl_lines <= 4'b0000;
                    end

                endcase
            end
            2'b01 : begin
                ALUctrl_lines <= 4'b0000; //ADD
            end
            2'b10 : begin
                //ALUctrl_lines = (ALUctrl_f3[2]) ? 4'b0001 : 4'b0010;
                case({ALUctrl_f3, ALUctrl_f7[5]})
                    4'b0000 : begin //ADD
                        ALUctrl_lines <= 4'b0000;
                    end
                    4'b0001 : begin //SUB
                        ALUctrl_lines <= 4'b0001;
                    end
                    4'b0010 : begin //SLL
                        ALUctrl_lines <= 4'b0010;
                    end
                    4'b1000 : begin //XOR
                        ALUctrl_lines <= 4'b0011;
                    end
                    4'b1010 : begin //SRL
                        ALUctrl_lines <= 4'b0100;
                    end
                    4'b1011 : begin //SRA
                        ALUctrl_lines <= 4'b0101;
                    end
                    4'b1100 : begin //OR
                        ALUctrl_lines <= 4'b0110;
                    end
                    4'b1110 : begin //AND
                        ALUctrl_lines <= 4'b0111;
                    end
                    4'b0100 : begin //SLT
                        ALUctrl_lines <= 4'b1110;
                    end
                    4'b0110 : begin //SLTU
                        ALUctrl_lines <= 4'b1111;
                    end
                    default : begin
                        ALUctrl_lines <= 4'b0000;
                    end
                endcase
            end
            2'b11 : begin //write a case with func3 input for the branch conditions
                case(ALUctrl_f3)
                    3'b000 : begin //equal,  BEQ
                        ALUctrl_lines <= 4'b1100;
                    end
                    3'b001 : begin //not equal, BNE
                        ALUctrl_lines <= 4'b1101;
                    end
                    3'b100 : begin // BLT
                        ALUctrl_lines <= 4'b1000;
                    end
                    3'b101 : begin // BGE
                        ALUctrl_lines <= 4'b1001;
                    end
                    3'b110 : begin // BLTU
                        ALUctrl_lines <= 4'b1010;
                    end
                    3'b111 : begin // BGEU
                        ALUctrl_lines <= 4'b1011;
                    end
                    default : begin
                        ALUctrl_lines <= 4'b0000;
                    end
                endcase
            end
        endcase
    end

endmodule