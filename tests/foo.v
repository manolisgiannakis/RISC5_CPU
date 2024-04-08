module foo(clk, a, b, c);
    input clk;
    input [1:0] a, b;
    output reg [3:0] c;

    initial begin
        c <= 4'b1001;
    end

    always @(posedge clk) begin
        c[0] = 0;
    end

endmodule