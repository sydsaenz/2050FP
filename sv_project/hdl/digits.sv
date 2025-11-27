`timescale 1ns / 1ps
`default_nettype none

module digits(
    input wire clk,
    input wire rst,
    input wire [9:0] number,
    output logic [2:0][3:0] digits
);
    logic [31:0] h_inter;
    logic [31:0] t_inter;
    logic [31:0] h_rem;
    typedef enum {
        H = 0,
        T = 1,
        OUT = 2
    } dig_state;
    
    dig_state state;
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= H;
        end else begin
            case(state) 
                H: begin
                    h_inter <= (number * 656) >> 16;
                    state <= T;
                end
                T: begin
                    t_inter <= ((number-h_inter*100)*205) >> 11;
                    h_rem <= (number-h_inter*100);
                    state <= OUT;
                end
                OUT: begin
                    digits[0] <= h_inter;
                    digits[1] <= t_inter;
                    digits[2] <= (h_rem-t_inter*10);
                    state <= H;
                end
            endcase
        end
    end

endmodule

`default_nettype none
