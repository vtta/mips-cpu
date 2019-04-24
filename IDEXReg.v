module IDEXReg (
    input       clk,    // Clock
    // input clk_en,    // Clock Enable
    input       rst,    // Asynchronous reset
    // EX signal
    input       RegDst_in,
    input[4:0]  ALUOp_in,
    input       ALUSrc_in,
    // MEM signal
    input       Branch_in,
    input       MemRead_in,
    input       MemWrite_in,
    // WB signal
    input       RegWrite_in,
    // data
    input[31:0] Reg1_in,
    input[31:0] Reg2_in,
    input[31:0] Ext_in,
    input[4:0]  Rs_in,
    input[4:0]  Rt_in,
    input[4:0]  Rd_in,
    input[4:0]  shamt_in,

    // EX signal
    output      RegDst_out,
    output[4:0] ALUOp_out,
    output      ALUSrc_out,
    // MEM signal
    output      Branch_out,
    output      MemRead_out,
    output      MemWrite_out,
    // WB signal
    output      RegWrite_out,
    // data
    output[31:0]Reg1_out,
    output[31:0]Reg2_out,
    output[31:0]Ext_out,
    output[4:0] Rs_out,
    output[4:0] Rt_out,
    output[4:0] Rd_out,
    output[4:0] shamt_out
);

reg[126:0] StageReg;
assign {
        RegDst_out,
        ALUOp_out[4:0],
        ALUSrc_out,
        Branch_out,
        MemRead_out,
        MemWrite_out,
        RegWrite_out,
        Reg1_out   [31:0],
        Reg2_out   [31:0],
        Ext_out    [31:0],
        Rs_out     [4:0],
        Rt_out     [4:0],
        Rd_out     [4:0],
        shamt_out  [4:0]
    } = StageReg;

always @(posedge rst) begin
    StageReg <= 127'b0;
end

initial begin
    StageReg <= 127'b0;
end

always @(posedge clk) begin
    StageReg <= {
        RegDst_in,
        ALUOp_in[4:0],
        ALUSrc_in,
        Branch_in,
        MemRead_in,
        MemWrite_in,
        RegWrite_in,
        Reg1_in   [31:0],
        Reg2_in   [31:0],
        Ext_in    [31:0],
        Rs_in     [4:0],
        Rt_in     [4:0],
        Rd_in     [4:0],
        shamt_in  [4:0]
    };
end



endmodule