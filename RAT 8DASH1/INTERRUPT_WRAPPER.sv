module INTERRUPT_WRAPPER(
    input INTV,
    input I_SET,
    input I_CLR,
    input clk,
    output logic I_OUT
    );
    
    logic I_FLAG_OUT;
    
    I_FLAG  I_FLAG(
    .clk    (clk),
    .I_SET  (I_SET),
    .I_CLR  (I_CLR),
    .I_FLAG_OUT (I_FLAG_OUT)
    );
    
    assign I_OUT = INTV & I_FLAG_OUT;
    
endmodule