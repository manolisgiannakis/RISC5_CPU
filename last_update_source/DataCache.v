module DataCache (clk, addr, MemWrite, MemRead, WriteData, funct3, output_data);
    input clk, MemRead, MemWrite;
    input [31:0] addr, WriteData;
    input [2:0] funct3;

    output reg [31:0] output_data;
    
    reg [31:0] ReadData;
    
    wire [255:0] block;
    wire [31:0] DataOut;

    //wire [19:0] tag = addr[31:12];
    //wire [6:0] index = addr[11:5];
    //wire [4:0] offset = addr[4:0];

    //cache modules, 1KByte  TAG_WIDTH = 24, INDEX_WIDTH = 5, OFFSET_WIDTH = 3
    reg [23:0] tags [31:0];
    reg [255:0] data [31:0]; //1KByte
    reg valid_bits [31:0];
    reg dirty_bits [31:0];


    initial begin
        $readmemh("tags.mem", tags, 0, 31);
        $readmemh("cacheData.mem", data, 0, 31);
        $readmemb("valid_bits.mem", valid_bits, 0, 31);
        $readmemb("dirty_bits.mem", dirty_bits, 0, 31);
    end
    
    assign block = data[addr[7:3]];
    //assign start_addr = 


    always @(posedge clk) begin
        if ((MemRead == 1) && (valid_bits[addr[7:3]] == 1) && (tags[addr[7:3]] == addr[31:8])) begin  
            case(addr[2:0])
                3'b000: begin
                    ReadData <= block[255:224];
                end
                3'b001: begin
                    ReadData <= block[223:192];
                end
                3'b010: begin
                    ReadData <= block[191:160];
                end
                3'b011: begin
                    ReadData <= block[159:128];
                end
                3'b100: begin
                    ReadData <= block[127:96];
                end
                3'b101: begin
                    ReadData <= block[95:64];
                end
                3'b110: begin
                    ReadData <= block[63:32];
                end
                3'b111: begin
                    ReadData <= block[31:0];
                end
            endcase          
        end
        else if (MemWrite == 1) begin
            case(addr[2:0])
                3'b000: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][231:224] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][239:224] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][255:224] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b001: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][199:192] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][207:192] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][223:192] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b010: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][167:160] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][175:160] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][191:160] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b011: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][135:128] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][143:128] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][159:128] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b100: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][103:96] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][111:96] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][127:96] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b101: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][71:64] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][79:64] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][95:64] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b110: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][39:32] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][47:32] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][63:32] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
                3'b111: begin
                    case(funct3[1:0])
                        2'b00 : begin //store byte
                            data[addr[7:3]][7:0] <= WriteData[7:0];
                        end
                        2'b01 : begin //store half
                            data[addr[7:3]][15:0] <= WriteData[15:0];
                        end
                        2'b10 : begin //store word
                            data[addr[7:3]][31:0] <= WriteData[31:0];
                        end
                        2'b11 : begin
                                
                        end
                    endcase
                end
            endcase
        end
        else begin
            ReadData <= 32'hFAFAFAFA;
        end
        
    end

    assign DataOut = ReadData;

    always @(DataOut) begin
        case(funct3)
                3'b000: begin //load byte
                    output_data <= $signed(DataOut[7:0]);
                end
                3'b001: begin //load half
                    output_data <= $signed(DataOut[15:0]);
                end
                3'b010: begin //load word
                    output_data <= DataOut[31:0];
                end
                3'b100: begin //load byte unsigned
                    output_data <= DataOut[7:0];
                end
                3'b101: begin //load half unsigned
                    output_data <= DataOut[15:0];
                end
                default : begin
                        
                end
            endcase
    end

endmodule