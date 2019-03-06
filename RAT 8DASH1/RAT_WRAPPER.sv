`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: Basic RAT_WRAPPER
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module RAT_WRAPPER(
    input CLK,
    input BTNC,
    input BTNR,
    input [7:0] SWITCHES, 
    output [7:0] LEDS,
    output [3:0] an,
    output [7:0] seg
    
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SEVEN_SEG    = 8'h81;  
    localparam SEVEN_SEG_2  = 8'h82;  
    
     
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic [15:0] r_sev_seg = 16'h0000;
//    logic [7:0] low_seg_out_sseg;
//    logic [7:0] high_seg_out_sseg;
    logic s_load;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_leds = 8'h00;
    // Declare RAT_CPU ///////////////////////////////////////////////////////
    RAT_MCU MCU (.IN_PORT(s_input_port), .OUT_PORT(s_output_port),
                .PORT_ID(s_port_id), .IO_STRB(s_load), .RESET(s_reset),
                .INTV(s_interrupt), .clk(s_clk_50));
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
    SevSegDisp sseg(
        .CLK    (CLK),              // 100 MHz clock
        .MODE   (1),             // 0 - display hex, 1 - display decimal
        .DATA_IN (r_sev_seg),
        .CATHODES (seg),
        .ANODES   (an)
        );  
        
    debounce_one_shot   DB_ONE_SHOT(
        .CLK    (s_clk_50),
        .BTN    (BTNR),
        .DB_BTN (s_interrupt)
        );
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
        else
            s_input_port = 8'h00;
    end
   
    // MUX for updating output registers /////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
            if (s_port_id == LEDS_ID)
                r_leds <= s_output_port;
            else if (s_port_id == SEVEN_SEG)
                r_sev_seg[7:0] <= s_output_port;
            else if (s_port_id == SEVEN_SEG_2)
                r_sev_seg[15:8] <= s_output_port;
        end
    end
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
 //   assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    assign LEDS = r_leds;
    
    endmodule
