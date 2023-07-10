module BitwiseAndTest();
    reg [31:0] data0, data1;
    
    wire [31:0] out;
    
    BitwiseAnd And (data0, data1, out);

    initial begin
        #0 data0 <= 32'b0101010; data1 <= 32'b1111000;
    end

endmodule