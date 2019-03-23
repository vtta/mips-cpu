
module InstructionMemory(Instruction,ImAdress);
input [4:0] ImAdress;
output [31:0]  Instruction;

reg [31:0]  IMem[1024:0];
reg[31:0] InstrTmp;

always@(ImAdress) begin
    InstrTmp = IMem[ImAdress];
end

assign Instruction = InstrTmp;

endmodule
