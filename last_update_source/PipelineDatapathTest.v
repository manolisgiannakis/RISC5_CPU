module PipelineDatapathTest();
    reg clk, reset;

    PipelineDatapath pd0 (clk, reset);

    initial begin
        clk <= 1; reset <= 1; //clk = 0
    end

    initial begin
        #56 reset <= 0;
    end
    
    always #50 clk <= !clk;
endmodule