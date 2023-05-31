module BranchUnit (branch, mux_to_pc, IF_Flush, ID_Flush);

input branch;
output reg mux_to_pc, IF_Flush, ID_Flush;

initial begin
    mux_to_pc <= 0;
    IF-Flush <= 0;
    ID-Flush <= 0;
end

always @(branch) begin
    if(branch) begin
        mux_to_pc <= 1;
        IF-Flush <= 1;
        ID-Flush <= 1;
    end
    else begin
        mux_to_pc <= 0;
        IF-Flush <= 0;
        ID-Flush <= 0;
    end

end

endmodule