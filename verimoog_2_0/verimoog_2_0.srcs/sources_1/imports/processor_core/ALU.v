`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:06 05/02/2012 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    input [7:0] a,
    input [7:0] b,
    output [7:0] result,
    input [2:0] opalu,
    output zero,
    output carry
);

    reg [7:0] resu;
    reg carry_out;

    // ALU operations
    always @(*) begin
        carry_out = 0;
        case (opalu)
            3'b000: begin  // NOT
                resu = ~a;
            end
            3'b001: begin  // AND
                resu = a & b;
            end
            3'b010: begin  // XOR
                resu = a ^ b;
            end
            3'b011: begin  // OR
                resu = a | b;
            end
            3'b100: begin  // PASS A
                resu = a;
            end
            3'b101: begin  // ADD
                {carry_out, resu} = a + b;
            end
            3'b110: begin  // SUB
                resu = a - b;
                carry_out = (a < b);
            end
            default: begin // INCREMENT
                {carry_out, resu} = a + 8'h01;
            end
        endcase
    end

    // Output assignments
    assign zero = (resu == 8'h00);
    assign result = resu;
    assign carry = carry_out;

endmodule

