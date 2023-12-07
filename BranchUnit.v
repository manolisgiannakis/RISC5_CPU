module BranchUnit (reset_br, jump, branch, mux_to_pc, IF_Flush, ID_Flush);

input branch, reset_br;
input [1:0] jump;
output reg IF_Flush, ID_Flush;
output reg [1:0] mux_to_pc;

// initial begin
//     mux_to_pc <= 2'b00;
//     IF_Flush <= 0;
//     ID_Flush <= 0;
// end


//handling the occurence of load-use sequence after a conditional branch.
always @(reset_br, branch, jump) begin
    if (reset_br) begin
        mux_to_pc <= 2'b00;
        IF_Flush <= 0;
        ID_Flush <= 0;
    end
    else begin
        if (branch) begin
            mux_to_pc <= 2'b01;
            IF_Flush <= 1;
            ID_Flush <= 1;
        end
        else begin
            if (jump == 2'b00) begin
                mux_to_pc <= 2'b00;
                IF_Flush <= 0;
                ID_Flush <= 0;
            end
            else if (jump == 2'b01) begin
                mux_to_pc <= 2'b01;
                IF_Flush <= 1;
                ID_Flush <= 1;
            end
            else if (jump == 2'b10) begin
                mux_to_pc <= 2'b10;
                IF_Flush <= 1;
                ID_Flush <= 1;
            end
        end
    end
end

endmodule