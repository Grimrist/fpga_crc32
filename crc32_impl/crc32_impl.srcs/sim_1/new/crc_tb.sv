`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 10:17:34 PM
// Design Name: 
// Module Name: crc_tb
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


module crc_tb();

logic clk, rst, crc_trigger, crc_busy, crc_finished;
logic [31:0] data_in;
logic [7:0] crc_out8;

crc8 #(.POLY(9'ha7)) DUT(.*);

always #5 clk = ~clk;

initial begin
    clk = 'b0;
    rst = 'b0;
    crc_trigger = 'b0;
    data_in = 32'h1234_5678;
    #4
    rst = 'b1;
    #5
    rst = 'b0;
    #5
    crc_trigger = 'b1;
    #5
    crc_trigger = 'b0;
    #1000
    $finish;
end

endmodule
