`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 12:57:38 AM
// Design Name: 
// Module Name: counter
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


module counter
    #(parameter N)
    (
    input logic clk, reset,
    output logic [N-1:0] count
    );
    
    always_ff @(posedge clk) begin
        if (reset)
            count <= 'b0;
        else
            count <= count+1;       
    end
endmodule
