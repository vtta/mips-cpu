
module DataMemory (
    input clk,          // Clock
    // input clk_en,    // Clock Enable
    input rst,          // Asynchronous reset active low

    input[4:0]  DataAddr,
    input[31:0] DataIn,
    input       DMemR,
    input       DMemW,

    output[31:0] DataOut
);


reg [31:0] DataMemory[31:0];
assign DataOut = DataMemory[DataAddr];
integer i;

initial begin
    for (i = 0; i < 32; i++) begin
        DataMemory[i] <= 0;
    end
end

always @(posedge rst) begin
    for (i = 0; i < 32; i++) begin
        DataMemory[i] <= 0;
    end
end

always@(negedge clk)
begin
    if(DMemW) begin
        DataMemory[DataAddr] <= DataIn;
    end
end

endmodule
