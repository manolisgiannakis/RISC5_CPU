/*this unit takes the 32-bit instruction and generates the immediate number*/
module ImmGen (inst, imm);

    input [31:0] inst;
    output reg [31:0] imm;


    always @(*) begin
        case(inst[6:0])

            7'b0010011 : begin //IMMEDIATES
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31:20]}) : ({20'b00000000000000000000, inst[31:20]}); // I-type
            end
            7'b0000011 : begin //LOAD
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31:20]}) : ({20'b00000000000000000000, inst[31:20]}); // I-type
            end
            7'b0100011 : begin
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31:25], inst[11:7]}) : ({20'b00000000000000000000, inst[31:25], inst[11:7]}); // S-type
            end
            7'b1100011 : begin
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31], inst[7], inst[30:25], inst[11:8]}) : ({20'b00000000000000000000, inst[31], inst[7], inst[30:25], inst[11:8]}); // B-type
            end
            7'b0110111 : begin
                imm = (inst[31]) ? ({12'b111111111111, inst[31:12]}) : ({12'b000000000000, inst[31:12]}); // U-type
            end
            default : begin
                imm = 32'bx;
            end


        endcase
    end

endmodule