`timescale 1ns / 1ps
`default_nettype none
 
module command_fifo #(parameter DEPTH=16, parameter WIDTH=16)(
        input wire clk,
        input wire rst,
        input wire write,
        input wire [WIDTH-1:0] command_in,
        output logic full,
 
        output logic [WIDTH-1:0] command_out,
        input wire read,
        output logic empty
    );
    
    localparam DEPTH_BITS = $clog2(DEPTH);
 
    logic [DEPTH_BITS - 1:0]   write_pointer;
    logic [DEPTH_BITS - 1:0]   read_pointer;
    logic [WIDTH - 1:0] fifo [DEPTH - 1:0]; //when read asynchronously/combinationally, will result in distributed RAM usage
 
    //your design here.
    assign command_out = fifo[read_pointer];
    assign empty = read_pointer == write_pointer;
    assign full = write_pointer + 1'd1  == read_pointer;
    always_ff @(posedge clk) begin
        if (rst) begin
            write_pointer <= 0;
            read_pointer <= 0;
            // full <= 0;
            // empty <= 0;
        end else begin
            if (read) begin
                read_pointer <= read_pointer == write_pointer ? read_pointer : read_pointer + 1'd1;
                // if (read_pointer != write_pointer) full <= 1'd0;
            end
            if (write) begin
                write_pointer <= write_pointer + 1'd1 == read_pointer ? write_pointer : write_pointer + 1'd1;
                if (!full) begin
                    fifo[write_pointer] <= command_in;
                end
                // if (write_pointer + 1'd1  == read_pointer) full <= 1'd1;
            end
            // empty <= read_pointer + 2'd1 == write_pointer || (read_pointer + 2'd1 > write_pointer);
        end
    end

 
endmodule
`default_nettype wire