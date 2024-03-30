/*Register file has the ports that are written below:
    clk, rr1(read register 1), rr2(read register 2), wr (write register), wd(write data),
    RegWrite (control signal), rd1 (read data 1),rd2 (read data 2),   */
module RegFile (clk, RegWrite, rr1, rr2, wr, wd, rd1, rd2);

    //ports
    input clk, RegWrite;
    input [4:0] rr1, rr2, wr;
    input [31:0] wd;
    output reg [31:0] rd1, rd2;

    //register file
    reg [31:0] register [31:0]; //the 32 registers that consist the register file

    integer i;

    initial begin //for simulation purposes
        for (i = 0; i < 32; i = i + 1) begin
            register[i] <= 'b0;
        end
        register[5] <= 32'd4; 
    end

    //read data - the register file will always output the values corresponding to read register numbers
    //read data in positive edge of the clock
    always @(posedge clk) begin //ΔΙΟΡΘΩΝΩ
        rd1 <= register[rr1];
        rd2 <= register[rr2];
    end

    always @(*) begin //wd, RegWrite, wr   we want to write data in the first half of the clock cycle 
        if(RegWrite) begin
            register[wr] <= wd;
        end
        else begin
            register[wr] <= register[wr];
        end
    end

    
    

endmodule
