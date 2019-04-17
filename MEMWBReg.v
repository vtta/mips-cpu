module MEMWBReg (
    input       clk,    // Clock
    // input clk_en,    // Clock Enable
    input       rst,    // Asynchronous reset
    // WB signal
    input       RegWrite_in,
    input       MemRead_in,
    // data
    input[31:0] Mem_in,
    input[31:0] ALU_in,
    input[4:0]  Rd_in,

    // WB signal
    output      RegWrite_out,
    output      MemRead_out,
    // data
    output[31:0]Mem_out,
    output[31:0]ALU_out,
    output[4:0] Rd_out
);

// 71 bit
reg[70:0] StageReg;
assign {
    RegWrite_out        ,
    MemRead_out         ,
    Mem_out       [31:0],
    ALU_out       [31:0],
    Rd_out        [4:0]
} = StageReg;

always @(posedge rst) begin
    StageReg <= 71'b0;
end

initial begin
    StageReg <= 71'b0;
end

always @(posedge clk) begin
    StageReg <= {
        RegWrite_in        ,
        MemRead_in         ,
        Mem_in       [31:0],
        ALU_in       [31:0],
        Rd_in        [4:0]
    };
end



endmodule