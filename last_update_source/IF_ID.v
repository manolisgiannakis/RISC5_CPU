module IF_ID (clk, hazDetect_IF_ID, IF_Flush, pcPlusFour_i, pc_i, inst_i, pcPlusFour_o, pc_o, inst_o);

input clk, hazDetect_IF_ID, IF_Flush;
input [31:0] pcPlusFour_i, pc_i, inst_i;
output reg [31:0] pcPlusFour_o, pc_o, inst_o;

always @(negedge clk) begin
    if(IF_Flush == 0) begin
        if(hazDetect_IF_ID) begin
            pcPlusFour_o <= pcPlusFour_i;
            pc_o <= pc_i;
            inst_o <= inst_i;
        end
    end
    else begin
        pcPlusFour_o <= 0;
        pc_o <= 0;
        inst_o <= 0;
    end
end

endmodule
