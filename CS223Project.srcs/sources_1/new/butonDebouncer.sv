`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 00:20:45
// Design Name: 
// Module Name: butonDebouncer
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


module butonDebouncer(
input logic clk, btn,
        output logic debounced_btn
    );
    
    
    integer timer = 0;
    
    typedef enum logic [1:0] {idle, debounce, stall} tstate;
        tstate [1:0] state;
   
    always_ff @(posedge clk) begin
       case (state)
        idle: begin
            debounced_btn <= 0;
            if(btn) begin
                timer <=0;
                state<=debounce;
            end
            else if (!btn) begin
                state <= idle;
            end
        end  
        
        debounce: begin
        timer <= timer+1;
        if(timer >= 20000)begin 
            debounced_btn <= 1;
            state<=stall;
        end 
        end
        
        stall: begin
            debounced_btn <= 0;
            if( btn) begin
                debounced_btn <= 0;
            end
            else begin
                state <= idle;
            end
        end   
        endcase

    end 
endmodule
