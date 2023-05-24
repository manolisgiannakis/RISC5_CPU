/* */

module ALU (data0, data1, ctrl, result, zeroFlag, mux_to_pc);
  input [31:0] data0, data1;
  input [3:0] ctrl;
  output reg [31:0] result;
  output reg zeroFlag;
  output reg mux_to_pc;


  always@(*)
  begin
    zeroFlag = (data0 - data1) ? 0 : 1;
    case(ctrl)
      //4'b0011 : begin //shift left logical
      //  result = data1 << data0; // not data0 << data1 because i want 12 bit shift in my immediate, so data1 is my immediate and data0 is 12.
      //end

      4'b0000 : begin //ADD
        result = data0 + data1;
      end
      4'b0001 : begin //SUB
        result = data0 - data1;
      end
      4'b0010 : begin //SLL
        result = data0 << data1[4:0];
      end
      4'b0011 : begin //XOR
        result = data0 ^ data1;
      end
      4'b0100 : begin //SRL
        result = data0 >> data1[4:0];
      end
      4'b0101 : begin //SRA
        result = data0 >>> data1[4:0];
      end
      4'b0110 : begin //OR
        result = data0 | data1;
      end
      4'b0111 : begin //AND
        result = data0 & data1;
      end
      4'b1100 : begin //BEQ // for mux_to_pc-> 1: branch adress, 0: addr + 4.
        mux_to_pc = (zeroFlag) ? 1 : 0;
      end
      4'b1101 : begin //BNE
        mux_to_pc = (zeroFlag) ? 0 : 1;
      end
      4'b1000 : begin //BLT
        mux_to_pc = ($signed(data0) <  $signed(data1)) ? 1 : 0;
      end
      4'b1001 : begin //BGE
        mux_to_pc = ($signed(data0) >= $signed(data1)) ? 1 : 0;
      end
      4'b1010 : begin //BLTU
        mux_to_pc = (data0 <  data1) ? 1 : 0;
      end
      4'b1011 : begin //BGEU
        mux_to_pc = (data0 >= data1) ? 1 : 0;
      end             

  endcase

  end

endmodule