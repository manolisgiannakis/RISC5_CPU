module InstCache (clk, addr, reset, inst);
    input [31:0] addr;
    input clk, reset;
    
    output reg [31:0] inst;
    //output [31:0] inst;
    //wire [23:0] tag = addr[31:8];
    //wire [4:0] index = addr[7:3];
    //wire [2:0] offset = addr[2:0];

    wire [255:0] block;
    
    //output reg [31:0] inst2;
    //output reg [31:0] inst3;

    

    //cache modules, 4KBytes  TAG_WIDTH = 24, INDEX_WIDTH = 5, OFFSET_WIDTH = 3
    reg [23:0] tags [31:0];
    reg [255:0] data [31:0]; //1KByte
    reg valid_bits [31:0];


    initial begin
        $readmemh("tags.mem", tags);
        $readmemh("data.mem", data);
        $readmemb("valid_bits.mem", valid_bits, 0, 31);
    end
    
    assign block = data[addr[7:3]];

    always @(posedge clk) begin
        if ((valid_bits[addr[7:3]] == 1) && (tags[addr[7:3]] == addr[31:8])) begin
            //block <= {data[addr[7:3]]};
            case(addr[2:0])
                3'b000: begin
                    inst <= block[255:224];
                end
                3'b001: begin
                    inst <= block[223:192];
                end
                3'b010: begin
                    inst <= block[191:160];
                end
                3'b011: begin
                    inst <= block[159:128];
                end
                3'b100: begin
                    inst <= block[127:96];
                end
                3'b101: begin
                    inst <= block[95:64];
                end
                3'b110: begin
                    inst <= block[63:32];
                end
                3'b111: begin
                    inst <= block[31:0];
                end
            endcase
        end
        else begin
            inst <= 32'hF;
        end
    end

    /* MUX32_8to1 cache_mux (
        .select_i (addr[2:0]),
        .data0_i (block[255:224]),
        .data1_i (block[223:192]),
        .data2_i (block[191:160]),
        .data3_i (block[159:128]),
        .data4_i (block[127:96]),
        .data5_i (block[95:64]),
        .data6_i (block[63:32]),
        .data7_i (block[31:0]),
        .data_o  (inst)
    ); */

endmodule