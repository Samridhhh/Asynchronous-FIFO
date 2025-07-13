`timescale 1ns / 1ps
module g2b_converter #(
    parameter WIDTH = 3
)(
    input  wire [WIDTH:0] gray,
    output reg  [WIDTH:0] binary
);
  integer i;
  always @* begin
    binary[WIDTH] = gray[WIDTH];
    for (i = WIDTH-1; i >= 0; i = i - 1)
      binary[i] = binary[i+1] ^ gray[i];
  end
endmodule