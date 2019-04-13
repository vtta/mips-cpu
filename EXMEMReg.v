module EXMEMReg (
    input       clk,    // Clock
    // input clk_en,    // Clock Enable
    input       rst,    // Asynchronous reset
    // MEM signal
    input       Branch_in,
    input       MemRead_in,
    input       MemWrite_in,
    // WB signal
    input       RegWrite_in,
    input       Mem2Reg_in,
    // ALU signal
    input       Zero_in,
    // data
    input[31:0] PC_in,
    input[31:0] ALU_in,
    input[31:0] Reg2_in,
    input[4:0]  WriteReg_in,

    // MEM signal
    output      Branch_out,
    output      MemRead_out,
    output      MemWrite_out,
    // WB signal
    output      RegWrite_out,
    output      Mem2Reg_out,
    // ALU signal
    output       Zero_out,
    // data
    output[31:0]PC_out,
    output[31:0]ALU_out,
    output[31:0]Reg2_out,
    output[4:0] WriteReg_out
);

// 107 bit
reg[106:0] StageReg;
assign {
    Branch_out         ,
    MemRead_out        ,
    MemWrite_out       ,
    RegWrite_out       ,
    Mem2Reg_out        ,
    Zero_out           ,
    PC_out      [31:0] ,
    ALU_out     [31:0] ,
    Reg2_out    [31:0] ,
    WriteReg_out[4:0]
} = StageReg    [106:0];

always @(posedge rst) begin
    StageReg <= 107'b0;
end

always @(posedge clk) begin
    StageReg[106:0] = {
        Branch_in         ,
        MemRead_in        ,
        MemWrite_in       ,
        RegWrite_in       ,
        Mem2Reg_in        ,
        Zero_in           ,
        PC_in       [31:0],
        ALU_in      [31:0],
        Reg2_in     [31:0],
        WriteReg_in [4:0]
    };
end



endmodule