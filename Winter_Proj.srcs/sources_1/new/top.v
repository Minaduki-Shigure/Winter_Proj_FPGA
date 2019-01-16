`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 11:15:10
// Design Name: 
// Module Name: top
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


module top(
    input CLK,
    input CS,
    input sCLK,
    input flag,
    input signal,
    input signal1,
    input signal2,
    output SDO
    );
    
    wire [31:0] cnt1, cnt2;
    wire [31:0] duty_on, duty_off;
    wire [31:0] phase1, phase2, phase3;
    wire [31:0] phase, phase_flag;
    wire [35:0] data_to_send;
    wire [2:0] freq_high_flag_1;
    wire [2:0] freq_high_flag_2;
    wire [31:0] P_on_1, P_on_2, P_on_3, P_off_1, P_off_2, P_off_3;
    wire [31:0] P_on, P_off;
    wire [31:0] sp_result;

    wire CLK_100M;
    wire CLK_200M;
    //wire CLK_300M;
    
    Freq_Counter freq(
        .CLK(CLK_100M),
        .signal(signal),
        .cnt1_out(cnt1),
        .cnt2_out(cnt2)
        );
        
    Freq_Counter sp_unit(
        .CLK(CLK_100M),
        .signal(signal1),
        .cnt1_out(sp_result)
        );
        
    Duty_Counter_1 duty_fast(
        .CLK(CLK_200M),
        .cat_in(signal),
        .P_on(P_on_1),
        .P_off(P_off_1)
        );
    
    Duty_Counter_2 duty_mid(
        .CLK(CLK_200M),
        .cat_in(signal),
        .P_on(P_on_2),
        .P_off(P_off_2)
        );
        
    Duty_Counter_3 duty_slow(
        .CLK(CLK_200M),
        .cat_in(signal),
        .P_on(P_on_3),
        .P_off(P_off_3)
        );
    
    Phase_Counter_1 phase_fast(
        .CLK(CLK_100M),
        .M(signal1),
        .N(signal2),
        .P_on(phase1)
        );
    
    Phase_Counter_2 phase_mid(
        .CLK(CLK_100M),
        .M(signal1),
        .N(signal2),
        .P_on(phase2)
        );
    
    Phase_Counter_3 phase_slow(
        .CLK(CLK_100M),
        .M(signal1),
        .N(signal2),
        .P_on(phase3)
        );
    
    Data_Process data_main(
        .freq_cnt_1(cnt1),
        .freq_cnt_2(cnt2),
        .duty_on(duty_on),
        .duty_off(duty_off),
        .phase(phase),
        .phase_flag(phase_flag),
        .flag(flag),
        .data_to_send(data_to_send)
        );
    
    SPI_Comm spi_slave(
        .CLK(CLK_100M),
        .sCLK(sCLK),//JB0
        .En(1'b1),
        .CS(CS),//JB1
        .Data_snd(data_to_send),
        .SDO(SDO)//JB2
        //.SDI(),
        //.Data_rcv()
        );
        
    clk_pll clk_generator(
        .CLK_IN(CLK),
        .CLK_100M(CLK_100M),
        .CLK_200M(CLK_200M)
        );
        
    assign freq_high_flag_1 = (cnt1 > 32'd400000 ) ? 2'b1 : 2'b0;
    assign freq_high_flag_2 = (cnt1 > 32'd12000000) ? 2'b1 : 2'b0;
    assign duty_on = (freq_high_flag_2 == 0) ? (freq_high_flag_1 == 0 ? P_on_1 : P_on_2) : P_on_3;
    assign duty_off = (freq_high_flag_2 == 0) ? (freq_high_flag_1 == 0 ? P_off_1 : P_off_2) : P_off_3;
    assign phase = (sp_result > 1600000) ? phase3 : (sp_result > 200000 ? phase2 : phase1); 
    assign phase_flag = (sp_result > 1600000) ? 32'd3 : (sp_result > 200000 ? 32'd2 : 32'd1);     
endmodule

module Data_Process(
    input[31:0] freq_cnt_1,
    input[31:0] freq_cnt_2,
    input[31:0] duty_on,
    input[31:0] duty_off,
    input[31:0] phase,
    input[31:0] phase_flag,
    input flag,
    output reg [35:0] data_to_send
    );
    wire [35:0] data1;
    wire [35:0] data2;
    wire [35:0] data3;
    wire [35:0] data4;
    wire [35:0] data5;
    wire [35:0] data6;
    reg [2:0] part = 1;
    
    assign data1 = {4'b0001,freq_cnt_1};
    assign data2 = {4'b0010,freq_cnt_2};
    assign data3 = {4'b0011,duty_on};
    assign data4 = {4'b0100,duty_off};//Different from the sample
    assign data5 = {4'b0101,phase};
    assign data6 = {4'b0110,phase_flag};
    
    always @ (negedge flag)
    begin
        case (part)
            1: data_to_send <= data1;
            2: data_to_send <= data2;
            3: data_to_send <= data3;
            4: data_to_send <= data4;
            5: data_to_send <= data5;
            6: data_to_send <= data6;
            default: data_to_send <= data1;
        endcase
        part <= part + 1'b1;
    end
endmodule