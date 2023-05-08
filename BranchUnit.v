module BranchUnit (instr, rs1, rs2, mux_to_pc);

input [31:0] rs1, rs2, instr;
output reg mux_to_pc;


initial 
    mux_to_pc = 0;

always @(posedge clk) begin
    case ({instr[14:12], instr[6:0]})
        10'b0001100011 : begin // BEQ
            mux_to_pc <= (rs1 == rs2) ? 1 : 0; 
        end  
        10'b0011100011 : begin // BNE
            mux_to_pc <= (rs1 != rs2) ? 1 : 0; 
        end   
        10'b1001100011 : begin // BLT
            mux_to_pc <= ($signed(rs1) <  $signed(rs2)) ? 1 : 0; 
        end  
        10'b1011100011 : begin // BGE
            mux_to_pc <= ($signed(rs1) >= $signed(rs2)) ? 1 : 0; 
        end   
        10'b1101100011 : begin // BLTU
            mux_to_pc <= (rs1 <  rs2) ? 1 : 0; 
        end  
        10'b1111100011 : begin // BGEU
            mux_to_pc <= (rs1 >= rs2) ? 1 : 0;
        end   
        10'bxxx1101111 : begin // JAL
            mux_to_pc <= 1;
        end
        10'b0001100111 : begin // JALR
            mux_to_pc <= 1;
        end
    endcase
end

endmodule