/* */

module ALU (data0, data1, ctrl, result, zeroFlag);
  input [31:0] data0, data1;
  input [3:0] ctrl;
  output reg [31:0] result;
  output reg zeroFlag;


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

  endcase

  end

endmodule