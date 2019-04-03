
`define ALU_SRC_REG 1'b0
`define ALU_SRC_EXT 1'b1

// Register
`define REG_DST_RT  1'b0
`define REG_DST_RD  1'b1


// Extender
`define EXT_ZERO    1'b0
`define EXT_SIGNED  1'b1


// PC Mux
`define PC_SRC_INC  1'b0
`define PC_SRC_EXT  1'b1

/* ALU Arithmetic and Logic Operations
-------------------------------------------
| ALUOp |   ALU Operation
-------------------------------------------
| 00000  |   ALURes = A + B;
-------------------------------------------
| 00001  |   ALURes = A - B;
-------------------------------------------
| 00010  |   ALURes = A * B;
-------------------------------------------
| 00011  |   ALURes = A / B;
-------------------------------------------
| 00100  |   ALURes = A << 1;
-------------------------------------------
| 00101  |   ALURes = A >> 1;
-------------------------------------------
| 00110  |   ALURes = A rotated left by B;
-------------------------------------------
| 00111  |   ALURes = A rotated right by B;
-------------------------------------------
| 01000  |   ALURes = A and B;
-------------------------------------------
| 01001  |   ALURes = A or B;
-------------------------------------------
| 01010  |   ALURes = A xor B;
-------------------------------------------
| 01011  |   ALURes = A nor B;
-------------------------------------------
| 01100  |   ALURes = A nand B;
-------------------------------------------
| 01101  |   ALURes = A xnor B;
-------------------------------------------
| 01110  |   Zero   = 1 if A!=B else 0;
-------------------------------------------
| 01111  |   ALURes = 1 if A<B else 0;
-------------------------------------------
| 01111  |   ALURes = 1 if A<B else 0;
-----------------------------------------*/
`define ALUOp_ADD   5'b00000
`define ALUOp_SUB   5'b00001
`define ALUOp_MUL   5'b00010
`define ALUOp_DIV   5'b00011
`define ALUOp_SLL   5'b00100
`define ALUOp_SRL   5'b00101
`define ALUOp_SLR   5'b00110
`define ALUOp_SRR   5'b00111
`define ALUOp_AND   5'b01000
`define ALUOp_OR    5'b01001
`define ALUOp_XOR   5'b01010
`define ALUOp_NOR   5'b01011
`define ALUOp_NAND  5'b01100
`define ALUOp_XNOR  5'b01101
`define ALUOp_BNE   5'b01110
`define ALUOp_SLT   5'b01111
`define ALUOp_LUI   5'b10001

`define ALUOp_ADDU  `ALUOp_ADD
`define ALUOp_ADDIU `ALUOp_ADD
`define ALUOp_SUBU  `ALUOp_SUB
`define ALUOp_ORI   `ALUOp_OR
`define ALUOp_LW    `ALUOp_ADD
`define ALUOp_SW    `ALUOp_ADD
`define ALUOp_BEQ   `ALUOp_SUB
`define ALUOp_SLTI  `ALUOp_SLT
