module InstMemTest();
    reg [31:0] addr;
    reg reset;

    wire [31:0] inst;

    InstructionMem test (addr, reset, inst);

    initial begin
        addr <= 32'b0; reset <= 0;
    end

    initial begin
        $monitor ("time = %t, inst = %b", $time, inst);
    end


endmodule