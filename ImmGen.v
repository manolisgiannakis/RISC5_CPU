/*this unit takes the 32-bit instruction and generates the immediate number*/
module ImmGen (inst, ctrl, imm);

    input [31:0] inst;
    input [1:0] ctrl;
    output reg [31:0] imm;


    always @(*) begin
        case(ctrl)

            2'b00 : begin
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31:20]}) : ({20'b00000000000000000000, inst[31:20]}); // I-type
            end
            2'b01 : begin
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31:25], inst[11:7]}) : ({20'b00000000000000000000, inst[31:25], inst[11:7]}); // S-type
            end
            2'b10 : begin
                imm = (inst[31]) ? ({20'b11111111111111111111, inst[31], inst[7], inst[30:25], inst[11:8]}) : ({20'b00000000000000000000, inst[31], inst[7], inst[30:25], inst[11:8]}); // B-type
            end
            2'b11 : begin
                imm = (inst[31]) ? ({12'b111111111111, inst[31:12]}) : ({12'b000000000000, inst[31:12]}); // U-type
            end

        endcase
    end

endmodule