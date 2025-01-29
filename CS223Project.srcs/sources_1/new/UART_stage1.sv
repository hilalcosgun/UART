`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2024 20:23:45
// Design Name: 
// Module Name: UART_stage1
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


module UART_stage1#(parameter N = 8, depth = 4, parityBit = 1, stopBit = 1'b1, baudRate = 9600, clkFreq = 100_000_000)(
    input logic clk,
	input logic reset,
	input logic [N-1:0] dataIn,
	input logic load,
	input logic transmit,
	input logic RX,
	output logic TX,
	//buttonD
	//input logic transmit, //buttonC
	//output logic finish,
	output logic [N-1:0] TXBUF,
	output logic [N-1:0] RXBUF
	
    );
    //logic TX;
    logic finish;
    logic finish2;
    transmitter t1(clk,reset,dataIn,load,transmit,finish,TX,TXBUF);
    receiver r1(clk,reset,RX,finish2,RXBUF);
    

endmodule
