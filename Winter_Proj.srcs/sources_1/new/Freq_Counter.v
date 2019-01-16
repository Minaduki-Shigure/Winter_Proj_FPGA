`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:15:26
// Design Name: 
// Module Name: Freq_Counter
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


module Freq_Counter(
    input CLK,
    input signal,
    output [31:0] cnt1_out,
    output [31:0] cnt2_out
    );
    wire CLK_10k;
    wire pre_gate;
    wire act_gate_out;
    
    CLK_out_10k(.CLK(CLK),.CLK_10k(CLK_10k));    
    PreGate pre(.CLK(CLK),.gate_out(pre_gate));
    ActGate act(.signal(signal),.gate_in(pre_gate),.gate_out(act_gate_out));
    counter cnt1(.signal(signal),.gate(act_gate_out),.cnt_out(cnt1_out));
    counter cnt2(.signal(CLK_10k),.gate(act_gate_out),.cnt_out(cnt2_out));
endmodule

module CLK_out_10k(
    input CLK,
    output reg CLK_10k
    );
    reg gate_buf;
    reg [31:0] cnt;
    
    always @ (posedge CLK)
    begin
        if (cnt == 32'd10000)
        begin
            gate_buf <= ~gate_buf;
            CLK_10k <= gate_buf;
            cnt <= 32'd0;
        end
        else
            cnt <= cnt + 1'b1;
    end
endmodule

module PreGate(
    input CLK,
    output reg gate_out
    );
    reg gate_buf;
    reg [31:0] cnt;
    
    always @ (posedge CLK)
    begin
        if (cnt == 32'd100000000)
        begin
            gate_buf <= ~gate_buf;
            gate_out <= gate_buf;
            cnt <= 32'd0;
        end
        else
            cnt <= cnt + 1'b1;
    end
endmodule

module ActGate(
    input signal,
    input gate_in,
    output reg gate_out
    );
    always @ (posedge signal)
        gate_out <= gate_in;
endmodule

module counter(
    input signal,
    input gate,
    output reg [31:0] cnt_out
    );
    reg [31:0] cnt;
    reg gate_buf;
    
    always @ (posedge signal)
        gate_buf <= gate;
    
    always @ (posedge signal)
    begin
        if ((gate == 1'b1) && (gate_buf == 1'b0))
            cnt <= 32'b1;
        else if ((gate == 1'b0) && (gate_buf == 1'b1))
            cnt_out <= cnt;
        else if (gate_buf == 1'b1)
            cnt <= cnt + 1'b1;
    end
endmodule