`timescale 1ns / 1ps
`default_nettype none

`ifdef SYNTHESIS
`define FPATH(X) `"X`"
`else /* ! SYNTHESIS */
`define FPATH(X) `"../data/X`"
`endif  /* ! SYNTHESIS */

module number_sprite #(
        parameter WIDTH=40, HEIGHT=64)
    (
        input wire pixel_clk,
        input wire rst,
        input wire [10:0] x, h_count,
        input wire [9:0]  y, v_count,
        input wire [7:0] letter_num,
        output logic [7:0] pixel_red,
        output logic [7:0] pixel_green,
        output logic [7:0] pixel_blue
    );

    logic [7:0][4:0] letter;
    letters letters (
        .letter_num(letter_num),
        .letter(letter)
    );

    // calculate letter pixel address
    logic [32:0] letter_x;
    logic [32:0] letter_y;
    logic [4:0] pixel_color;
    logic next;
    always_ff @(posedge pixel_clk) begin
        if (next) begin
            next <= 0;
            pixel_color <= (letter[letter_y] & (5'd1 << (5'd4-letter_x))) > 0 ? 8'hff : 0;
        end else begin
            next <= 1;
            // size of pixel is what I divide by, 4x4 so divide by 4
            letter_x <= (h_count - x) >> 5'd2;
            letter_y <= (v_count - y) >> 5'd2;
        end
    end
    


    // logic [10:0] h_count_buf_ps10 [3:0];
    // logic [10:0] v_count_buf_ps10 [3:0];

    // always_ff @(posedge pixel_clk) begin
    //     h_count_buf_ps10 <= {h_count, h_count_buf_ps10[3:1]};
    //     v_count_buf_ps10 <= {v_count, v_count_buf_ps10[3:1]};
    // end

    logic in_sprite;
    assign in_sprite = ((h_count >= x && h_count < (x + WIDTH)) &&
                        (v_count >= y && v_count < (y + HEIGHT)));

    // Modify the module below to use your BRAMs!
    // this will not do anything without you doing that!
    assign pixel_red =    in_sprite ? pixel_color : 0;
    assign pixel_green =  in_sprite ? 0 : 0;
    assign pixel_blue =   in_sprite ? 0 : 0;

endmodule






`default_nettype none

