module InstCache (clk, addr, reset, inst);
    input [31:0] addr;
    input clk, reset;

    //wire [19:0] tag = addr[31:12];
    //wire [6:0] index = addr[11:5];
    //wire [4:0] offset = addr[4:0];

    output reg [31:0] inst;

    //cache modules, 4KBytes  INDEX_WIDTH = 7, TAG_WIDTH = 20, OFFSET_WIDTH = 5
    reg [19:0] tags [0:127];
    reg [7:0] data [0:127][0:31]; //4KBytes
    reg valid_bits [0:127];

    initial begin
        data[0][0] <= 8'h00; data[0][1] <= 8'h00; data[0][2] <= 8'h00; data[0][3] <= 8'h00;
        data[0][4] <= 8'h00; data[0][5] <= 8'h00; data[0][6] <= 8'h00; data[0][7] <= 8'h00;
        data[0][8] <= 8'h00; data[0][9] <= 8'h00; data[0][10] <= 8'h00; data[0][11] <= 8'h00;
        data[0][12] <= 8'h00; data[0][13] <= 8'h00; data[0][14] <= 8'h00; data[0][15] <= 8'h00;
        data[0][16] <= 8'h00; data[0][17] <= 8'h00; data[0][18] <= 8'h00; data[0][19] <= 8'h00;
    end

    initial begin
        $readmemh("tags.mem", tags);
        $readmemh("data.mem", data);
        $readmemb("valid_bits.mem", valid_bits, 0, 127);
    end
    

    always @(posedge clk) begin
        if ((valid_bits[addr[11:5]] == 1) && (tags[addr[11:5]] == addr[31:12])) begin //  
            //inst <= {data[addr[11:5]][addr[4:0]], data[addr[11:5]][addr[4:0]+1], data[addr[11:5]][addr[4:0]+2], data[addr[11:5]][addr[4:0]+3]}; //big endian
            inst <= {data[32][0], data[1][0]};
        end
        else begin
            inst <= 32'hFAFAFAFA;
        end
        
    end

endmodule