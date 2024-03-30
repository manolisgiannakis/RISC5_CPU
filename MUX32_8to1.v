module MUX32_8to1 (select_i, data0_i, data1_i, data2_i, data3_i, data4_i, data5_i, data6_i, data7_i, data_o);

    input [31:0] data0_i, data1_i, data2_i, data3_i, data4_i, data5_i, data6_i, data7_i;
    input [2:0] select_i;
    output reg [31:0] data_o;

    always@(*) begin
        case(select_i)
            3'b000 : begin
                data_o <= data0_i;
            end
            3'b001 : begin
                data_o <= data1_i;
            end
            3'b010 : begin
                data_o <= data2_i;
            end
            3'b011 : begin
                data_o <= data3_i;
            end
            3'b100 : begin
                data_o <= data4_i;
            end
            3'b101 : begin
                data_o <= data5_i;
            end
            3'b110 : begin
                data_o <= data6_i;
            end
            3'b111 : begin
                data_o <= data7_i;
            end
    endcase
    end

endmodule