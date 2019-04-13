
module GPR (
    input clk,          // Clock
    // input clk_en,    // Clock Enable
    input rst,          // Asynchronous reset active low
    
    input[4:0]  ReadRegister1,
    input[4:0]  ReadRegister2,
    input       RegWrite,
    input[4:0]  WriteRegister,
    input[31:0] WriteData,

    output[31:0] DataOut1,
    output[31:0] DataOut2
);

reg [31:0] gprRegisters[31:0];
assign DataOut1 = gprRegisters[ReadRegister1];
assign DataOut2 = gprRegisters[ReadRegister2];
integer i;

initial begin
    for (i = 0; i < 32; i++) begin
        gprRegisters[i] <= 0;
    end
end

always @(posedge rst) begin
    for (i = 0; i < 32; i++) begin
        gprRegisters[i] <= 0;
    end
end

always@(posedge clk)
begin
    gprRegisters[0] <= 0;
    if(RegWrite) begin
        gprRegisters[WriteRegister] <= WriteData;
    end
end

endmodule
