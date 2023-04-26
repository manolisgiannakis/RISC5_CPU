module DataMem (clk, addr, MemWrite, MemRead, WriteData, funct3, ReadData);
    input clk, MemRead, MemWrite;
    input [31:0] addr, WriteData;
    input [2:0] funct3;

    output reg [31:0] ReadData;

    //data memory
    reg [7:0] data_memory [4095:0]; //4096 x 8bits, 4KBytes

    //assign ReadData = (MemRead) ? {data_memory[addr[11:0]+3], data_memory[addr[11:0]+2], data_memory[addr[11:0]+1], data_memory[addr[11:0]]} : 32'hFF;

    always @(posedge clk) begin

        if(MemWrite) begin //STORE
            case(funct3)
                3'b000 : begin //store byte
                    data_memory[addr[11:0]]     <= WriteData[7:0];
                end

                3'b001 : begin //store half
                    data_memory[addr[11:0] + 1] <= WriteData[15:8];
                    data_memory[addr[11:0]]     <= WriteData[7:0];
                end

                3'b010 : begin //store word
                    data_memory[addr[11:0] + 3] <= WriteData[31:24];
                    data_memory[addr[11:0] + 2] <= WriteData[23:16];
                    data_memory[addr[11:0] + 1] <= WriteData[15:8];
                    data_memory[addr[11:0]]     <= WriteData[7:0];
                end
            endcase
        end
        else begin
            case(funct3)
                3'b000 : begin //load byte
                    ReadData <= $signed(data_memory[addr[11:0]]);
                end

                3'b001 : begin //load half
                    ReadData <= $signed({data_memory[addr[11:0]+1], data_memory[addr[11:0]]});
                end

                3'b010 : begin //load word
                    ReadData <= {data_memory[addr[11:0]+3], data_memory[addr[11:0]+2], data_memory[addr[11:0]+1], data_memory[addr[11:0]]};
                end

                3'b100 : begin //load byte unsigned
                    ReadData <= data_memory[addr[11:0]];
                end

                3'b101 : begin //load half unsigned
                    ReadData <= {data_memory[addr[11:0]+1], data_memory[addr[11:0]]};
                end
            endcase
        end



    end

endmodule