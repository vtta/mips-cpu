
module Extender(
input  [15:0]       DataIn,
input               ExtOp,
output reg[31:0]    ExtOut
);


always @( DataIn or ExtOp ) begin
    ExtOut[31:0] <=  { ExtOp?{16{DataIn[15]}}:16'b0, DataIn[15:0] };
end


endmodule
