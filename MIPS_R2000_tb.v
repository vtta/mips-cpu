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
    integer i;
    `else 
    wire CLK_TB = clk;
    assign RST_CPU = ~rstn;
    `endif

    assign led_o =  {
        3'b0,
        U_MIPS_R2000.U_Ctrl.Jump,
        U_MIPS_R2000.U_Ctrl.Branch,
        U_MIPS_R2000.U_Ctrl.RegDst,
        U_MIPS_R2000.U_Ctrl.RegWrite,
        U_MIPS_R2000.U_Ctrl.MemRead,
        U_MIPS_R2000.U_Ctrl.MemWrite,
        U_MIPS_R2000.U_Ctrl.ALUSrc,
        U_MIPS_R2000.U_Ctrl.ExtOp,
        U_MIPS_R2000.U_Ctrl.ALUOp
    };


    `ifdef DEBUG
    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("others/test_instr_13.txt", 
            U_MIPS_R2000.U_InstructionMemory.IMem 
        );
        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;
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

    always@(negedge CLK_CPU) begin
        $display("=====================================");
        for(i=0;i<8;i=i+1) begin
            $display("R[%2d-%2d]  %8X  %8X  %8X  %8X",i*4,i*4+3, 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+0], 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+1], 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+2], 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+3]
            );
        end
        $display("");
        for(i=0;i<8;i=i+1) begin
            $display("M[%2d-%2d]  %8X  %8X  %8X  %8X",i*4,i*4+3,
                U_MIPS_R2000.U_DataMemory.DataMemory[i*4+0],
                U_MIPS_R2000.U_DataMemory.DataMemory[i*4+1],
                U_MIPS_R2000.U_DataMemory.DataMemory[i*4+2],
                U_MIPS_R2000.U_DataMemory.DataMemory[i*4+3]
            );
        end
        $display("");
        $display("Clock     %8X", cycles);
        $display("PC        %8X", U_MIPS_R2000.U_PCU.PC);
        $display("IR        %8X", U_MIPS_R2000.U_InstructionMemory.IR);
        $display("Tube      %8X", displayData);
        $display("LED       %8b %8b", led_o[15:8], led_o[7:0]);
        if(U_MIPS_R2000.U_GPR.RegWrite) begin
            $display("R[ %4d]  %8X", 
                U_MIPS_R2000.U_GPR.WriteRegister,
                U_MIPS_R2000.U_GPR.WriteData
            );
        end

        if(U_MIPS_R2000.U_DataMemory.DMemW) begin
            $display("M[ %4d]  %8X",
                U_MIPS_R2000.U_DataMemory.DataAddr,
                U_MIPS_R2000.U_DataMemory.DataIn
            );
        end

        $display("=====================================\n\n");
    end
    `endif



    MIPS_R2000 U_MIPS_R2000(
        .CLK(CLK_CPU),
        .RST(RST_CPU)
    );


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
    wire [31:0] cpuData = (U_MIPS_R2000.U_Ctrl.RegWrite)?
        U_MIPS_R2000.U_GPR.WriteData:(
            (U_MIPS_R2000.U_Ctrl.MemWrite)?
                U_MIPS_R2000.U_GPR.DataOut2:
                    U_MIPS_R2000.U_PCU.PC
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
