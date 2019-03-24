
module DataMemory(DataOut,DataAddr,DataIn,DMemW,DMemR,CLK);
input [4:0]     DataAddr;
input [31:0]    DataIn;
input           DMemR;
input           DMemW;
input           CLK;

output[31:0] DataOut;

reg [31:0]  DataMemory[1023:0];

always@(posedge CLK)
begin
    if(DMemW) begin
        DataMemory[DataAddr] = DataIn;
    end
    
    for(int i=0;i<4;++i) begin
        $display("M[%2d-%2d]\t%8X\t%8X\t%8X\t%8X",i*4,i*4+3, DataMemory[i*4+0], DataMemory[i*4+1], DataMemory[i*4+2], DataMemory[i*4+3]);
    end
    if(DMemW) begin
        $display("M[ %4X]\t%8X", DataAddr, DataIn);
    end

end
assign DataOut = DataMemory[DataAddr];
endmodule
