`timescale 1ns / 1ps
`default_nettype none

`ifdef SYNTHESIS
`define FPATH(X) `"X`"
`else /* ! SYNTHESIS */
`define FPATH(X) `"../data/X`"
`endif  /* ! SYNTHESIS */

module word_sprite 
    (
        input wire pixel_clk,
        input wire rst,
        input wire [10:0] h_count,
        input wire [9:0]  v_count,
        input wire [9:0] sensor_hr,
        input wire [9:0] camera_hr,
        output logic [7:0] pixel_red,
        output logic [7:0] pixel_green,
        output logic [7:0] pixel_blue
    );
    logic [7:0] sen_img_red, sen_img_green, sen_img_blue;
    logic [31:0] sen_sprite_x;
    logic [31:0] sen_sprite_y;
    // 10922>>18 ~ 1/24
    assign sen_sprite_x = (h_count > 800 & h_count < 1208) ? 800 + 24*(((h_count - 800) * 10922) >> 18) : 800;
    assign sen_sprite_y = 150;

    // letter ordering based on letters.sv to spell out sensor heart rate
    logic [7:0] sensor [16:0];
    assign sensor[0] = 8'd5;
    assign sensor[1] = 8'd1;
    assign sensor[2] = 8'd6;
    assign sensor[3] = 8'd5;
    assign sensor[4] = 8'd7;
    assign sensor[5] = 8'd3;
    assign sensor[6] = 8'd10;
    assign sensor[7] = 8'd0;
    assign sensor[8] = 8'd1;
    assign sensor[9] = 8'd2;
    assign sensor[10] = 8'd3;
    assign sensor[11] = 8'd4;
    assign sensor[12] = 8'd10;
    assign sensor[13] = 8'd3;
    assign sensor[14] = 8'd2;
    assign sensor[15] = 8'd4;
    assign sensor[16] = 8'd1;

    letter_sprite #(
        .WIDTH(20),
        .HEIGHT(32)
    )
    sensor_sprite (
        .pixel_clk(pixel_clk),
        .rst(rst),
        .h_count(h_count),   
        .v_count(v_count),
        .x(sen_sprite_x),
        .y(sen_sprite_y),
        .letter_num(sensor[((h_count - 800) * 10922) >> 18]),
        .pixel_red(sen_img_red),
        .pixel_green(sen_img_green),
        .pixel_blue(sen_img_blue)
    );

    logic [2:0] sen_hr_red;
    logic [7:0] sen_hr_green, sen_hr_blue;
    logic [31:0] sen_hr_x, sen_hr_y;
    assign sen_hr_x = 932;
    assign sen_hr_y = 230;
    logic [2:0][3:0] sen_hr_digits;
    digits sensor_hr_dig (
        .clk(pixel_clk),
        .rst(rst),
        .number(sensor_hr),
        .digits(sen_hr_digits)
    );
    generate
        genvar i;
        for (i=0; i<3; i=i+1)begin
            number_sprite sensor_heartrate (
                .pixel_clk(pixel_clk),
                .rst(rst),
                .x(sen_hr_x+48*i), 
                .h_count(h_count),
                .y(sen_hr_y), 
                .v_count(v_count),
                .number_ind(sen_hr_digits[i]),
                .pixel_red(sen_hr_red[i]),
                .pixel_green(sen_hr_green),
                .pixel_blue(sen_hr_blue)
            );
        end
    endgenerate


    logic [7:0] cam_img_red, cam_img_green, cam_img_blue;
    logic [31:0] cam_sprite_x;
    logic [31:0] cam_sprite_y;
    assign cam_sprite_x = (h_count > 800 & h_count < 1208) ? 800 + 24*(((h_count - 800) * 10922) >> 18) : 800;
    assign cam_sprite_y = 340;

    // letter ordering based on letters.sv to spell out camera heart rate
    logic [7:0] camera [16:0];
    assign camera[0] = 8'd8;
    assign camera[1] = 8'd2;
    assign camera[2] = 8'd9;
    assign camera[3] = 8'd1;
    assign camera[4] = 8'd3;
    assign camera[5] = 8'd2;
    assign camera[6] = 8'd10;
    assign camera[7] = 8'd0;
    assign camera[8] = 8'd1;
    assign camera[9] = 8'd2;
    assign camera[10] = 8'd3;
    assign camera[11] = 8'd4;
    assign camera[12] = 8'd10;
    assign camera[13] = 8'd3;
    assign camera[14] = 8'd2;
    assign camera[15] = 8'd4;
    assign camera[16] = 8'd1;
    
    letter_sprite #(
        .WIDTH(20),
        .HEIGHT(32)
    )
    cam_sprite (
        .pixel_clk(pixel_clk),
        .rst(rst),
        .h_count(h_count),   
        .v_count(v_count),
        .x(cam_sprite_x),
        .y(cam_sprite_y),
        .letter_num(camera[((h_count - 800) * 10922) >> 18]),
        .pixel_red(cam_img_red),
        .pixel_green(cam_img_green),
        .pixel_blue(cam_img_blue)
    );

    logic [2:0] cam_hr_red;
    logic [7:0] cam_hr_green, cam_hr_blue;
    logic [31:0] cam_hr_x, cam_hr_y;
    assign cam_hr_x = 932;
    assign cam_hr_y = 420;
    logic [2:0][3:0] cam_hr_digits;
    digits camera_hr_dig (
        .clk(pixel_clk),
        .rst(rst),
        .number(camera_hr),
        .digits(cam_hr_digits)
    );
    generate
        genvar j;
        for (j=0; j<3; j=j+1)begin
            number_sprite camera_heartrate (
                .pixel_clk(pixel_clk),
                .rst(rst),
                .x(cam_hr_x+48*j), 
                .h_count(h_count),
                .y(cam_hr_y), 
                .v_count(v_count),
                .number_ind(cam_hr_digits[j]),
                .pixel_red(cam_hr_red[j]),
                .pixel_green(cam_hr_green),
                .pixel_blue(cam_hr_blue)
            );
        end
    endgenerate

    assign pixel_red = v_count < 200 ? sen_img_red : v_count < 300 ? (sen_hr_red>0 ? 8'hff : 0) : v_count < 400 ? cam_img_red : (cam_hr_red>0 ? 8'hff : 0);
    assign pixel_green = v_count < 200 ? sen_img_green : v_count < 300 ? sen_hr_green : cam_img_green;
    assign pixel_blue = v_count < 200 ? sen_img_blue : v_count < 300 ? sen_hr_blue : cam_img_blue;
    

endmodule



`default_nettype none

