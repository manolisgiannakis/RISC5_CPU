module DataCacheTest();
    reg clk, MemRead, MemWrite;
    reg [31:0] addr, WriteData;
    reg [2:0] funct3;

    wire [31:0] output_data;

    DataCache test (clk, addr, MemWrite, MemRead, WriteData, funct3, output_data);

    initial begin
        clk <= 0; addr <= 32'h00000000; MemWrite <= 1'b0; MemRead <= 1'b1; funct3 <= 3'b000;

    end

    always #5 clk <= !clk;

    initial begin
        $monitor ("time = %t, output_data = %h", $time, output_data);
    end


endmodule