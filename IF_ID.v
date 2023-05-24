module IF_ID (clk, pc_i, inst_i, pc_o, inst_o);

input clk;
input [31:0] pc_i, inst_i;
output reg [31:0] pc_o, inst_o;

always @(posedge clk) begin
    // if(hazDetect_IF_ID) begin
    //     pc_o <= pc_i;
    //     inst_o <= inst_i;
    // end
    pc_o <= pc_i;
        inst_o <= inst_i;
end

endmodule
