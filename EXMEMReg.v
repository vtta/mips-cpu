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
    // ALU signal
    input       Zero_in,
    // data
    input[31:0] ALU_in,
    input[31:0] FwdBOut_in,
    input[4:0]  Rd_in,

    // MEM signal
    output      Branch_out,
    output      MemRead_out,
    output      MemWrite_out,
    // WB signal
    output      RegWrite_out,
    // ALU signal
    output       Zero_out,
    // data
    output[31:0]ALU_out,
    output[31:0]FwdBOut_out,
    output[4:0] Rd_out
);

// 74 bit
reg[73:0] StageReg;
assign {
    Branch_out            ,
    MemRead_out           ,
    MemWrite_out          ,
    RegWrite_out          ,
    Zero_out              ,
    ALU_out         [31:0],
    FwdBOut_out     [31:0],
    Rd_out          [4:0]
} = StageReg;

always @(posedge rst) begin
    StageReg <= 74'b0;
end

initial begin
    StageReg <= 74'b0;
end

always @(posedge clk) begin
    StageReg <= {
        Branch_in         ,
        MemRead_in        ,
        MemWrite_in       ,
        RegWrite_in       ,
        Zero_in           ,
        ALU_in      [31:0],
        FwdBOut_in  [31:0],
        Rd_in       [4:0]
    };
end



endmodule