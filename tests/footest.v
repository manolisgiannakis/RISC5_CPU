module footest();
    reg clk;
    reg [1:0] a,b;

    wire [3:0] c;

    foo test (clk, a, b, c);

    initial begin
        clk <= 0;
    end

    always #5 clk <= !clk;

    initial begin
        $monitor ("time = %t, c = %b", $time, c);
    end


endmodule