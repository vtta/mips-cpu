
module GPR(DataOut1,DataOut2,CLK,WriteData,RegWrite,WriteRegisterSelect,ReadRegister1,ReadRegister2);
input CLK;
input RegWrite;
input [4:0] WriteRegisterSelect,ReadRegister1,ReadRegister2;
input [31:0] WriteData;

output [31:0] DataOut1,DataOut2;

reg [31:0] gprRegisters[31:0];

initial
begin
    gprRegisters[0] = 0;
end

always@(posedge CLK)
begin
    gprRegisters[0] = 0;
    if(RegWrite) begin
        gprRegisters[WriteRegisterSelect] = WriteData;
    end
    $display("=====================================");
    for(int i=0;i<8;++i) begin
        $display("R[%2d-%2d]\t%8X\t%8X\t%8X\t%8X",i*4,i*4+3, gprRegisters[i*4+0], gprRegisters[i*4+1], gprRegisters[i*4+2], gprRegisters[i*4+3]);
    end
    if(RegWrite) begin
        $display("R[ %4d]\t%8X", WriteRegisterSelect, gprRegisters[WriteRegisterSelect]);
    end
end
assign DataOut1 = gprRegisters[ReadRegister1];
assign DataOut2 = gprRegisters[ReadRegister2];

endmodule
