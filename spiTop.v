module spiTop(
    input clk,
    input getVal,
    input reset,
    output [15:0] val,
    output SCLK,
    input MISO,
    output [7:0] seg,
    output [3:0] an,
    output SS
    );
    
    wire [7:0] dispVal;
    wire [15:0] wordReg;
    wire clkWaitDn, wait12cc, wait10cc;
    wire getValDB, getValDBoneShot, getValsynch;
    
    spiMaster spi(.clk(clk), .SCLK(SCLK), .MISO(MISO), .SS(SS), .start(getValDBoneShot), .reset(reset), .wordReg(wordReg));
    
    Synchronizer #(.NUMBITS(1)) synch1 (.clk(clk), .in(getVal), .out(getValSynch));
    deBounce dbGetVal(.clk(clk), .reset(reset), .in(getValSynch), .out(getValDB));
    oneShot getvalOS(.clk(clk), .in(getValDB), .reset(reset), .out(getValDBoneShot));
    
    assign val = wordReg;
    assign dispVal = wordReg[11:4];
    
    dispdHex dd1(.clk(clk), .reset(reset), .indata(dispVal), .sseg(seg), .latchAN(an));    
endmodule
