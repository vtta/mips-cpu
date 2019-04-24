`include "signal_def.v"
`include "instruction_def.v"

module MIPS_R2000 (
    input CLK,
    input RST
);


    PCU U_PCU (
        .clk       (CLK),
        .rst       (RST),
        .Hazard    (U_HazardUnit.Hazard),
        .PCSrc     (U_Ctrl.Branch
                    &&( U_ConditionCheck.Equal
                        ^U_Ctrl.nBranch)),
        .Jump      (U_Ctrl.Jump),
        .BranchAddr(U_IFIDReg.PC_out
                    + { {14{U_IFIDReg.Instr_out[15]}}, 
                        `IMMEDIATE(U_IFIDReg.Instr_out), 
                        2'b00 } ),
        .JmpAddr   ({U_IFIDReg.PC_out[31:28], U_IFIDReg.Instr_out[25:0], 2'b0})
    );


    // Instruction Memory instantiation
    InstructionMemory U_InstructionMemory(
        // due to memory limit, only use low 10 bits
        .IMAdress(U_PCU.PC[11:2])
    );
    // For vivado generated IM module
    // dist_mem_gen_0 U_InstructionMemory(.spo(instr),
    //     .a(U_PCU.PC[11:2]) );


    IFIDReg U_IFIDReg (
        .clk(CLK),
        .rst(RST),
        .Hazard  (U_HazardUnit.Hazard   ),
        .PC_in   (U_PCU.PC + 4          ),
        .Instr_in(U_InstructionMemory.IR)
    );


    HazardUnit U_HazardUnit (
        .Jump       (U_Ctrl.Jump),
        .BranchTaken(U_PCU.PCSrc)
    );


    // Register File instantiation
    GPR U_GPR(
        .clk            (CLK),
        .rst            (RST),
        .WriteData      (U_MEMWBReg.MemRead_out?
            U_MEMWBReg.Mem_out:U_MEMWBReg.ALU_out),
        .RegWrite       (U_MEMWBReg.RegWrite_out),
        .WriteRegister  (U_MEMWBReg.Rd_out),
        .ReadRegister1  (U_IFIDReg.Instr_out[25:21]),
        .ReadRegister2  (U_IFIDReg.Instr_out[20:16])
    );



    ConditionCheck U_ConditionCheck (
        .in0(`ForwardingMux(
                U_ForwardingUnit.ForwardC,
                U_GPR.DataOut1,
                U_EXMEMReg.ALU_in,
                U_EXMEMReg.ALU_out,
                U_GPR.WriteData) ),
        .in1(`ForwardingMux(
                U_ForwardingUnit.ForwardD,
                U_GPR.DataOut2,
                U_EXMEMReg.ALU_in,
                U_EXMEMReg.ALU_out,
                U_GPR.WriteData) )
    );



    // Extender instantiation
    Extender U_Extender(
        .DataIn(U_IFIDReg.Instr_out[15:0]),
        .ExtOp(U_Ctrl.ExtOp)
    );


    IDEXReg U_IDEXReg (
        .clk         (CLK),
        .rst         (RST),
        .RegDst_in   (U_Ctrl.RegDst),
        .ALUOp_in    (U_Ctrl.ALUOp),
        .ALUSrc_in   (U_Ctrl.ALUSrc),
        .Branch_in   (U_Ctrl.Branch),
        .MemRead_in  (U_Ctrl.MemRead),
        .MemWrite_in (U_Ctrl.MemWrite),
        .RegWrite_in (U_Ctrl.RegWrite),
        .Reg1_in     (U_GPR.DataOut1),
        .Reg2_in     (U_GPR.DataOut2),
        .Ext_in      (U_Extender.ExtOut),
        .Rs_in       (U_IFIDReg.Instr_out[25:21]),
        .Rt_in       (U_IFIDReg.Instr_out[20:16]),
        .Rd_in       (U_IFIDReg.Instr_out[15:11]),
        .shamt_in    (U_IFIDReg.Instr_out[10:6] )
    );


    // ALU instantiation
    ALU U_ALU(
        .DataIn1(
            `ForwardingMux(
                U_ForwardingUnit.ForwardA,
                U_IDEXReg.Reg1_out,
                U_GPR.WriteData,
                U_EXMEMReg.ALU_out, 0) ),
        .DataIn2(U_IDEXReg.ALUSrc_out?
            U_IDEXReg.Ext_out:U_EXMEMReg.FwdBOut_in),
        .ALUOp(U_IDEXReg.ALUOp_out),
        .shamt(U_IDEXReg.shamt_out) 
    );


    EXMEMReg U_EXMEMReg (
        .clk         (CLK),
        .rst         (RST),
        .Branch_in   (U_IDEXReg.Branch_out  ),
        .MemRead_in  (U_IDEXReg.MemRead_out ),
        .MemWrite_in (U_IDEXReg.MemWrite_out),
        .RegWrite_in (U_IDEXReg.RegWrite_out),
        .Zero_in     (U_ALU.Zero            ),
        .ALU_in      (U_ALU.ALURes          ),
        .FwdBOut_in  (
            `ForwardingMux(
                U_ForwardingUnit.ForwardB,
                U_IDEXReg.Reg2_out,
                U_GPR.WriteData,
                U_EXMEMReg.ALU_out, 0) ),
        .Rd_in       (
            U_IDEXReg.RegDst_out?U_IDEXReg.Rd_out
                :U_IDEXReg.Rt_out)
    );


    //Data Memory instantiation
    DataMemory U_DataMemory(
        .clk     (CLK),
        .rst     (RST),
        // due to memory limit, only use low 5 bits
        .DataAddr(U_EXMEMReg.ALU_out[6:2]),
        .DataIn  (U_EXMEMReg.FwdBOut_out ),
        .DMemW   (U_EXMEMReg.MemWrite_out),
        .DMemR   (U_EXMEMReg.MemRead_out )
    );


    MEMWBReg U_MEMWBReg (
        .clk         (CLK),
        .rst         (RST),
        .RegWrite_in (U_EXMEMReg.RegWrite_out),
        .MemRead_in  (U_EXMEMReg.MemRead_out ),
        .Mem_in      (U_DataMemory.DataOut   ),
        .ALU_in      (U_EXMEMReg.ALU_out     ),
        .Rd_in       (U_EXMEMReg.Rd_out      )
    );


    // Control instantiation
    Control U_Ctrl(
        .OpCode    (U_IFIDReg.Instr_out[31:26]),
        .Funct     (U_IFIDReg.Instr_out[5:0]  )
    );


    ForwardingUnit U_ForwardingUnit (
        .IFIDRs       (`RS(U_IFIDReg.Instr_out)  ),
        .IFIDRt       (`RT(U_IFIDReg.Instr_out)  ),
        .IDEXRs       (U_IDEXReg.Rs_out          ),
        .IDEXRt       (U_IDEXReg.Rt_out          ),
        .IDEXWriteReg (U_EXMEMReg.Rd_in          ),
        .EXMEMRd      (U_EXMEMReg.Rd_out         ),
        .MEMWBRd      (U_MEMWBReg.Rd_out         ),
        .IDEXRegWrite (U_IDEXReg.RegWrite_out    ),
        .MEMWBRegWrite(U_MEMWBReg.RegWrite_out   ),
        .EXMEMRegWrite(U_EXMEMReg.RegWrite_out   )
    );



endmodule
