`include "instruction_def.v"
`include "signal_def.v"

module Control(Jump,RegDst,Branch,MemRead,Mem2Reg,MemWrite,RegWrite,ALUSrc,ExtOp,ALUOp,OpCode,Funct);

input [5:0]     OpCode;
input [5:0]     Funct;

output reg      Jump;
output reg      RegDst;
output reg      Branch;
output reg      MemRead;
output reg      Mem2Reg;
output reg      MemWrite;
output reg      RegWrite;
output reg      ALUSrc;
output reg      ExtOp;
output reg[3:0] ALUOp;

always@(OpCode or Funct)
begin
    case (OpCode)
        `INSTR_RTYPE_OP: // R type 0x00
        begin

            case (Funct)
                `INSTR_ADDU_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    ALUSrc      = `ALU_SRC_REG;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    ALUOp       = `ALUOp_ADDU;
                    Jump        = 0;
                    ExtOp       = `EXT_ZERO;
                end // ADDU

                `INSTR_SUBU_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    ALUSrc      = `ALU_SRC_REG;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    ALUOp       = `ALUOp_SUBU;
                    Jump        = 0;
                    ExtOp       = `EXT_ZERO;
                end // SUBU

            endcase
        end // RTYPE

        `INSTR_BEQ_OP: // 0x04
        begin
            // RegDst     = `REG_DST_RT;
            ALUSrc      = `ALU_SRC_REG;
            Mem2Reg     = 0;
            RegWrite    = 0;
            MemRead     = 0;
            MemWrite    = 0;
            Branch      = 1;
            ALUOp       = `ALUOp_BEQ;
            Jump        = 0;
            ExtOp       = `EXT_SIGNED;
        end //BEQ

        `INSTR_ORI_OP: // 0x0D
        begin
            RegDst      = `REG_DST_RT;
            ALUSrc      = `ALU_SRC_EXT;
            Mem2Reg     = 0;
            RegWrite    = 1;
            MemRead     = 0;
            MemWrite    = 0;
            Branch      = 0;
            ALUOp       = `ALUOp_ORI;
            Jump        = 0;
            ExtOp       = `EXT_ZERO;
        end // ORI

        `INSTR_LW_OP: // 0x23
        begin
            RegDst      = `REG_DST_RT;
            ALUSrc      = `ALU_SRC_EXT;
            Mem2Reg     = 1;
            RegWrite    = 1;
            MemRead     = 1;
            MemWrite    = 0;
            Branch      = 0;
            ALUOp       = `ALUOp_LW;
            Jump        = 0;
            ExtOp       = `EXT_SIGNED;
        end //LW

        `INSTR_SW_OP: // 0x2B
        begin
            RegDst      = `REG_DST_RT;
            ALUSrc      = `ALU_SRC_EXT;
            Mem2Reg     = 0;
            RegWrite    = 0;
            MemRead     = 0;
            MemWrite    = 1;
            Branch      = 0;
            ALUOp       = `ALUOp_SW;
            Jump        = 0;
            ExtOp       = `EXT_SIGNED;
        end // SW

    endcase
end



endmodule


