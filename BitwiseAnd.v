module BitwiseAnd (data0, data1, out);

    input [31:0] data0, data1;
    output reg [31:0] out;

    always @(*) begin
        out = data0 & data1;
    end


endmodule