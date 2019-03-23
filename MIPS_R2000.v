`include "signal_def.v"

module MIPS_R2000(CLK,RST);

    input CLK, RST;

    // InstructionMemory
    wire [31:0] instr;
    wire [4:0]  imAdr;
    wire [5:0]  Op;
    wire [5:0]  Funct;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [4:0]  shamt;
    wire [25:0] JumpTarget;
    assign Op    = instr[31:26];
    assign rs    = instr[25:21];
    assign rt    = instr[20:16];
    assign rd    = instr[15:11];
    assign shamt = instr[10:6];
    assign Funct = instr[5:0];
    assign JumpTarget = instr[25:0];
    // PC
    wire [31:0] pcOut;
    assign imAdr = pcOut[5:2];
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
    wire    PCSrc;
    assign PCSrc = (Branch&&zero)?1:0;
    wire [1:0]  ALUOp;




    // PC instantiation
    PCU U_PCU(.PC(pcOut),
        .RST(RST),
        .PCSrc(PCSrc),
        .CLK(CLK),
        .Adress(extDataOut) );



    // Instruction Memory instantiation
    InstructionMemory U_InstructionMemory(.Instruction(instr),
        .ImAdress(imAdr) );




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
        .ALUOp(ALUOp) );




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











