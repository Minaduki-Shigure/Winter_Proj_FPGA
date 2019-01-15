`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:15:26
// Design Name: 
// Module Name: Duty_Counter
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


module Duty_Counter_1(
    input CLK,
    input cat_in,
    output reg [31:0] P_on,
    output reg [31:0] P_off
    );
    reg syn1;
    reg syn2;
    wire cat_in_pos;
    reg [31:0] P_on_reg;
    reg [31:0] P_off_reg;
    
    always @ (posedge CLK)
    begin
        syn1 <= cat_in;
        syn2 <= syn1;
    end
    assign cat_in_pos = syn1 & (~syn2);
    
    always @ (posedge CLK)
    begin
        if (cat_in_pos)
        begin
            P_on <= P_on_reg;
            P_off <= P_off_reg;
            P_on_reg <= 32'b0;
            P_off_reg <= 32'b0;
        end
        else if (syn1)
            P_on_reg <= P_on_reg + 1'b1;
        else
            P_off_reg <= P_off_reg + 1'b1;
    end
endmodule

module Duty_Counter_2(
    input CLK,
    input cat_in,
    output reg [31:0] P_on,
    output reg [31:0] P_off
    );
    reg syn1;
    reg syn2;
    wire cat_in_pos;
    reg [31:0] P_on_reg;
    reg [31:0] P_off_reg;
    reg [31:0] period_cnt;
    
    always @ (posedge CLK)
    begin
        syn1 <= cat_in;
        syn2 <= syn1;
    end
    assign cat_in_pos = syn1 & (~syn2);

    always @ (posedge CLK)
    begin
        if (cat_in_pos)
            period_cnt <= period_cnt + 1'b1;
        if (period_cnt == 32'd1000)
        begin
            P_on <= P_on_reg;
            P_off <= P_off_reg;
            P_on_reg <= 32'b0;
            P_off_reg <= 32'b0;
            period_cnt <= 32'b0;
        end
        else if (syn1)
            P_on_reg <= P_on_reg + 1'b1;
        else
            P_off_reg <= P_off_reg + 1'b1;
    end
endmodule

module Duty_Counter_3(
    input CLK,
    input cat_in,
    output reg [31:0] P_on,
    output reg [31:0] P_off
    );
    reg syn1;
    reg syn2;
    wire cat_in_pos;
    reg [31:0] P_on_reg;
    reg [31:0] P_off_reg;
    reg [31:0] period_cnt;
    
    always @ (posedge CLK)
    begin
        syn1 <= cat_in;
        syn2 <= syn1;
    end
    assign cat_in_pos = syn1 & (~syn2);

    always @ (posedge CLK)
    begin
        if (cat_in_pos)
            period_cnt <= period_cnt + 1'b1;
        if (period_cnt == 32'd5000)
        begin
            P_on <= P_on_reg;
            P_off <= P_off_reg;
            P_on_reg <= 32'b0;
            P_off_reg <= 32'b0;
            period_cnt <= 32'b0;
        end
        else if (syn1)
            P_on_reg <= P_on_reg + 1'b1;
        else
            P_off_reg <= P_off_reg + 1'b1;
    end
endmodule