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

    // Clock and reset
    reg clk;
    reg rst;
    
    // I/O signals
    wire [7:0] port_addr;
    wire read_e;
    wire write_e;
    reg [7:0] data_in;
    wire [7:0] data_out;
    
    // Internal signals for monitoring
    wire [15:0] instruction;
    wire [10:0] inst_addr;
    wire z, c;
    
    // Instantiate the processor
    natalius_processor dut (
        .clk(clk),
        .rst(rst),
        .port_addr(port_addr),
        .read_e(read_e),
        .write_e(write_e),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    // Clock generation - 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Task for reset sequence
    task reset_processor;
        begin
            // Initial values
            data_in = 8'h00;
            
            // Assert reset for 4 clock cycles
            rst = 1;
            repeat(4) @(posedge clk);
            
            // Deassert reset and wait 2 cycles
            @(negedge clk) rst = 0;
            repeat(2) @(posedge clk);
            
            $display("Reset sequence completed at %t", $time);
        end
    endtask
    
    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("natalius_processor_tb.vcd");
        $dumpvars(0, natalius_processor_tb);
        
        // Start simulation time reporting
        $timeformat(-9, 2, " ns", 20);
        $display("Starting Natalius Processor Testbench at %t", $time);
        
        // Perform reset sequence
        reset_processor();
        
        // Wait for first few instructions to execute
        repeat(5) @(posedge clk);
        
        // Monitor instruction execution
        $display("Beginning instruction execution monitoring");
        
        // Test external data input
        data_in = 8'hAA;
        repeat(5) @(posedge clk);
        
        // Additional test sequences here...
        
        // Run for a few more cycles
        repeat(20) @(posedge clk);
        
        // End simulation
        $display("Testbench completed at %t", $time);
        $finish;
    end
    
    // Monitor processor state
    always @(posedge clk) begin
        $display("Time=%t: PC=%h, Instruction=%h, State=%d", 
                 $time, dut.data_path_i.PC, instruction, dut.control_unit_i.state);
                 
        if (write_e || read_e)
            $display("Time=%t: Memory Access - Addr=%h, Write=%b, Read=%b, Data=%h",
                    $time, port_addr, write_e, read_e, data_out);
    end

endmodule