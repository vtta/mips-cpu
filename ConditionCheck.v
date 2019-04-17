module ConditionCheck (
    input[31:0] in0,
    input[31:0] in1,

    output reg  Equal
);

initial begin
    Equal <= 0;
end

always @(*) begin
    Equal <= (in0 == in1);
end

endmodule
