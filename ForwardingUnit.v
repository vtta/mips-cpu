module ForwardingUnit (
    input[4:0]  IFIDRs,
    input[4:0]  IFIDRt,
    input[4:0]  IDEXRs,
    input[4:0]  IDEXRt,
    input[4:0]  IDEXWriteReg,
    input[4:0]  EXMEMRd,
    input[4:0]  MEMWBRd,
    input       IDEXRegWrite,
    input       EXMEMRegWrite,
    input       MEMWBRegWrite,

    output reg[1:0] ForwardA,
    output reg[1:0] ForwardB,
    output reg[1:0] ForwardC,
    output reg[1:0] ForwardD

);


always @(*) begin


    if (EXMEMRegWrite && (EXMEMRd != 0)
        && (EXMEMRd == IDEXRs) ) 
        ForwardA <= 2'b10;
    else if(MEMWBRegWrite && (MEMWBRd != 0)
        && (MEMWBRd == IDEXRs) )
        ForwardA <= 2'b01;
    else ForwardA <= 2'b00;


    if (EXMEMRegWrite && (EXMEMRd != 0)
        && (EXMEMRd == IDEXRt) ) 
        ForwardB <= 2'b10;
    else if (MEMWBRegWrite && (MEMWBRd != 0) 
        && (MEMWBRd == IDEXRt) ) 
        ForwardB <= 2'b01;
    else ForwardB <= 2'b00;


    if (MEMWBRegWrite && (MEMWBRd != 0)
        && (MEMWBRd == IFIDRs) )
        ForwardC <= 2'b11;
    else if (EXMEMRegWrite && (EXMEMRd != 0)
        && (EXMEMRd == IFIDRs ) )
        ForwardC <= 2'b10;
    else if(IDEXRegWrite && (IDEXWriteReg !=0 )
        && (IFIDRs == IDEXWriteReg) )
        ForwardC <= 2'b01;
    else ForwardC <= 2'b00;


    if (MEMWBRegWrite && (MEMWBRd != 0)
        && (MEMWBRd == IFIDRt) )
        ForwardD <= 2'b11;
    else if (EXMEMRegWrite && (EXMEMRd != 0)
        && (EXMEMRd == IFIDRt ) )
        ForwardD <= 2'b10;
    else if(IDEXRegWrite && (IDEXWriteReg !=0 )
        && (IDEXWriteReg == IFIDRt) )
        ForwardD <= 2'b01;
    else ForwardD <= 2'b00;


end


endmodule
