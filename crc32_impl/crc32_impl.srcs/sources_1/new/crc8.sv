`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 09:41:28 PM
// Design Name: 
// Module Name: crc8
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


module crc8 #(parameter POLY=9'h2f) (
    input logic clk, rst, 
    input logic crc_trigger,
    input logic [31:0] data_in,
    output logic crc_busy, crc_finished,
    output logic [7:0] crc_out8
    );

    logic [8:0] crc_reg9;
    assign crc_out8 = crc_reg9[7:0];

    /* Registers that hold our current value */
    logic shift_in;
    logic [31:0] input_reg;
    logic [5:0] counter;
    
    always_ff @(posedge clk) begin
        if (rst || crc_trigger)
            counter <= 6'd32;
        else if (shift_in && counter != 'd0) 
            counter <= counter - 1;
    end

    always_ff @(posedge clk) begin
        if (rst)
            input_reg <= 'b0;
        else if (crc_trigger)
            input_reg <= data_in;
        else if (shift_in)
            input_reg <= input_reg << 1;
        else
            input_reg <= input_reg;
    end

    always_ff @(posedge clk) begin
        if (rst || crc_trigger)
            crc_reg9 <= {1'b0, 8'h00};
        else if (shift_in) begin
            if(crc_reg9[8] == 1'b1)
                crc_reg9 ^= POLY;
            if(counter != 'd0)
                crc_reg9 <= {crc_reg9[7:0], input_reg[31]};
        end
        else
            crc_reg9 = crc_reg9;
    end

    /* FSM that governs CRC functionality */
    enum logic [1:0] {IDLE, BUSY, FINISHED} state, next_state;

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
        shift_in = 'b0;

        case (state)
            IDLE: begin
                if(crc_trigger)
                    next_state = BUSY;
            end

            BUSY: begin
                crc_busy = 'b1;
                shift_in = 'b1;
                if(counter == 'b0)
                    next_state = FINISHED;
            end

            FINISHED: begin
                crc_finished = 'b1;
            end
        endcase

    end

endmodule
