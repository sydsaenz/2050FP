`timescale 1ns / 1ps
`default_nettype none
 
module tmds_encoder(
        input wire clk,
        input wire rst,
        input wire [7:0] video_data,  // video data (red, green or blue)
        input wire [1:0] control,   //for blue set to {vs,hs}, else will be 0
        input wire video_enable,    //choose between control (0) or video (1)
        output logic [9:0] tmds
    );
    logic [8:0] q_m;
 
    tm_choice mtm(
        .d(video_data),
        .q_m(q_m)
    );

    logic [3:0] ones;
    always_comb begin
        ones = 0;
        for (int i = 0; i<8; i = i + 1) begin
            ones = q_m[i] == 1 ? ones + 1 : ones;
        end
    end
 
    //your code here.
    logic [4:0] cnt;
    always_ff @( posedge clk ) begin 
        if (rst) begin
            cnt <= 0;
            tmds <= 0;
        end else if (video_enable) begin
            if (cnt==0 || ones == 4) begin
                // tmds <= {~q_m[8], q_m[8], q_m[8] ? q_m[7:0] : ~q_m[7:0]};
                if (q_m[8] == 0) begin
                    tmds <= {~q_m[8], q_m[8], ~q_m[7:0]};
                    cnt <= cnt + 5'd8 - ones - ones;
                end else begin
                    tmds <= {~q_m[8], q_m[8], q_m[7:0]};
                    cnt <= cnt + ones + ones - 5'd8;
                end 
            end else begin
                if ((cnt[4] == 0 && ones > 4) || (cnt[4]==1 && ones < 4)) begin
                    tmds <= {1'b1, q_m[8], ~q_m[7:0]};
                    cnt <= q_m[8] ? cnt + 5'd2 + 5'd8 - ones - ones : cnt + 5'd8 - ones - ones;
                end else begin
                    tmds <= {1'b0, q_m[8], q_m[7:0]};
                    cnt <= q_m[8] ? cnt + ones + ones - 5'd8 : cnt - 5'd2 + ones + ones - 5'd8;
                end
            end
        end else begin 
            cnt <= 0;
            case(control)
                2'b00: tmds <= 10'b1101010100;
                2'b01: tmds <= 10'b0010101011;
                2'b10: tmds <= 10'b0101010100;
                2'b11: tmds <= 10'b1010101011;
            endcase
        end
    end
 
endmodule
 
`default_nettype wire