`default_nettype none

module tm_choice (
  input wire [7:0] d,
  output logic [8:0] q_m
  );

  logic [3:0] ones;
  always_comb begin
    ones = 0;
    for (int i = 0; i<8; i = i + 1) begin
      ones = d[i] == 1 ? ones + 1 : ones;
    end
    if (ones>4 || (ones==4 && d[0]==0)) begin
      q_m[0] = d[0];
      for (int i = 1; i<8; i = i + 1) begin
        q_m[i] = ~(q_m[i-1]^d[i]);
      end
      q_m[8] = 0;
    end else begin
      q_m[0] = d[0];
      for (int i = 1; i<8; i = i + 1) begin
        q_m[i] = (q_m[i-1]^d[i]);
      end
      q_m[8] = 1;
    end
  end


endmodule //end tm_choice

`default_nettype wire
