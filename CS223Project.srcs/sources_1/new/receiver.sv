`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2024 16:58:45
// Design Name: 
// Module Name: receiver
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


module receiver#(parameter N = 8, depth = 4, parityBit = 1, stopBit = 1'b1, baudRate = 9600, clkFreq = 100_000_000)(
    input logic clk,
	input logic TX,
	output logic finish,
	output logic [N-1:0] RXBUF,
	output logic [depth-1:0][N-1:0] memoryArray
    );
    localparam baudClk = clkFreq/baudRate;
    typedef enum logic [1:0] {idleState, receiveState} typename;
    initial RXBUF = 8'b0;
	typename state;
	//logic [depth-1:0][N-1:0] memoryArray;
	initial memoryArray = 0;
	logic [3:0] bitCntr;
	logic isStart;
	logic divided_clk;
    logic [N-1:0] dataHolder;
    initial dataHolder = 8'b0;
    initial bitCntr = 4'b0;
    clockDivider#(baudClk)c2(clk,divided_clk);
    always_ff @(posedge divided_clk) begin
    
      case (state)
        idleState: begin
          finish <= 1'b0;
          dataHolder <= 8'b0; 
          bitCntr <= 0;
          if (TX == 1'b0) begin
            //
            //isStart <= 1;
            state <= receiveState;
            //baudCntr <= 0;

          end
        end
       
       

        receiveState: begin
        //if(~isStart) begin
           dataHolder[bitCntr] <= TX;
           bitCntr <= bitCntr + 1;
        //end
        /*else begin
            isStart <= 0;
            bitCntr <= 0;
        end */
        
          //baudCntr <= baudCntr + 1;
          //if (baudCntr == baudClk) begin
            //baudCntr <= 0;
            
            if (bitCntr == 9) begin
              finish <= 1'b1;
              RXBUF <= dataHolder;
              memoryArray[depth-4] <= dataHolder;
                memoryArray[depth-3] <= memoryArray[depth-4];
                memoryArray[depth-2] <= memoryArray[depth-3];
                memoryArray[depth-1] <= memoryArray[depth-2];
                state<=idleState;
             
            end
          end
        //end
        default: state <= idleState;
      endcase
    end
endmodule