module PC (clk, reset, hazDetect_PC, pc_input, pc_output);
    
    input clk, reset, hazDetect_PC;
    input [31:0] pc_input;

    output reg [31:0] pc_output;


    always @(negedge clk) begin //posedge
        if(hazDetect_PC) begin
            if(reset) begin
                pc_output <= 32'b0;
            end
            else begin
                pc_output <= pc_input;
            end
        end
        // if(reset) begin
        //         pc_output <= 32'b0;
        //     end
        //     else begin
        //         pc_output <= pc_input;
        //     end
    end
    
endmodule