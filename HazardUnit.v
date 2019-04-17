module HazardUnit (
    input      Jump,
    input      BranchTaken,

    output reg Hazard
);

initial begin
    Hazard <= 1'b0;
end

always @(*) begin

    Hazard <= Jump || BranchTaken;

end


endmodule
