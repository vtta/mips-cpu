`include "signal_def.v"

module MIPS_R2000 (
    input CLK,
    input RST
);


    PCU U_PCU (
        .clk       (CLK),
        .rst       (RST),
        .PCSrc     (U_EXMEMReg.Branch_out && U_EXMEMReg.Zero_out),
        .Jump      (U_Ctrl.Jump),
        .BranchAddr(U_IFIDReg.PC_out+(U_Extender.ExtOut<<2)),
        .JmpAddr   ({U_IFIDReg.PC_out[31:28],U_IFIDReg.Instr_out[25:0],2'b00})
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
        .PC_in(U_PCU.PC+4),
        .Instr_in(U_InstructionMemory.IR)
    );


    // Register File instantiation
    GPR U_GPR(
        .clk            (CLK),
        .rst            (RST),
        .WriteData      (U_MEMWBReg.Mem2Reg_out?
            U_MEMWBReg.Mem_out:U_MEMWBReg.ALU_out),
        .RegWrite       (U_MEMWBReg.RegWrite_out),
        .WriteRegister  (U_MEMWBReg.WriteReg_out),
        .ReadRegister1  (U_IFIDReg.Instr_out[25:21]),
        .ReadRegister2  (U_IFIDReg.Instr_out[20:16]) 
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
        .Mem2Reg_in  (U_Ctrl.Mem2Reg),
        .Reg1_in     (U_GPR.DataOut1),
        .Reg2_in     (U_GPR.DataOut2),
        .Ext_in      (U_Extender.ExtOut),
        .Rt_in       (U_IFIDReg.Instr_out[20:16]),
        .Rd_in       (U_IFIDReg.Instr_out[15:11]),
        .shamt_in    (U_IFIDReg.Instr_out[10:6])
    );


    // ALU instantiation
    ALU U_ALU(
        .DataIn1(U_IDEXReg.Reg1_out),
        .DataIn2(U_IDEXReg.ALUSrc_out?
            U_IDEXReg.Ext_out:U_IDEXReg.Reg2_out),
        .ALUOp(U_IDEXReg.ALUOp_out),
        .shamt(U_IDEXReg.shamt_out) );


    EXMEMReg U_EXMEMReg (
        .clk         (CLK),
        .rst         (RST),
        .Branch_in   (U_IDEXReg.Branch_out),
        .MemRead_in  (U_IDEXReg.MemRead_out),
        .MemWrite_in (U_IDEXReg.MemWrite_out),
        .RegWrite_in (U_IDEXReg.RegWrite_out),
        .Mem2Reg_in  (U_IDEXReg.Mem2Reg_out),
        .Zero_in     (U_ALU.Zero),
        .ALU_in      (U_ALU.ALURes),
        .Reg2_in     (U_IDEXReg.Reg2_out),
        .WriteReg_in (U_IDEXReg.RegDst_out?
            U_IDEXReg.Rd_out:U_IDEXReg.Rt_out)
    );


    //Data Memory instantiation
    DataMemory U_DataMemory(
        .clk     (CLK),
        .rst     (RST),
        // due to memory limit, only use low 5 bits
        .DataAddr(U_EXMEMReg.ALU_out[4:0]),
        .DataIn  (U_EXMEMReg.Reg2_out),
        .DMemW   (U_EXMEMReg.MemWrite_out),
        .DMemR   (U_EXMEMReg.MemRead_out)
    );


    MEMWBReg U_MEMWBReg (
        .clk         (CLK),
        .rst         (RST),
        .RegWrite_in (U_EXMEMReg.RegWrite_out),
        .Mem2Reg_in  (U_EXMEMReg.Mem2Reg_out),
        .Mem_in      (U_DataMemory.DataOut),
        .ALU_in      (U_EXMEMReg.ALU_out),
        .WriteReg_in (U_EXMEMReg.WriteReg_out)
    );


    // Control instantiation
    Control U_Ctrl(
        .OpCode(U_IFIDReg.Instr_out[31:26]),
        .Funct(U_IFIDReg.Instr_out[5:0]) 
    );


endmodule
