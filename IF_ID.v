module IF_ID (clk, hazDetect_IF_ID, pc_i, inst_i, pc_o, inst_o);

input clk, hazDetect_IF_ID;
input [31:0] pc_i, inst_i;
output reg [31:0] pc_o, inst_o;

always @(posedge clk) begin
    if(hazDetect_IF_ID) begin
        pc_o <= pc_i;
        inst_o <= inst_i;
    end
end

endmodule
