/* */

module ALU (data0, data1, ctrl, mul_res, result, zeroFlag, branch);
  input [31:0] data0, data1;
  input [3:0] ctrl;
  output reg [63:0] mul_res;
  output reg [31:0] result;
  output reg zeroFlag;
  output reg branch;

  initial begin
    branch = 0;
  end


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
      4'b1100 : begin //BEQ // for branch-> 1: branch adress, 0: addr + 4.
        branch = (zeroFlag) ? 1 : 0;
      end
      4'b1101 : begin //BNE
        branch = (zeroFlag) ? 0 : 1;
      end
      4'b1000 : begin //BLT
        branch = ($signed(data0) <  $signed(data1)) ? 1 : 0;
      end
      4'b1001 : begin //BGE
        branch = ($signed(data0) >= $signed(data1)) ? 1 : 0;
      end
      4'b1010 : begin //BLTU
        branch = (data0 <  data1) ? 1 : 0;
      end
      4'b1011 : begin //BGEU
        branch = (data0 >= data1) ? 1 : 0;
      end
      4'b1110 : begin //MUL
        mul_res = data0 * data1;
        result = mul_res[31:0];
      end
      4'b1111 : begin //MULH
        mul_res = data0 * data1;
        result = mul_res[63:32];
      end             

  endcase

  end

endmodule