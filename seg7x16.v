//`timescale 1ns / 1ps
module seg7x16 (
    input CLK,
    input RST,
    // input cs,
    input [31:0] inputData,
    output  [7:0] tubeDisplay,
    output  [7:0] tubeSelect
);

    reg [31:0] inputDataReg;
    reg [14:0] cnt;
    reg [2:0] tubeAddress;
    reg [7:0] tubeSelectReg;
    reg [7:0] charToDisplay;
    reg [7:0] tubeDisplayReg;
    wire tubeClock = cnt[14];
    assign tubeSelect  = tubeSelectReg;
    assign tubeDisplay = tubeDisplayReg;


    // 100MHz    -> 6103.5Hz 0.00016384s ?
    // 390,625Hz -> 0.42Hz   23.84s      ?
    always @ (posedge CLK, posedge RST) begin
        if (RST)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
    end



    always @ (posedge CLK, posedge RST) begin
        if(RST)
            inputDataReg <= 0;
        else // if(cs)
            inputDataReg <= inputData;
    end // always (clk, resrt)



    always @ (posedge tubeClock, posedge RST) begin
        if(RST)
            tubeAddress <= 0;
        else
            tubeAddress <= tubeAddress + 1'b1;
    end



    always @ (*) begin
        case(tubeAddress)
            7:  tubeSelectReg = 8'b01111111;
            6:  tubeSelectReg = 8'b10111111;
            5:  tubeSelectReg = 8'b11011111;
            4:  tubeSelectReg = 8'b11101111;
            3:  tubeSelectReg = 8'b11110111;
            2:  tubeSelectReg = 8'b11111011;
            1:  tubeSelectReg = 8'b11111101;
            0:  tubeSelectReg = 8'b11111110;
        endcase
    end // always(*)




    always @ (*) begin
        case(tubeAddress)
            0:  charToDisplay = inputDataReg[3:0];
            1:  charToDisplay = inputDataReg[7:4];
            2:  charToDisplay = inputDataReg[11:8];
            3:  charToDisplay = inputDataReg[15:12];
            4:  charToDisplay = inputDataReg[19:16];
            5:  charToDisplay = inputDataReg[23:20];
            6:  charToDisplay = inputDataReg[27:24];
            7:  charToDisplay = inputDataReg[31:28];
        endcase
    end // always(*)



    //unsigned char Number[16] =
    // Common cathode {0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71};
    // Common athode  {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0x88,0x83,0xc6,0xa1,0x86,0x8e};
    //                  0    1    2    3   4    5    6    7    8    9    a    b     c    d    e    f
    //      a
    //     ---
    //   f| g |b
    //    ---
    //  e|   |c
    //    --- .h
    //     d
    always @ (posedge CLK, posedge RST) begin
        if(RST)
            tubeDisplayReg <= 8'hff;
        else begin
            case(charToDisplay)
                4'h0:   tubeDisplayReg <= 8'hC0;
                4'h1:   tubeDisplayReg <= 8'hF9;
                4'h2:   tubeDisplayReg <= 8'hA4;
                4'h3:   tubeDisplayReg <= 8'hB0;
                4'h4:   tubeDisplayReg <= 8'h99;
                4'h5:   tubeDisplayReg <= 8'h92;
                4'h6:   tubeDisplayReg <= 8'h82;
                4'h7:   tubeDisplayReg <= 8'hF8;
                4'h8:   tubeDisplayReg <= 8'h80;
                4'h9:   tubeDisplayReg <= 8'h90;
                4'hA:   tubeDisplayReg <= 8'h88;
                4'hB:   tubeDisplayReg <= 8'h83;
                4'hC:   tubeDisplayReg <= 8'hC6;
                4'hD:   tubeDisplayReg <= 8'hA1;
                4'hE:   tubeDisplayReg <= 8'h86;
                4'hF:   tubeDisplayReg <= 8'h8E;
            endcase
        end // else
    end


endmodule
