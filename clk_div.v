//`timescale 1ns / 1ps
module clk_div (
    input CLK,
    input RST,
    input SW15,
    output CLK_CPU
);

// Clock divider

    reg[31:0]clkdiv;

    always @ (posedge CLK or posedge RST)
        begin
            if (RST)
                clkdiv <= 0;
            else
                clkdiv <= clkdiv + 1'b1;
        end

    assign CLK_CPU=(SW15)?clkdiv[8]:clkdiv[1];
    // assign CLK_CPU = clkdiv[8];

endmodule
