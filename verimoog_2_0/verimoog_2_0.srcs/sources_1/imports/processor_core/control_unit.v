`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       Universidad Pontificia Bolivariana
// Engineer:      Fabio Andres Guzman Figueroa
// 
// Create Date:    19:48:58 05/14/2012 
// Design Name: 
// Module Name:    control_unit 
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

module control_unit(
    input clk,
    input rst,
    input [15:0] instruction,
    input z,
    input c,
    output reg [7:0] port_addr,
    output reg write_e,
    output reg read_e,
    output reg insel,
    output reg we,
    output reg [2:0] raa,
    output reg [2:0] rab,
    output reg [2:0] wa,
    output reg [2:0] opalu,
    output reg [2:0] sh,
    output reg selpc,
    output reg ldpc,
    output reg ldflag,
    output reg [10:0] naddress,
    output reg selk,
    output reg [7:0] KTE,
    input [10:0] stack_addr,
    output reg wr_en, rd_en,
    output reg [7:0] imm,
    output reg selimm,
    output reg [3:0] state
);
    
    // Reset synchronization
    reg reset_n_sync1, reset_n_sync2;
    wire reset_n;

    always @(posedge clk) begin
        reset_n_sync1 <= ~rst;
        reset_n_sync2 <= reset_n_sync1;
    end
    
    assign reset_n = reset_n_sync2;
    
    // State definitions
    parameter FETCH    = 4'b0000;
    parameter DECODE   = 4'b0001;
    parameter EXECUTE  = 4'b0010;
    parameter WRITEBACK = 4'b0011;

    // Instruction opcodes
    parameter LDI  = 5'b00010;  // Load Immediate
    parameter LDM  = 5'b00011;  // Load Memory
    parameter STM  = 5'b00100;  // Store Memory
    parameter CMP  = 5'b00101;  // Compare
    parameter ADD  = 5'b00110;  // Add
    parameter SUB  = 5'b00111;  // Subtract
    parameter JMP  = 5'b01011;  // Jump
    parameter JPZ  = 5'b01100;  // Jump if Zero
    parameter JNZ  = 5'b01101;  // Jump if Not Zero
    parameter JPC  = 5'b01110;  // Jump if Carry
    parameter JNC  = 5'b01111;  // Jump if Not Carry
    parameter RET  = 5'b10001;  // Return

    // Internal signals
    reg [3:0] state, next_state;
    wire [4:0] opcode;
    reg cond_met;  // For conditional jumps
    
    assign opcode = instruction[15:11];

    // Initial values
    initial begin
        state = FETCH;
        next_state = FETCH;
        port_addr = 8'h00;
        write_e = 1'b0;
        read_e = 1'b0;
        insel = 1'b0;
        we = 1'b0;
        raa = 3'b000;
        rab = 3'b000;
        wa = 3'b000;
        opalu = 3'b100;
        sh = 3'b100;
        selpc = 1'b0;
        ldpc = 1'b0;
        ldflag = 1'b0;
        naddress = 11'h000;
        selk = 1'b0;
        KTE = 8'h00;
        wr_en = 1'b0;
        rd_en = 1'b0;
        imm = 8'h00;
        selimm = 1'b0;
        cond_met = 1'b0;
    end

    // State register
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= FETCH;
            $display("Reset asserted - State set to FETCH");
        end else begin
            state <= next_state;
            $display("Time=%0t State transition: %h -> %h", $time, state, next_state);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            FETCH: next_state = DECODE;
            DECODE: next_state = EXECUTE;
            EXECUTE: next_state = WRITEBACK;
            WRITEBACK: next_state = FETCH;
            default: next_state = FETCH;
        endcase
    end

    // Condition evaluation for jumps
    always @(*) begin
        case (opcode)
            JPZ: cond_met = z;
            JNZ: cond_met = !z;
            JPC: cond_met = c;
            JNC: cond_met = !c;
            default: cond_met = 1'b0;
        endcase
    end

    // Control signals
    always @(posedge clk) begin
        if (!reset_n) begin
            // Reset all control signals
            port_addr <= 8'h00;
            write_e <= 1'b0;
            read_e <= 1'b0;
            insel <= 1'b0;
            we <= 1'b0;
            raa <= 3'b000;
            rab <= 3'b000;
            wa <= 3'b000;
            opalu <= 3'b100;
            sh <= 3'b100;
            selpc <= 1'b0;
            ldpc <= 1'b0;
            ldflag <= 1'b0;
            naddress <= 11'h000;
            selk <= 1'b0;
            KTE <= 8'h00;
            wr_en <= 1'b0;
            rd_en <= 1'b0;
            imm <= 8'h00;
            selimm <= 1'b0;
        end else begin
            case (state)
                FETCH: begin
                    // Clear control signals
                    we <= 1'b0;
                    selk <= 1'b0;
                    write_e <= 1'b0;
                    read_e <= 1'b0;
                    ldpc <= 1'b0;
                    rd_en <= 1'b0;
                    wr_en <= 1'b0;
                    $display("Time=%0t FETCH: PC hold", $time);
                end
                
                DECODE: begin
                    case (opcode)
                        LDI: begin
                            wa <= instruction[10:8];
                            KTE <= instruction[7:0];
                            $display("Time=%0t DECODE: LDI R%d, %h", 
                                    $time, instruction[10:8], instruction[7:0]);
                        end
                        
                        STM: begin
                            raa <= instruction[10:8];
                            port_addr <= instruction[7:0];
                            $display("Time=%0t DECODE: STM R%d, %h", 
                                    $time, instruction[10:8], instruction[7:0]);
                        end

                        CMP: begin
                            raa <= instruction[10:8];
                            rab <= instruction[7:5];
                            ldflag <= 1'b1;
                            opalu <= 3'b110;  // Subtraction for comparison
                        end

                        RET: begin
                            rd_en <= 1'b1;  // Enable stack read
                            $display("Time=%0t DECODE: RET (stack_addr=%h)", 
                                    $time, stack_addr);
                        end
                    endcase
                end
                
                EXECUTE: begin
                    case (opcode)
                        LDI: begin
                            selk <= 1'b1;
                            we <= 1'b1;
                            $display("Time=%0t EXECUTE: LDI active - selk=%b we=%b", 
                                    $time, selk, we);
                        end
                        
                        STM: begin
                            write_e <= 1'b1;
                            $display("Time=%0t EXECUTE: STM active - write_e=%b", 
                                    $time, write_e);
                        end
                        
                        JMP: begin
                            naddress <= instruction[10:0];
                            selpc <= 1'b1;
                            ldpc <= 1'b1;
                            $display("Time=%0t EXECUTE: JMP to %h", 
                                    $time, instruction[10:0]);
                        end

                        JPZ, JNZ, JPC, JNC: begin
                            if (cond_met) begin
                                naddress <= instruction[10:0];
                                selpc <= 1'b1;
                                ldpc <= 1'b1;
                                $display("Time=%0t EXECUTE: Conditional Jump taken to %h", 
                                        $time, instruction[10:0]);
                            end
                        end

                        RET: begin
                            naddress <= stack_addr;
                            selpc <= 1'b1;
                            ldpc <= 1'b1;
                            $display("Time=%0t EXECUTE: RET to %h", 
                                    $time, stack_addr);
                        end
                    endcase
                end
                
                WRITEBACK: begin
                    if (!selpc) begin
                        ldpc <= 1'b1;
                        $display("Time=%0t WRITEBACK: PC increment", $time);
                    end
                end
            endcase
        end
    end

endmodule