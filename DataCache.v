module DataCache (clk, addr, MemWrite, MemRead, WriteData, funct3, ReadData);
    input clk, MemRead, MemWrite;
    input [31:0] addr, WriteData;
    input [2:0] funct3;

    output reg [31:0] ReadData;

    //wire [19:0] tag = addr[31:12];
    //wire [6:0] index = addr[11:5];
    //wire [4:0] offset = addr[4:0];

    //cache modules, 4KBytes  INDEX_WIDTH = 7, TAG_WIDTH = 20, OFFSET_WIDTH = 5
    reg [19:0] tags [0:127];
    reg [7:0] data [0:127][0:31]; //4KBytes
    reg valid_bits [0:127];
    reg dirty_bits [0:127];


    initial begin
        $readmemh("tags.mem", tags);
        $readmemh("data.mem", data);
        $readmemb("valid_bits.mem", valid_bits, 0, 127);
    end
    

    /* always @(posedge clk) begin
        if ((valid_bits[addr[11:5]] == 1) && (tags[addr[11:5]] == addr[31:12])) begin //  
            //inst <= {data[addr[11:5]][addr[4:0]], data[addr[11:5]][addr[4:0]+1], data[addr[11:5]][addr[4:0]+2], data[addr[11:5]][addr[4:0]+3]}; //big endian
            inst <= {data[32][0], data[1][0]};
        end
        else begin
            inst <= 32'hFAFAFAFA;
        end
        
    end */

endmodule