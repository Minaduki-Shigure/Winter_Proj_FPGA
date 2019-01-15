`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:15:26
// Design Name: 
// Module Name: SPI_Comm
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


module SPI_Comm(
    input CLK,
    input sCLK,
    input En,
    input CS,
    input [35:0] Data_snd,
    output reg SDO,
    input SDI,
    output reg [35:0] Data_rcv
    );
    reg snd_flag;
    reg rcv_flag;
    reg [35:0] snd_buf;
    reg [35:0] rcv_buf;
    reg [7:0] snd_step;
    reg [7:0] rcv_step;
    
    initial begin
        snd_flag <= 1'b0;
        rcv_flag <= 1'b1;
        snd_step <= 8'b0;
        rcv_step <= 8'b0;
    end
    
    always @ (posedge CLK)
    begin
        if (En)
        begin
            if (snd_flag == 0)
                snd_buf <= Data_snd;
        end
    end
    always @ (posedge CLK)
    begin
        if (En)
        begin
            if (rcv_flag == 0)
                Data_rcv <= rcv_buf;
        end
    end
    
    always @ (negedge sCLK or posedge CS)
    begin
        if (CS)
        begin
            snd_flag <= 1'b0;
            snd_step <= 8'b0;
        end
        else
        begin
            if (En)
            begin
                if (snd_step < 8'd35)
                begin
                    snd_step <= snd_step + 1'b1;
                    snd_flag <= 1'b1;
                end
                else
                begin
                    snd_step <= 8'b0;
                    snd_flag <= 1'b0;
                end
            end
            else
            begin
                snd_step <= 8'b0;
                snd_flag <= 1'b0;
            end
        end
    end
    always @ (posedge sCLK)
    begin
        if (En)
            if (CS == 0)
                SDO <= snd_buf[35 - snd_step];
    end
    
    always @ (posedge sCLK or posedge CS)
    begin
        if (CS)
        begin
            rcv_flag <= 1'b0;
            rcv_step <= 8'b0;
        end
        else
        begin
            if (En)
            begin
                if (rcv_step < 8'd36)
                begin
                    rcv_step <= rcv_step + 1'b1;
                    rcv_flag <= 1'b1;
                end
                else
                begin
                    rcv_step <= 8'b0;
                    rcv_flag <= 1'b0;
                end
            end
            else
            begin
                rcv_step <= 8'b0;
                rcv_flag <= 1'b0;
            end
        end
    end
    always @ (negedge sCLK)
    begin
        if (En)
        begin
            if (CS == 0)
                rcv_buf[36 - rcv_step] <= SDI;
        end
    end
endmodule
