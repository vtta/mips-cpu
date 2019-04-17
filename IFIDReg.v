module IFIDReg (
    input       clk,    // Clock
    // input clk_en,    // Clock Enable
    input       rst,    // Asynchronous reset

    input       Hazard,
    // data
    input[31:0] PC_in,
    input[31:0] Instr_in,

    // data
    output[31:0]PC_out,
    output[31:0]Instr_out
);

// 64 bit
reg[63:0] StageReg;
assign {
    PC_out   [31:0],
    Instr_out[31:0]
} = StageReg [63:0];

always @(posedge rst) begin
    StageReg <= 64'b0;
end

initial begin
    StageReg <= 64'b0;
end

always @(posedge clk) begin
    if(Hazard) begin
        StageReg[63:0] <= 64'b0;
    end else begin
        StageReg[63:0] <= {
            PC_in   [31:0],
            Instr_in[31:0]
        };
    end
end



endmodule