
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
| 0000  |   ALURes = A + B;
-------------------------------------------
| 0001  |   ALURes = A - B;
-------------------------------------------
| 0010  |   ALURes = A * B;
-------------------------------------------
| 0011  |   ALURes = A / B;
-------------------------------------------
| 0100  |   ALURes = A << 1;
-------------------------------------------
| 0101  |   ALURes = A >> 1;
-------------------------------------------
| 0110  |   ALURes = A rotated left by B;
-------------------------------------------
| 0111  |   ALURes = A rotated right by B;
-------------------------------------------
| 1000  |   ALURes = A and B;
-------------------------------------------
| 1001  |   ALURes = A or B;
-------------------------------------------
| 1010  |   ALURes = A xor B;
-------------------------------------------
| 1011  |   ALURes = A nor B;
-------------------------------------------
| 1100  |   ALURes = A nand B;
-------------------------------------------
| 1101  |   ALURes = A xnor B;
-------------------------------------------
| 1110  |   Zero   = 1 if A!=B else 0;
-------------------------------------------
| 1111  |   ALURes = 1 if A<B else 0;
-----------------------------------------*/
`define ALUOp_ADD   4'b0000
`define ALUOp_SUB   4'b0001
`define ALUOp_MUL   4'b0010
`define ALUOp_DIV   4'b0011
`define ALUOp_SLL   4'b0100
`define ALUOp_SRL   4'b0101
`define ALUOp_SLR   4'b0110
`define ALUOp_SRR   4'b0111
`define ALUOp_AND   4'b1000
`define ALUOp_OR    4'b1001
`define ALUOp_XOR   4'b1010
`define ALUOp_NOR   4'b1011
`define ALUOp_NAND  4'b1100
`define ALUOp_XNOR  4'b1101
`define ALUOp_BNE   4'b1110
`define ALUOp_SLT   4'b1111

`define ALUOp_ADDU  `ALUOp_ADD
`define ALUOp_SUBU  `ALUOp_SUB
`define ALUOp_ORI   `ALUOp_OR
`define ALUOp_LW    `ALUOp_ADD
`define ALUOp_SW    `ALUOp_ADD
`define ALUOp_BEQ   `ALUOp_SUB

