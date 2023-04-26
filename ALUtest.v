module ALUtest();
    reg [31:0] data0, data1;
    reg [3:0] ctrl;
    wire [31:0] result;
    wire zeroFlag;

    ALU testAlu (data0, data1, ctrl, result, zeroFlag);

    initial begin
        data0 <= 32'b1; data1 <= 32'b1; ctrl <= 0000;
    end

endmodule