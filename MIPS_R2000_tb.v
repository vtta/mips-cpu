`include "signal_def.v"

module TESTBENCH (
`ifndef DEBUG
input clk,
input rstn,
input [15:0] sw_i, 
output[7:0] tubeSelect,
output[7:0] tubeChar,
`endif
output[15:0] led_o
);

    reg CLK_DEBUG;
    reg RST_DEBUG;
    wire[15:0] led_o;
    wire CLK_CPU;
    wire RST_CPU;
    `ifdef DEBUG
    assign RST_CPU = RST_DEBUG;
    assign CLK_CPU = CLK_DEBUG;
    reg [31:0] cycles;
    wire[15:0] sw_i = 15'b0;
    `else 
    wire CLK_TB = clk;
    assign RST_CPU = ~rstn;
    `endif



    `ifdef DEBUG
    initial begin
        $dumpfile("U_MIPS_R2000.vcd");
        $dumpvars;
        $readmemh("others/bubble-sort-mips.hex", 
            U_MIPS_R2000.U_InstructionMemory.IMem ) ;
        $monitor("PC\t\t%8X\nIR\t\t%8X\nClock\t\t%8X\nTube\t\t%8X\nLED\t\t%8b %8b\n=====================================\n\n",
            U_MIPS_R2000.pcOut, U_MIPS_R2000.instr, cycles, displayData, led_o[15:8], led_o[7:0]);
        cycles = 0;
        CLK_DEBUG = 1;
        RST_DEBUG = 0;
        #2 RST_DEBUG = ~RST_DEBUG;
        #2 RST_DEBUG = ~RST_DEBUG;
    end
    always begin
        #10 CLK_DEBUG = ~CLK_DEBUG;
    end
    always @ (posedge RST_CPU) begin
        cycles = 0;
    end
    always@(posedge CLK_CPU) begin
        cycles = cycles+1;
        if(cycles[9]) begin
            $finish;
        end
    end
    `endif



    MIPS_R2000 U_MIPS_R2000(
        .CtrlSignal(led_o),
        .CLK(CLK_CPU),
        .RST(RST_CPU));


    /*          LED Display            *\
    -------------------------------------
    | RegWrite | MemWrite | Display     |
    -------------------------------------
    |   1      |    0     | gprDataIn   |
    |   0      |    1     | gprDataOut2 |
    |   0      |    0     | pcOut       | */
    /*  Switch Definition
    |   15      | 14                       | 13                             |
    | CLK Speed | CPU Data Display Disable | Register Data Display Disable  |
    |  12:5     | 4:0                      |                                |
    | unused    | Display Address          |                              */
    wire [7:0]  tubeChar,tubeSelect;
    wire [31:0] cpuData = (U_MIPS_R2000.RegWrite)?
        U_MIPS_R2000.gprDataIn:(
            (U_MIPS_R2000.MemWrite)?
                U_MIPS_R2000.gprDataOut2:
                    U_MIPS_R2000.pcOut
        );
    wire [31:0] memData = U_MIPS_R2000.U_DataMemory.DataMemory[sw_i[4:0]];
    wire [31:0] regData = U_MIPS_R2000.U_GPR.gprRegisters[sw_i[4:0]];
    wire [31:0] displayData = sw_i[14]?(sw_i[13]?memData:regData):cpuData;
    `ifndef DEBUG
    seg7x16 U_seg7x16(.CLK(CLK_TB),
        .RST(RST_CPU),
        .inputData(displayData),
        .tubeChar(tubeChar),
        .tubeSelect(tubeSelect));
    clk_div U_ClockDivider(.CLK_CPU(CLK_CPU),
        .CLK(CLK_TB),
        .RST(RST_CPU),
        .SW15(sw_i[15]));
    `endif


endmodule
