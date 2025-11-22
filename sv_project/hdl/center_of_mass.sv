`default_nettype none
module center_of_mass (
        input wire clk,
        input wire rst,
        input wire [10:0] pixel_x,
        input wire [9:0]  pixel_y,
        input wire pixel_valid,
        input wire calculate,
        output logic [10:0] com_x,
        output logic [9:0] com_y,
        output logic com_valid
    );
    //your code here
    typedef enum {
        ADDING = 0,
        DIV = 1,
        BUSY = 2,
        READY = 3
    } com_state;
    
    com_state state;

    logic [31:0] sum_x;
    logic [31:0] sum_y;
    logic [31:0] sum_v;

    logic [31:0] div_x_r;
    logic [31:0] div_x_q;
    logic div_x_v;
    logic x_err;
    logic x_busy;

    divider my_div_x
    (   .clk(clk),
        .rst(rst),
        .dividend(sum_x),
        .divisor(sum_v),
        .data_in_valid(calculate),
        .quotient(div_x_q),
        .remainder(div_x_r),
        .data_out_valid(div_x_v),
        .error(x_err),
        .busy(x_busy)
    );

    logic [31:0] div_y_q;
    logic [31:0] div_y_r;
    logic div_y_v;
    logic y_err;
    logic y_busy;

    divider my_div_y
    (   .clk(clk),
        .rst(rst),
        .dividend(sum_y),
        .divisor(sum_v),
        .data_in_valid(calculate),
        .quotient(div_y_q),
        .remainder(div_y_r),
        .data_out_valid(div_y_v),
        .error(y_err),
        .busy(y_busy)
    );

    logic x_ready, y_ready;

    always_ff @(posedge clk) begin
        if (rst) begin
            com_valid <= 0;
            sum_v <= 0;
            sum_x <= 0;
            sum_y <= 0;
            state <= ADDING;
            x_ready <= 0;
            y_ready <= 0;
        end else begin
            case(state)
                ADDING: begin
                    com_valid <= 0;
                    if (pixel_valid) begin
                        sum_v <= sum_v + 1;
                        sum_x <= sum_x + pixel_x;
                        sum_y <= sum_y + pixel_y;
                    end
                    if (calculate) begin
                        state <= DIV;
                    end
                end
                DIV: begin
                    if (x_busy && y_busy) state <= BUSY;
                end
                BUSY: begin
                    if (x_ready && y_ready) begin
                        state <= READY;
                    end else begin 
                        if (div_x_v) begin 
                            com_x <= div_x_q;
                            x_ready <= 1;
                            if (y_ready) state <= READY;
                        end
                        if (div_y_v) begin
                            com_y <= div_y_q;
                            y_ready <= 1;
                            if (x_ready) state <= READY;
                        end
                    end
                end
                READY: begin
                    com_valid <= 1;
                    sum_v <= 0;
                    sum_x <= 0;
                    sum_y <= 0;
                    state <= ADDING;
                    x_ready <= 0;
                    y_ready <= 0;
                end

            endcase
        end
    end
    
endmodule

`default_nettype wire



