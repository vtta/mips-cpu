
module InstructionMemory(Instruction,IMAdress);
input [4:0] IMAdress;
output [31:0]  Instruction;

reg [31:0]  IMem[1024:0];
reg [31:0]  IR;

always@(IMAdress) begin
    IR = IMem[IMAdress];
end

assign Instruction = IR;

endmodule
