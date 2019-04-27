module HazardUnit (
    input      Jump,
    input      BranchTaken,
    input      IDMemRead,
    input[4:0] IFRs,
    input[4:0] IFRt,
    input[4:0] IDRt,


    output reg Hazard
);

initial begin
    Hazard <= 1'b0;
end

always @(*) begin


    if (IDMemRead
    	&& (IDRt != 0)
        && (IDRt == IFRs
            || IDRt == IFRt) ) begin
        Hazard <= 1;
    end else begin
        Hazard <= Jump || BranchTaken;
    end


end


endmodule
