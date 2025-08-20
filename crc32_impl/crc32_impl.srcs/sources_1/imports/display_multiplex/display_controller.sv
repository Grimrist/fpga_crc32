`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 03:03:41 PM
// Design Name: 
// Module Name: S4_actividad1
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


module display_controller (
    input logic [31:0] HEX_in,
    input logic clock, reset,
    output logic [6:0] segments,
    output logic [7:0] anodes
    );
    
    logic [2:0] tdm_count; // Controls which anode is LOW
    logic [3:0] display_digit; // Controls digit being sent to display
    logic [6:0] segments_neg; // Negated segment outputs
    
    counter #(.N(3)) fourbit_counter (
        .clk(clock),
        .reset(reset),
        .count(tdm_count)
    );
    
    always_comb begin
        case (tdm_count)
            3'd0:   anodes = ~8'b0000_0001;
            3'd1:   anodes = ~8'b0000_0010;
            3'd2:   anodes = ~8'b0000_0100;
            3'd3:   anodes = ~8'b0000_1000;
            3'd4:   anodes = ~8'b0001_0000;
            3'd5:   anodes = ~8'b0010_0000;
            3'd6:   anodes = ~8'b0100_0000;
            3'd7:   anodes = ~8'b1000_0000;
        endcase
   end
   
   always_comb begin
        case (tdm_count)
            3'd0:   display_digit = HEX_in[3:0];
            3'd1:   display_digit = HEX_in[7:4];
            3'd2:   display_digit = HEX_in[11:8];
            3'd3:   display_digit = HEX_in[15:12];
            3'd4:   display_digit = HEX_in[19:16];
            3'd5:   display_digit = HEX_in[23:20];
            3'd6:   display_digit = HEX_in[27:24];
            3'd7:   display_digit = HEX_in[31:28];
        endcase
    end
    
    BCD_to_sevenSeg bcd_to_sevenseg(
        .BCD_in(display_digit),
        .sevenSeg(segments_neg)
    );
    
    assign segments = ~segments_neg;
    
    
endmodule
