`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 07:49:20 PM
// Design Name: 
// Module Name: fsm_controller
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


module fsm_controller(
    input logic clk, btn, rst, crc_finished,
    output logic load_lsb16, load_msb16, crc_trigger,
    output logic [1:0] display_sel
    );
    
enum logic [2:0] {
    ENTER_LSB16,
    LOAD_LSB16,
    ENTER_MSB16,
    LOAD_MSB16,
    DISP_INPUT,
    CALC_CRC32,
    DISP_CRC32
} state, next_state;

always_ff @(posedge clk) begin
    if (rst)
        state <= ENTER_LSB16;
    else
        state <= next_state;
end

always_comb begin
    load_msb16 = 'b0;
    load_lsb16 = 'b0;
    display_sel = 'b0;
    crc_trigger = 'b0;
    next_state = state;

    case (state)
        ENTER_LSB16: begin
            if (btn)
                next_state = LOAD_LSB16;
        end

        LOAD_LSB16: begin
            load_lsb16 = 'b1;
            next_state = ENTER_MSB16;
        end

        ENTER_MSB16: begin
            if (btn)
                next_state = LOAD_MSB16;
        end

        LOAD_MSB16: begin
            load_msb16 = 'b1;
            next_state = DISP_INPUT;
        end

        DISP_INPUT: begin
            display_sel = 'b01;
            if (btn)
                next_state = CALC_CRC32;
        end

        CALC_CRC32: begin
            crc_trigger = 'b1;
            if (crc_finished)
                next_state = DISP_CRC32;
        end

        DISP_CRC32: begin
            display_sel = 'b10;
            if (btn)
                next_state = ENTER_LSB16;
        end
        
        default: begin
            next_state = LOAD_LSB16;
        end
    endcase
end

endmodule
