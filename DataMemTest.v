module DataMemTest();
    reg clk, MemRead, MemWrite;
    reg [31:0] addr, WriteData;

    wire [31:0] ReadData;

    DataMem test (clk, addr, MemWrite, MemRead, WriteData, ReadData);

    initial begin
        addr <= 32'b0; MemWrite <= 1; MemRead <= 0; WriteData <= 32'hFF;
    end

    //initial begin
        //$monitor ("time = %t, inst = %b", $time);
    //end
endmodule