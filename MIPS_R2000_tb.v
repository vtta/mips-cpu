
module TESTBENCH (
    input clk,
    input rstn,
    input[15:0] sw_i
);

    wire CLK_CPU;
    wire RST_CPU = rstn;
    reg [31:0] clockCnt;

    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("test_instr_13.txt", MIPS_R2000_tb.U_InstructionMemory.IMem ) ;
        $monitor("PC\t\t%8X\nIR\t\t%8X\nClock\t\t%8X\n=====================================\n\n", MIPS_R2000_tb.U_PCU.PCRegDataOut, MIPS_R2000_tb.instr, clockCnt);
        clockCnt = 0;
    end

    always @ (posedge RST_CPU) begin
        clockCnt = 0;
    end

    always@(posedge CLK_CPU) begin
        clockCnt = clockCnt+1;
        if(clockCnt >= 2048) begin
            $finish;
        end
    end

    MIPS_R2000 MIPS_R2000_tb(.CLK(CLK_CPU),
        .RST(RST_CPU));

    clk_div T_ClockDivider(.CLK_CPU(CLK_CPU),
        .CLK(clk),
        .RST(RST_CPU),
        .SW15(sw_i[15]));

endmodule
