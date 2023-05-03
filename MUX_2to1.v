module MUX_2to1 (select_i, data0_i, data1_i, data_o);

    input data0_i, data1_i;
    input select_i;
    output reg data_o;

    always@(*) begin
        case(select_i)
            2'b0 : begin
                data_o <= data0_i;
            end
            2'b1 : begin
                data_o <= data1_i;
            end
        endcase
    end

endmodule