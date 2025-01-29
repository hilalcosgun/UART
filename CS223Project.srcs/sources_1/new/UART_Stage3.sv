`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2024 15:59:23
// Design Name: 
// Module Name: UART_Stage3
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


module UART_Stage3#(parameter N = 8, depth = 4, parityBit = 1, stopBit = 1'b1, baudRate = 9600, clkFreq = 100_000_000)(
    input logic clk,
	input logic auto,
	input logic U,
	input logic L,
	input logic R,
	input logic [N-1:0] dataIn,
	input logic load,
	input logic transmit,
	input logic RX,
	output logic TX,
    output logic [N-1:0] TXBUF,
	output logic [N-1:0] RXBUF,
	 output logic [3:0] anode,
    output logic [6:0] cathode
	
        );
    logic [depth-1:0][N-1:0] memoryT;
    logic [depth-1:0][N-1:0] memoryR;
    logic finish;
    logic finish2;
    logic bU;
    logic bR;
    logic bL;
    butonDebouncer uDebouncer(clk,U,bU);
    butonDebouncer rDebouncer(clk,R,bR);
    butonDebouncer lDebouncer(clk,L,bL); 
    transmitter t1(clk,auto,dataIn,load,transmit,finish,TX,TXBUF,memoryT);
    receiver r1(clk,RX,finish2,RXBUF,memoryR);
    logic displayT;
    initial displayT = 1;
    logic [7:0] first;
    logic [1:0] index; 
    logic [depth-1:0][N-1:0] currArr;
    initial index = 0;
    //logic divided   
    always@(posedge clk) begin
        if(bU) begin
        index <= 0;
            if(displayT)
            displayT <= 0;
            else displayT <=1;
        end
        if(displayT)begin
            first <= 4'hA;
            if(bR) begin 
            if(index > 3) index <= 0;
            else index <= index +1;
            end
            else begin
                if(bL) begin
                
                if(index < 0) index <= 3;
                else index <= index -1;
            end
            end  
            currArr<=memoryT; 
        end
        else begin
            first <= 4'hb;
            if(bR) begin 
            index <= index +1;
            if(index > 2) index <= 0;
            end
            else begin
                if(bL) begin
                    index <= index -1;
                    if(index < 1) index <= 3;
            end
            end   
            currArr<=memoryR; 
        end     
     end
     fourDigitDisplay fdd(clk,first,index,currArr[index][7:4],currArr[index][3:0],anode,cathode);
endmodule
