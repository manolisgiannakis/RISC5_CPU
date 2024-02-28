module MUX32_4to1 (select_i, data0_i, data1_i, data2_i, data3_i, data_o);

    input [31:0] data0_i, data1_i, data2_i, data3_i;
    input [1:0] select_i;
    output reg [31:0] data_o;

    always@(*) begin
        case(select_i)
            2'b00 : begin
                data_o <= data0_i;
            end
            2'b01 : begin
                data_o <= data1_i;
            end
            2'b10 : begin
                data_o <= data2_i;
            end
            2'b11 : begin
                data_o <= data3_i;
            end
    endcase
    end

endmodule