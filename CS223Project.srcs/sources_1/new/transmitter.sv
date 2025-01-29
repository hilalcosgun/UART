`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2024 16:59:05
// Design Name: 
// Module Name: transmitter
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


module transmitter#(parameter N = 8, depth = 4, parityBit = 1, stopBit = 1'b1, baudRate = 9600, clkFreq = 100_000_000)(
    input logic clk,
	input logic auto,
	input logic [N-1:0] dataIn,
	input logic load,//buttonD
	input logic transmit, //buttonC
	output logic finish,
	output logic TX,
	output logic [N-1:0] TXBUF,
	output logic [depth-1:0][N-1:0] memoryArray
    );
    localparam baudClk = clkFreq/baudRate;
    initial TX = 1;
    logic [1:0] autoCounter = 0;
    //integer index = 0;
    //integer testcount = 0; 
    //logic [15:0] baudCntr;
    logic [3:0] bitCntr;
    initial bitCntr = 4'b0;
    logic [N+1:0] dataHolder;
   // logic [depth-1:0][N-1:0] memoryArray;
    initial memoryArray = 0;
    logic divided_clk;
    typedef enum logic [2:0] {idleState,loadState,waitState,wait2State, transmitState, autoState} typename;
    typename state;
	
	clockDivider#(baudClk)c1(clk,divided_clk);
	
	always_ff @(posedge divided_clk) begin
    
      case (state)
        idleState: begin
          TX <= 1'b1;
          finish <= 1'b0;
          bitCntr <= 0;
          autoCounter <= 0;
          
          if (load&&~auto) begin
            //if(testcount == 0) begin
            TXBUF <= dataIn;
            memoryArray[depth-4] <= dataIn;
            memoryArray[depth-3] <= memoryArray[depth-4];
            memoryArray[depth-2] <= memoryArray[depth-3];
            memoryArray[depth-1] <= memoryArray[depth-2];
            state<= loadState;
           //testcount <=1; 
            
            //end
            end
     
         if(transmit)begin
            if(auto) begin
             state <= autoState;
            end
            else begin
            state <= transmitState;
            bitCntr <=0;
            end
            //baudCntr <= 0;
           
            end
         
         
            
    end
        loadState: begin
            dataHolder <= {stopBit, memoryArray[3], 1'b0};
            state<=waitState;
        end
        waitState: begin
        if(!load) state<=idleState;
        end
        
        wait2State: begin
        if(~transmit && ~auto) state <=idleState;
        if(auto) begin
            if(autoCounter < 3) begin
                autoCounter <= autoCounter +1;
                bitCntr <=0;
                state<=autoState;
             end
            else if(~transmit)state<=idleState;
        end
        end
        transmitState: begin
          TX <= dataHolder[bitCntr];
            bitCntr <= bitCntr + 1;
            if (bitCntr == 9) begin
              finish <= 1'b1;
              state <= wait2State;

            end
           end
        autoState: begin
        if(autoCounter < 4) begin
            dataHolder <= {stopBit, memoryArray[3-autoCounter], 1'b0};
            state<=transmitState;
        end
        else 
            state<= idleState;
    end
       default: state<=idleState;
      endcase
    end
	
endmodule
