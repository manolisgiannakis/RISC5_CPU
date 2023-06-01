module IF_ID (clk, hazDetect_IF_ID, IF_Flush, pc_i, inst_i, pc_o, inst_o);

input clk, hazDetect_IF_ID, IF_Flush;
input [31:0] pc_i, inst_i;
output reg [31:0] pc_o, inst_o;

always @(posedge clk) begin
    if(IF_Flush == 0) begin
        if(hazDetect_IF_ID) begin
            pc_o <= pc_i;
            inst_o <= inst_i;
        end
    end
    else begin
        pc_o <= 0;
        inst_o <= 0;
    end
end

endmodule
