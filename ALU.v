`include "signal_def.v"

module ALU(ALURes,Zero,DataIn1,DataIn2,ALUOp);

input   [31:0]      DataIn1;
input   [31:0]      DataIn2;
input   [1:0]       ALUOp;

output  reg[31:0]   ALURes;
output  reg         Zero;

initial
begin
    Zero   = 0;
    ALURes = 0;
end

always@(DataIn1 or DataIn2 or ALUOp)
begin

    case (ALUOp)
        `ALU_ADD_OP:
            ALURes = DataIn1+DataIn2;
        `ALU_SUB_OP:
            ALURes = DataIn1-DataIn2;
        `ALU_OR_OP:
            ALURes = DataIn1|DataIn2;
    endcase

    Zero = (ALURes)?0:1;

end

endmodule
