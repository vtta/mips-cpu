`include "signal_def.v"

module MIPS_R2000 (
    input CLK,
    input RST,
    output[15:0] CtrlSignal
);


    // InstructionMemory
    wire [31:0] instr;
    wire [31:0] pcOut;
    wire [9:0]  imAddr  = pcOut[11:2];
    wire [5:0]  Op      = instr[31:26];
    wire [4:0]  rs      = instr[25:21];
    wire [4:0]  rt      = instr[20:16];
    wire [4:0]  rd      = instr[15:11];
    wire [4:0]  shamt   = instr[10:6];
    wire [5:0]  Funct   = instr[5:0];
    wire [25:0] JumpTarget = instr[25:0];
    // GPR
    wire [4:0]  gprWriteRegister;
    wire [31:0] gprDataIn;
    wire [31:0] gprDataOut1;
    wire [31:0] gprDataOut2;
    // Extender
    wire [15:0] extDataIn;
    wire [31:0] extDataOut;
    assign extDataIn = instr[15:0];
    // ALU
    wire        zero;
    wire [31:0] aluDataIn2;
    wire [31:0] aluDataOut;
    // DataMemory
    wire [4:0]  dmDataAddr;
    wire [31:0] dmDataOut;
    assign dmDataAddr = aluDataOut[5:2];
    // Control
    wire    Jump;
    wire    Branch;
    wire    RegDst;
    wire    RegWrite;
    wire    MemRead;
    wire    MemWrite;
    wire    Mem2Reg;
    wire    ALUSrc;
    wire    ExtOp;
    wire [4:0]  ALUOp;
    // output
    assign CtrlSignal = {2'b0,Jump,Branch,RegDst,RegWrite,MemRead,
                        MemWrite,Mem2Reg,ALUSrc,ExtOp,ALUOp};




    PCU U_PCU (
        .RST          (RST       ),
        .CLK          (CLK       ),
        .Branch       (Branch    ),
        .Jump         (Jump      ),
        .ALUZero      (zero      ),
        .Op           (Op        ),
        .JumpTarget   (JumpTarget),
        .BranchAddress(extDataOut),
        .PCRegDataOut (pcOut     )
    );



    // Instruction Memory instantiation
    InstructionMemory U_InstructionMemory(.Instruction(instr),
        .IMAdress(imAddr) );




    Mux5_2x1 U_WirteRegisterMux(.select(RegDst),
        .in0(rt),
        .in1(rd),
        .out(gprWriteRegister) );
    Mux32_2x1 U_WriteDataMux(.select(Mem2Reg),
        .in0(aluDataOut),
        .in1(dmDataOut),
        .out(gprDataIn) );
    // Register File instantiation
    GPR U_GPR(.DataOut1(gprDataOut1),
        .DataOut2(gprDataOut2),
        .CLK(CLK),
        .WriteData(gprDataIn),
        .RegWrite(RegWrite),
        .WriteRegisterSelect(gprWriteRegister),
        .ReadRegister1(rs),
        .ReadRegister2(rt) );




    Mux32_2x1 U_ALUDataIn1Mux(.select(ALUSrc),
        .in0(gprDataOut2),
        .in1(extDataOut),
        .out(aluDataIn2) );
    // ALU instantiation
    ALU U_ALU(.ALURes(aluDataOut),
        .Zero(zero),
        .DataIn1(gprDataOut1),
        .DataIn2(aluDataIn2),
        .ALUOp(ALUOp),
        .shamt(shamt) );




    // Extender instantiation
    Extender U_Extender(.ExtOut(extDataOut),
        .DataIn(extDataIn),
        .ExtOp(ExtOp) );




    //Data Memory instantiation
    DataMemory U_DataMemory(.DataOut(dmDataOut),
        .DataAddr(dmDataAddr),
        .DataIn(gprDataOut2),
        .DMemW(MemWrite),
        .DMemR(MemRead),
        .CLK(CLK) );




    // Control instantiation
    Control U_Ctrl(.Jump(Jump),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .Mem2Reg(Mem2Reg),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ExtOp(ExtOp),
        .ALUOp(ALUOp),
        .OpCode(Op),
        .Funct(Funct) );



endmodule
