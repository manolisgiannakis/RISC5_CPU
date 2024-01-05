module InstructionMem (clk, addr, reset, inst);
    input [31:0] addr;
    input clk, reset;

    output reg [31:0] inst;

    //instruction memory
    reg [7:0] inst_memory [4095:0]; //4096 x 8bits, 4KBytes

    initial begin
        $readmemh("inst_memory.mem", inst_memory, 0, 4095);
    end

    always @(addr) begin
        inst <= {inst_memory[addr[11:0]], inst_memory[addr[11:0] + 1], inst_memory[addr[11:0] + 2], inst_memory[addr[11:0] + 3]}; //big endian
    end

endmodule