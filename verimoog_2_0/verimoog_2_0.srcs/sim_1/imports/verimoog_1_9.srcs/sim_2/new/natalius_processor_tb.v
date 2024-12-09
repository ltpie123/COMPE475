`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 07:32:22 AM
// Design Name: 
// Module Name: natalius_processor_tb
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

module natalius_processor_tb;
    // Testbench signals
    reg clk;
    reg rst;
    wire [7:0] port_addr;
    wire read_e;
    wire write_e;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Debug signals
    wire [15:0] instruction;
    wire [2:0] control_state;
    wire [7:0] reg_out;
    wire [10:0] pc;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Instantiate processor
    natalius_processor dut (
        .clk(clk),
        .rst(rst),
        .port_addr(port_addr),
        .read_e(read_e),
        .write_e(write_e),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Test program in instruction memory
    integer i;
    
    initial begin
        // Load test program into instruction memory
        $readmemh("instructions.mem", dut.inst_mem.rom);
        
        // Display loaded program
        $display("Loaded test program:");
        for ( i = 0; i < 16; i = i + 1)
            $display("Addr %0h: %h", i, dut.inst_mem.rom[i]);
    end

    // Test stimulus
    initial begin
        // Initialize
        rst = 1;
        data_in = 8'h00;

        // Wait 100ns for global reset
        #100;
        rst = 0;
        
        // Test sequence
        // Should execute:
        // 1. LDI R0, 0x55
        // 2. LDI R1, 0xAA
        // 3. STM R0, 0x00
        #200;

        // Monitor register values
        $display("R0 = %h", dut.data_path_i.registros.mem[0]);
        $display("R1 = %h", dut.data_path_i.registros.mem[1]);

        // Continue monitoring for a while
        #1000;
        $finish;
    end

    // Monitor important signals
    always @(posedge clk) begin
        $display("Time=%0t PC=%h Instruction=%h State=%d",
                 $time, dut.data_path_i.PC,
                 dut.inst_mem.instruction,
                 dut.control_unit_i.state);
        
        if (write_e)
            $display("Time=%0t Write to port %h: %h",
                     $time, port_addr, data_out);
    end

endmodule