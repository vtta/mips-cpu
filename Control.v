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
output reg[4:0] ALUOp;

always@(OpCode or Funct)
begin
    case (OpCode)
        `INSTR_RTYPE_OP: // R type 0x00
        begin

            case (Funct)
                `INSTR_ADD_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_ADD;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // ADD

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

                `INSTR_SUB_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_SUB;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // SUB

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

                `INSTR_SLL_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    // ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_SLL;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // SLL

                `INSTR_SRL_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    // ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_SRL;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // SRL

                `INSTR_SLT_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    // ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_SLT;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // SLT

                `INSTR_AND_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    // ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_AND;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // AND

                `INSTR_OR_FUNCT:
                begin
                    RegDst      = `REG_DST_RD;
                    // ExtOp       = `EXT_SIGNED;
                    ALUSrc      = `ALU_SRC_REG;
                    ALUOp       = `ALUOp_OR;
                    Mem2Reg     = 0;
                    RegWrite    = 1;
                    MemRead     = 0;
                    MemWrite    = 0;
                    Branch      = 0;
                    Jump        = 0;
                end // OR

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

        `INSTR_BNE_OP:
        begin
            // RegDst      = `REG_DST_RD;
            ExtOp       = `EXT_SIGNED;
            ALUSrc      = `ALU_SRC_REG;
            ALUOp       = `ALUOp_BNE;
            Mem2Reg     = 0;
            RegWrite    = 0;
            MemRead     = 0;
            MemWrite    = 0;
            Branch      = 1;
            Jump        = 0;
        end // BNE

        `INSTR_SLTI_OP:
        begin
            RegDst      = `REG_DST_RT;
            ExtOp       = `EXT_SIGNED;
            ALUSrc      = `ALU_SRC_EXT;
            ALUOp       = `ALUOp_SLTI;
            Mem2Reg     = 0;
            RegWrite    = 1;
            MemRead     = 0;
            MemWrite    = 0;
            Branch      = 0;
            Jump        = 0;
        end // SLTI

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

        `INSTR_LUI_OP:
        begin
            RegDst      = `REG_DST_RT;
            ExtOp       = `EXT_SIGNED;
            ALUSrc      = `ALU_SRC_EXT;
            ALUOp       = `ALUOp_LUI;
            Mem2Reg     = 0;
            RegWrite    = 1;
            MemRead     = 0;
            MemWrite    = 0;
            Branch      = 0;
            Jump        = 0;
        end //LUI

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

        `INSTR_J_OP:
        begin
            // RegDst      = `REG_DST_RD;
            // ExtOp       = `EXT_SIGNED;
            // ALUSrc      = `ALU_SRC_REG;
            // ALUOp       = `ALUOp_BNE;
            Mem2Reg     = 0;
            RegWrite    = 0;
            MemRead     = 0;
            MemWrite    = 0;
            Branch      = 1;
            Jump        = 1;
        end // J

    endcase
end



endmodule


