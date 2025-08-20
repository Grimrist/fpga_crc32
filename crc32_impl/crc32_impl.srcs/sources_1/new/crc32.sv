`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 09:10:02 PM
// Design Name: 
// Module Name: crc32
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


module crc32(
    input logic clk, rst, 
    input logic crc_trigger,
    output logic crc_busy, crc_finished,
    output logic [31:0] crc_out32
    );

    localparam POLY = 33'h04C1_1DB7;

    enum state {IDLE, BUSY, FINISHED} state, next_state;

    /* FSM that governs CRC functionality */
    always_ff @(posedge clk) begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;   
    end

    always_comb begin
        crc_busy = 'b0;
        crc_finished = 'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if(crc_trigger)
                    next_state = BUSY;
            end

            BUSY: begin
                crc_busy = 'b1;


            end

            FINISHED: begin
                crc_finished = 'b1;

            end
        endcase

    end

    /* Registers that hold our current and future value */

    always_ff @(posedge clk) begin
        if (rst | crc_trigger)
            crc_out32 = 32'hFFFF_FFFF;
        else
            crc_out32 = crc_out32;
    end




endmodule
