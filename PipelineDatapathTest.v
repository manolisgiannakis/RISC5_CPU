module PipelineDatapathTest();
    reg clk, reset;

    PipelineDatapath pd0 (clk, reset);

    initial begin
        clk <= 0; reset <= 1;
    end

    initial begin
        #56 reset <= 0;
    end
    
    always #50 clk <= !clk;
endmodule