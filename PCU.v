module PCU (
    input clk,          // Clock
    // input clk_en,    // Clock Enable
    input rst,          // Asynchronous reset active low
    
    input       PCSrc,
    input       Jump,
    input[31:0] BranchAddr,
    input[31:0] JmpAddr,

    output reg[31:0] PC
);

always@(posedge rst) begin
    PC <= 32'h0000_3000;
end

always@(posedge clk) begin
    PC <= Jump?JmpAddr:(PCSrc?BranchAddr:(PC+4));
end


endmodule
