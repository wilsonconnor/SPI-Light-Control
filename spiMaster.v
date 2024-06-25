module spiMaster(
    input clk,
    output reg SCLK,
    input MISO,
    output reg SS,
    input start,
    input reset,
    output reg [15:0] wordReg
    );
    
    localparam init = 0, a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7;
    reg [4:0] bitCnt;
    reg [2:0] cS;
    reg InReg;
    reg [31:0] delayTime;
    reg en;
    wire dn;
    
    delayCounter delay(.clk(clk), .reset(reset), .enable(en), .len(delayTime), .done(dn));
    
    always@(posedge clk)
    begin
        if(cS == init || reset == 1)
            bitCnt <= 0;
        else if (cS == c)
            bitCnt <= bitCnt + 1;
    end
    
    always@(posedge clk)
    begin
        if(reset)
            InReg <= 0;
        else if (cS == c)
            InReg <= MISO;           
    end
    
    always@(negedge clk)
    begin
        if(reset)
            wordReg <= 0;
        else if (cS == e)
            wordReg <= {wordReg[14:0], InReg};
    end
    
    always@(cS)
    begin
        case(cS)
            init:
                begin
                    SS = 1;
                    delayTime = 0;
                    en = 0;
                    SCLK = 0;
                end
            a:
                begin
                    SS = 0;
                    delayTime = 100;
                    en = 1;
                    SCLK = 0;
                end
            b:
                begin
                    SS = 0;
                    delayTime = 25;
                    en = 1;
                    SCLK = 0;
                end
            c:
                begin
                    SS = 0;
                    delayTime = 0;
                    en = 0;
                    SCLK = 0;
                end
            d:
                begin
                    SS = 0;
                    delayTime = 25;
                    en = 1;
                    SCLK = 1;
                end
            e:
                begin
                    SS = 0;
                    delayTime = 0;
                    en = 0;
                    SCLK = 1;
                end
            f:
                begin
                    SS = 0;
                    delayTime = 50;
                    en = 1;
                    SCLK = 0;
                end
            g:
                begin
                    SS = 1;
                    delayTime = 0;
                    en = 0;
                    SCLK = 0;
                end
        endcase
    end
    
    always@(posedge clk)
    begin
        if(reset)
            cS <= init;
        else case(cS)
            init:
                if(start)
                    cS <= a;
                else
                    cS <= init;
            
            a:
                if(dn)
                    cS <= b;
                else
                    cS <= a;
            
            b:
                if (dn)
                    cS <= c;
                else
                    cS <= b;
            
            c:
                cS <= d;
            
            d:
                if(dn)
                    cS <= e;
                else
                    cS <= d;
            
            e:
                if(bitCnt == 16)
                    cS <= g;
                else if (bitCnt == 8)
                    cS <= f;
                else
                    cS <= b;
                    
            f:
                if(dn)
                    cS <= a;
                else
                    cS <= f;
            
            g:
                if(dn)
                    cS <= init;
                else
                    cS <= g;
                    
            default: cS <= init;
            endcase          
    end    
endmodule
