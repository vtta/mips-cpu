
module InstructionMemory(
    input[9:0]          IMAdress,
    output reg[31:0]    IR
);


reg [31:0]  IMem[1023:0];

always@(IMAdress) begin
    IR <= IMem[IMAdress];
end


endmodule
