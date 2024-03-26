module InstCacheTest();
    reg [31:0] addr;
    reg clk, reset;

    wire [31:0] inst;

    InstCache test (clk, addr, reset, inst);

    initial begin
        clk <= 0; addr <= 32'd0;
    end

    always #5 clk <= !clk;

    initial begin
        $monitor ("time = %t, inst = %h", $time, inst);
    end


endmodule