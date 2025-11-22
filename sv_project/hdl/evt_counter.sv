`default_nettype none
module evt_counter #( parameter MAX_COUNT = 40000)
    (   input wire          clk,
        input wire          rst,
        input wire          evt,
        output logic[31:0]  count
    );
    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 32'b0;
        end else if (count == MAX_COUNT) begin
            count <= 0;
        end else begin
            /* your code here */
            count <= evt ? count + 1 : count;
        end
    end
endmodule
`default_nettype wire