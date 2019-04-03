`include "signal_def.v"

module PCU(
    input RST,
    input CLK,
    input Jump,
    input Branch,
    input ALUZero,
    input [5:0]  Op,
    input [25:0] JumpTarget,
    input [31:0] BranchAddress,
    output [31:0] PCRegDataOut);

initial begin
    // PC = 32'h0000_3000;
end

wire [31:0] PCRegDataIn;
reg [31:0] PCRegDataOut;
reg [31:0] PC;

wire [31:0] PCAdd4Out = PCRegDataOut + 4;
wire [31:0] JumpAddress = {PCAdd4Out[31:28], JumpTarget[25:0], 2'b00};

wire [31:0] BranchAddressALUOut = PCAdd4Out + (BranchAddress<<2);
wire BranchAddressMuxSelect = Branch & ALUZero;


wire [31:0] Mux2Mux;
Mux32_2x1 PC_BranchAddressMux(.select(BranchAddressMuxSelect), 
          .in0(PCAdd4Out), 
          .in1(BranchAddressALUOut), 
          .out(Mux2Mux));
Mux32_2x1 PC_JumpAddressMux(.select(Jump), 
          .in0(Mux2Mux), 
          .in1(JumpAddress), 
          .out(PCRegDataIn));

always@(posedge RST) begin
    PC <= 32'h0000_3000;
end


always@(posedge CLK) begin
    PC = PCRegDataIn;
    PCRegDataOut = PC;
end



endmodule
