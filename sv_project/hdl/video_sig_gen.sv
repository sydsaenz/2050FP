module video_sig_gen
#(
  parameter ACTIVE_H_PIXELS = 1280,
  parameter H_FRONT_PORCH = 110,
  parameter H_SYNC_WIDTH = 40,
  parameter H_BACK_PORCH = 220,
  parameter ACTIVE_LINES = 720,
  parameter V_FRONT_PORCH = 5,
  parameter V_SYNC_WIDTH = 5,
  parameter V_BACK_PORCH = 20,
  parameter FPS = 60)
(
  input wire pixel_clk,
  input wire rst,
  output logic [$clog2(TOTAL_PIXELS)-1:0] h_count,
  output logic [$clog2(TOTAL_LINES)-1:0] v_count,
  output logic v_sync, //vertical sync out
  output logic h_sync, //horizontal sync out
  output logic active_draw,
  output logic new_frame, //single cycle enable signal
  output logic [5:0] frame_count); //frame

  localparam H_PIXELS = ACTIVE_H_PIXELS + H_FRONT_PORCH + H_SYNC_WIDTH + H_BACK_PORCH;
  localparam V_PIXELS = ACTIVE_LINES + V_FRONT_PORCH + V_SYNC_WIDTH + V_BACK_PORCH;

  localparam TOTAL_PIXELS = H_PIXELS * V_PIXELS; //figure this out
  localparam TOTAL_LINES = V_PIXELS; //figure this out

  //your code here
  always_ff @(posedge pixel_clk) begin
    if (rst) begin
        active_draw <= 0;
        v_sync <= 0;
        h_sync <= 0;
        h_count <= 0;
        v_count <= 0;
        new_frame <= 0;
        frame_count <= 0;
    end else begin
        if (h_count == H_PIXELS - 1) begin
            h_count <= 0;
            active_draw <= v_count < ACTIVE_LINES - 1 || v_count == TOTAL_LINES - 1 ? 1 : 0;
            v_count <= v_count == TOTAL_LINES - 1 ? 0 : v_count + 1;
            v_sync <= v_count >= ACTIVE_LINES + V_FRONT_PORCH - 1 && v_count < V_PIXELS - V_BACK_PORCH - 1 ? 1 : 0;
        end else begin
            h_count <= h_count + 1;
            active_draw <= h_count < ACTIVE_H_PIXELS - 1 && v_count < ACTIVE_LINES ? 1 : 0;
        end
        if (h_count == ACTIVE_H_PIXELS - 1 && v_count == ACTIVE_LINES - 1) begin
            frame_count <= frame_count == FPS - 1 ? 0 : frame_count + 1;
            new_frame <= 1;
        end else begin
            new_frame <= 0;
        end 
        h_sync <= h_count >= ACTIVE_H_PIXELS + H_FRONT_PORCH -1 && h_count < H_PIXELS - H_BACK_PORCH - 1 ? 1 : 0;
    end
  end

endmodule