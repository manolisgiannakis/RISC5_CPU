module BranchUnit (branch, mux_to_pc, IF_Flush, ID_Flush);

input branch;
output reg mux_to_pc, IF_Flush, ID_Flush;

initial begin
    mux_to_pc <= 0;
    IF_Flush <= 0;
    ID_Flush <= 0;
end

always @(branch) begin
    if(branch) begin
        mux_to_pc <= 1;
        IF_Flush <= 1;
        ID_Flush <= 1;
    end
    else begin
        mux_to_pc <= 0;
        IF_Flush <= 0;
        ID_Flush <= 0;
    end

end

endmodule