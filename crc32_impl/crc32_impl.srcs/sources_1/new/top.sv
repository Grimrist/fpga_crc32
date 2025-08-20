`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 07:48:22 PM
// Design Name: 
// Module Name: crc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module top
(
    input logic [15:0] SW,
    input logic CLK100MHZ, BTNC, CPU_RESETN,
    output logic CA, CB, CC, CD, CE, CF, CG, DP,
    output logic [7:0] AN
);
    
    assign DP = 1'b1;
    logic [7:0] segments;
    assign {CA,CB,CC,CD,CE,CF,CG} = segments;

    /* Wires for triggering data stores and crc calculation */
    logic load_lsb16, load_msb16, crc_trigger, crc_finished, crc_busy;

    /* 16-big registers used to store user input */
    logic [15:0] reg_lsb16, reg_msb16;
    logic [31:0] reg_in32 = {reg_msb16, reg_lsb16};

    always_ff @(posedge CLK100MHZ) begin
        if(~CPU_RESETN)
            reg_lsb16 = 'b0;
        else if(load_lsb16)
            reg_lsb16 = SW;
        else
            reg_lsb16 = reg_lsb16;
    end

    always_ff @(posedge CLK100MHZ) begin
        if(~CPU_RESETN)
            reg_msb16 = 'b0;
        else if(load_msb16)
            reg_msb16 = SW;
        else
            reg_msb16 = reg_msb16;
    end

    /* CRC8 module */
    logic [7:0] crc_out8;
    
    crc8 crc(
        .clk(CLK100MHZ),
        .rst(~CPU_RESETN),
        .data_in(reg_in32),
        .crc_busy,
        .crc_finished,
        .crc_out8
    );

    /* Display selector
        00: Current user input (instant) 
        01: Stored user input (full 32-bit from reg) 
        10: Calculated CRC32, in hex
        11: UNUSED, defaults to user input
    */
    logic [1:0] display_sel;
    logic [31:0] disp_in;

    always_comb begin
        if (display_sel == 'b01)
            disp_in = reg_in32;
        else if (display_sel == 'b10)
            disp_in = {24'b0, crc_out8};
        else
            disp_in = {16'b0, SW};
    end

    /* Controller modules (input state machine, 7seg controller) */
    fsm_controller crc_fsm (
        .clk(CLK100MHZ),
        .rst(~CPU_RESETN),
        .btn(BTNC),
        .crc_finished,
        .crc_trigger,
        .display_sel
    );

    display_controller display (
        .HEX_in(disp_in),
        .clock(CLK100MHZ),
        .reset(~CPU_RESETN),
        .segments,
        .anodes(AN)
    );

endmodule
