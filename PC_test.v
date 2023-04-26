module PC_test();
    reg clk, reset;
    reg [31:0] pc_input;

    wire [31:0] pc_output;

    PC test (clk, reset, pc_input, pc_output);

    initial begin
        clk <= 0; reset <= 1; pc_input <= 32'd63;
    end

    initial begin
        #6 reset <= 0;
    end

    always #5 clk <= !clk;
endmodule