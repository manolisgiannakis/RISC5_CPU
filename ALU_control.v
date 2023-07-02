module ALU_control (ALUctrl_f7, ALUctrl_f3, ALUop, ALUctrl_lines);

    input [6:0] ALUctrl_f7; //funct7[9:3] + funct3[2:0]
    input [2:0] ALUctrl_f3;
    input [1:0] ALUop;
    output reg [3:0] ALUctrl_lines;


    always @(*) begin
        case(ALUop)
            2'b00 : begin
                case({ALUctrl_f3, ALUctrl_f7[5]})
                    4'b000x : begin //ADDI
                        ALUctrl_lines = 4'b0000;
                    end
                    4'b001x : begin //SLLI
                        ALUctrl_lines = 4'b0010;
                    end
                    4'b100x : begin //XORI
                        ALUctrl_lines = 4'b0011;
                    end
                    4'b101x : begin //SRLI
                        ALUctrl_lines = 4'b0100;
                    end
                    4'b101x : begin //SRAI
                        ALUctrl_lines = 4'b0101;
                    end
                    4'b110x : begin //ORI
                        ALUctrl_lines = 4'b0110;
                    end
                    4'b111x : begin //ANDI
                        ALUctrl_lines = 4'b0111;
                    end

                endcase
            end
            2'b01 : begin
                ALUctrl_lines = 4'b0000; //ADD
            end
            2'b10 : begin
                //ALUctrl_lines = (ALUctrl_f3[2]) ? 4'b0001 : 4'b0010;
                case({ALUctrl_f3, ALUctrl_f7[5], ALUctrl_f7[0]})
                    5'b00000 : begin //ADD
                        ALUctrl_lines = 4'b0000;
                    end
                    5'b00010 : begin //SUB
                        ALUctrl_lines = 4'b0001;
                    end
                    5'b00100 : begin //SLL
                        ALUctrl_lines = 4'b0010;
                    end
                    5'b10000 : begin //XOR
                        ALUctrl_lines = 4'b0011;
                    end
                    5'b10100 : begin //SRL
                        ALUctrl_lines = 4'b0100;
                    end
                    5'b10110 : begin //SRA
                        ALUctrl_lines = 4'b0101;
                    end
                    5'b11000 : begin //OR
                        ALUctrl_lines = 4'b0110;
                    end
                    5'b11100 : begin //AND
                        ALUctrl_lines = 4'b0111;
                    end
                    5'b00001 : begin //MUL
                        ALUctrl_lines = 4'b1110;
                    end
                    5'b00101 : begin //MULH
                        ALUctrl_lines = 4'b1111;
                    end



                endcase
            end
            2'b11 : begin //write a case with func3 input for the branch conditions
                case(ALUctrl_f3)
                    3'b000 : begin //equal,  BEQ
                        ALUctrl_lines = 4'b1100;
                    end
                    3'b001 : begin //not equal, BNE
                        ALUctrl_lines = 4'b1101;
                    end
                    3'b100 : begin // BLT
                        ALUctrl_lines = 4'b1000;
                    end
                    3'b101 : begin // BGE
                        ALUctrl_lines = 4'b1001;
                    end
                    3'b110 : begin // BLTU
                        ALUctrl_lines = 4'b1010;
                    end
                    3'b111 : begin // BGEU
                        ALUctrl_lines = 4'b1011;
                    end
                endcase
            end
        endcase
    end

endmodule