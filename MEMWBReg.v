module MEMWBReg (
    input       clk,    // Clock
    // input clk_en,    // Clock Enable
    input       rst,    // Asynchronous reset
    // WB signal
    input       RegWrite_in,
    input       Mem2Reg_in,
    // data
    input[31:0] Mem_in,
    input[31:0] ALU_in,
    input[4:0]  WriteReg_in,

    // WB signal
    output      RegWrite_out,
    output      Mem2Reg_out,
    // data
    output[31:0]Mem_out,
    output[31:0]ALU_out,
    output[4:0] WriteReg_out
);

// 71 bit
reg[70:0] StageReg;
assign {
    RegWrite_out        ,
    Mem2Reg_out         ,
    Mem_out       [31:0],
    ALU_out       [31:0],
    WriteReg_out  [4:0]
} = StageReg      [70:0];

always @(posedge rst) begin
    StageReg <= 71'b0;
end

initial begin
    StageReg <= 71'b0;
end

always @(posedge clk) begin
    StageReg[70:0] <= {
        RegWrite_in        ,
        Mem2Reg_in         ,
        Mem_in       [31:0],
        ALU_in       [31:0],
        WriteReg_in  [4:0]
    };
end



endmodule