module PC (clk, reset, pc_input, hazDetect_PC, pc_output);
    
    input clk, reset, hazDetect_PC;
    input [31:0] pc_input;

    output reg [31:0] pc_output;


    always @(posedge clk) begin
        if(hazDetect_PC) begin
            if(reset) begin
                pc_output <= 32'b0;
            end
            else begin
                pc_output <= pc_input;
            end
        end
    end
    
endmodule