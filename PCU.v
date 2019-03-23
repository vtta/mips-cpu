`include "signal_def.v"

module PCU(PC,RST,PCSrc,CLK,Adress);


input   RST;
input   PCSrc;
input   CLK;
input   [31:0] Adress;

output reg[31:0] PC;

reg [31:0] aluResAddr;

always@(posedge CLK or posedge RST) begin
    if(RST == 1) begin
        PC <= 32'h0000_3000;
    end
    PC = PC+4;
    for(int i=2;i<32;++i) begin
        aluResAddr[i] = Adress[i-2];
    end
    aluResAddr[1:0] = 2'b00;
    aluResAddr = aluResAddr + PC;
    PC=(PCSrc)?aluResAddr:PC;
end




endmodule


