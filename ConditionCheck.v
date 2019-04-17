module ConditionCheck (
    input[31:0] in0,
    input[31:0] in1,

    output reg  BranchTaken
);

initial begin
    BranchTaken <= 0;
end

always @(*) begin
    BranchTaken <= (in0 == in1);
end

endmodule
