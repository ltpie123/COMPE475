`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       Universidad Pontificia Bolivariana
// Engineer:      Fabio Andres Guzman Figueroa
// 
// Create Date:    18:55:46 05/14/2012 
// Design Name: 
// Module Name:    data_path 
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

module data_path(
    input clk,
    input rst,
    input [7:0] data_in,
    input insel,
    input we,
    input [2:0] raa,
    input [2:0] rab,
    input [2:0] wa,
    input [2:0] opalu,
    input [2:0] sh,
    input selpc,
    input selk,
    input ldpc,
    input ldflag,
    input wr_en, rd_en,
    input [10:0] ninst_addr,
    input [7:0] kte,
    input [7:0] imm,
    input selimm,
    output [7:0] data_out,
    output [10:0] inst_addr,
    output [10:0] stack_addr,
    output reg z, c
);
    
    
    always @(posedge clk) begin
    end
    
    
    // Internal signals
    wire [7:0] regmux, muxkte, muximm;
    wire [7:0] portA, portB;
    wire [7:0] aluresu;
    wire zero, carry;
    wire [7:0] shiftout;
    reg [10:0] PC;
    wire [10:0] fifo_out;

    // Module instantiations
    regfile registros(
        .datain(regmux),
        .clk(clk),
        .we(we),
        .wa(wa),
        .raa(raa),
        .rab(rab),
        .porta(portA),
        .portb(portB)
    );

    ALU alui(
        .a(portA),
        .b(muximm),
        .result(aluresu),
        .opalu(opalu),
        .zero(zero),
        .carry(carry)
    );

    shiftbyte shif_reg(
        .din(aluresu),
        .dshift(shiftout),
        .sh(sh)
    );

    LIFO LIFOi(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(PC),
        .dout(fifo_out)
    );

    // Multiplexer assignments
    assign stack_addr = fifo_out + 1;
    assign regmux = insel ? shiftout : muxkte;
    assign muxkte = selk ? kte : data_in;
    assign muximm = selimm ? imm : portB;

    // Flag register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
            c <= 0;
        end else if (ldflag) begin
            z <= zero;
            c <= carry;
        end
    end

    // Program Counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 0;
            $display("Data Path Reset - PC set to 0");
        end else if (ldpc) begin
            if (selpc) begin
                PC <= ninst_addr;
                $display("PC updated to: %h", ninst_addr);
            end else begin
                PC <= PC + 1;
            end
        end
    end

    // Output assignments
    assign inst_addr = PC;
    assign data_out = shiftout;

endmodule