
module TESTBENCH;

    reg clk;
    reg rst;
    reg [31:0] clockCnt;

    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("Test_6_Instr.txt", MIPS_R2000_tb.U_InstructionMemory.IMem ) ;
        $monitor("PC\t\t%8X\nIR\t\t%8X\nClock\t\t%8X\n=====================================\n\n", MIPS_R2000_tb.U_PCU.PCRegDataOut, MIPS_R2000_tb.instr, clockCnt);
        clk = 0 ;
        rst = 0 ;
        #5 rst = 1;
        #20 rst = 0;
        clockCnt = 0;
    end

    always  begin
        #50 clk = ~clk;
    end
    always@(posedge clk) begin
        clockCnt = clockCnt+1;
        if(clockCnt >= 2048) begin
            $finish;
        end
    end

    wire CLK;
    wire RST;
    assign CLK = clk;
    assign RST = rst;
    MIPS_R2000 MIPS_R2000_tb(.CLK(CLK),
        .RST(RST));


endmodule
