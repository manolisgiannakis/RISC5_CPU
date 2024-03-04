module PipelineDatapathTest();
    reg clk, reset;
    wire [31:0] mux_to_pc;

    PipelineDatapath pd0 (clk, reset, mux_to_pc);

    initial begin
        clk <= 1; reset <= 1; //clk = 0
    end

    initial begin
        #56 reset <= 0;
    end
    
    always #50 clk <= !clk;
endmodule