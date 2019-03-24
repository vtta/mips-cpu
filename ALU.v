`include "signal_def.v"

module ALU (
    output  reg[31:0]   ALURes,
    output  reg         Zero,
    input   [31:0]      DataIn1,
    input   [31:0]      DataIn2,
    input   [4:0]       shamt,
    input   [4:0]       ALUOp
);

initial begin
    Zero   = 0;
    ALURes = 0;
end

always@(DataIn1 or DataIn2 or ALUOp or shamt) begin

    case(ALUOp)
        `ALUOp_ADD:
        ALURes = DataIn1 + DataIn2;
        `ALUOp_SUB, `ALUOp_BNE:
        ALURes = DataIn1 - DataIn2;
        `ALUOp_MUL:
        ALURes = DataIn1 * DataIn2;
        `ALUOp_DIV:
        ALURes = DataIn1 / DataIn2;
        `ALUOp_SLL:
        ALURes = DataIn2 << shamt;
        `ALUOp_SRL:
        ALURes = DataIn2 >> shamt;
        `ALUOp_SLR:
        for (int i = 0; i < 31; i++) begin
            ALURes[i] = DataIn1[(i+DataIn2)%32];
        end
        `ALUOp_SRR:
        for (int i = 0; i < 31; i++) begin
            ALURes[i] = DataIn1[(i-DataIn2+32)%32];
        end
        `ALUOp_AND:
        ALURes = DataIn1 & DataIn2;
        `ALUOp_OR:
        ALURes = DataIn1 | DataIn2;
        `ALUOp_XOR:
        ALURes = DataIn1 ^ DataIn2;
        `ALUOp_NOR:
        ALURes = ~(DataIn1 | DataIn2);
        `ALUOp_NAND:
        ALURes = ~(DataIn1 & DataIn2);
        `ALUOp_XNOR:
        ALURes = ~(DataIn1 ^ DataIn2);
        `ALUOp_SLT: begin
            if (DataIn1[31] != DataIn2[31]) begin
                if (DataIn1[31] > DataIn2[31])
                    ALURes = 1;
                else
                    ALURes = 0;
            end else begin
                if (DataIn1 < DataIn2)
                    ALURes = 1;
                else
                    ALURes = 0;
            end // if !=
        end // SLT
        `ALUOp_LUI: begin
            ALURes[15:0]  = 0;
            ALURes[31:16] = DataIn2[15:0];
        end
    endcase //ALUOp

    case (ALUOp)
        `ALUOp_BNE:
            Zero = (ALURes)?1:0;
        default:
            Zero = (ALURes)?0:1;
    endcase

end

endmodule
