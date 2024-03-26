module PipelineDatapathTest();
    reg clk, reset;
    wire [31:0] mux_to_pc, instMemOut, rd1_id_ex, ALU_0, ALU_2nd_in, result, DataMem_out;
    wire [1:0] fw0, fw1;
    wire [2:0] f3_to_dataMem;
    wire hazDetect_IF_ID, RegWrite_to_ex_mem;

    PipelineDatapath pd0 (clk, reset, mux_to_pc, instMemOut, rd1_id_ex, hazDetect_IF_ID, RegWrite_to_ex_mem, fw0, fw1, ALU_0, ALU_2nd_in, result, f3_to_dataMem, DataMem_out);

    initial begin
        clk <= 1; reset <= 1; //clk = 0
    end

    initial begin
        #56 reset <= 0;
    end
    
    always #50 clk <= !clk;
endmodule