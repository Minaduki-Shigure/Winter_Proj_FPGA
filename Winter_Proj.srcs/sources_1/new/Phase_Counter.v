`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:15:26
// Design Name: 
// Module Name: Phase_Counter
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


module Phase_Counter_1(
    input CLK,
    input M,
    input N,
    output reg [31:0] P_on,
    output reg [31:0] P_off
    );
    reg XOR_out;
    reg syn1;
    wire cat_in_pos;
    reg [31:0] P_on_reg;
    reg [31:0] P_off_reg;
    
    always @ (posedge CLK)
    begin
        XOR_out <= M ^ N;
        syn1 <= XOR_out;
    end
    assign cat_in_pos = XOR_out & (~syn1);
    
    always @ (posedge CLK)
    begin
        if (cat_in_pos)
        begin
            P_on <= P_on_reg;
            P_off <= P_off_reg;
            P_on_reg <= 32'b0;
            P_off_reg <= 32'b0;
        end
        else if (XOR_out)
            P_on_reg <= P_on_reg + 1'b1;
        else
            P_off_reg <= P_off_reg + 1'b1;
    end
endmodule

module Phase_Counter_2(
    input CLK,
    input M,
    input N,
    output reg [31:0] P_on,
    output reg [31:0] P_off
    );
    reg XOR_out;
    reg syn1;
    wire cat_in_pos;
    reg [31:0] P_on_reg;
    reg [31:0] P_off_reg;
    reg [31:0] phase_cnt;
    
    always @ (posedge CLK)
    begin
        XOR_out <= M ^ N;
        syn1 <= XOR_out;
    end
    assign cat_in_pos = XOR_out & (~syn1);
    
    always @ (posedge CLK)
    begin
        if (cat_in_pos)
            phase_cnt <= phase_cnt + 1'b1;
        if (phase_cnt == 32'd2000)
        begin
            P_on <= P_on_reg;
            P_off <= P_off_reg;
            P_on_reg <= 32'b0;
            P_off_reg <= 32'b0;
            phase_cnt <= 32'b0;
        end
        else if (XOR_out)
            P_on_reg <= P_on_reg + 1'b1;
        else
            P_off_reg <= P_off_reg + 1'b1;
    end
endmodule

module Phase_Counter_3(
    input CLK,
    input M,
    input N,
    output reg [31:0] P_on,
    output reg [31:0] P_off
    );
    reg XOR_out;
    reg syn1;
    wire cat_in_pos;
    reg [31:0] P_on_reg;
    reg [31:0] P_off_reg;
    reg [31:0] phase_cnt;
    
    always @ (posedge CLK)
    begin
        XOR_out <= M ^ N;
        syn1 <= XOR_out;
    end
    assign cat_in_pos = XOR_out & (~syn1);
    
    always @ (posedge CLK)
    begin
        if (cat_in_pos)
            phase_cnt <= phase_cnt + 1'b1;
        if (phase_cnt == 32'd20000)
        begin
            P_on <= P_on_reg;
            P_off <= P_off_reg;
            P_on_reg <= 32'b0;
            P_off_reg <= 32'b0;
            phase_cnt <= 32'b0;
        end
        else if (XOR_out)
            P_on_reg <= P_on_reg + 1'b1;
        else
            P_off_reg <= P_off_reg + 1'b1;
    end
endmodule