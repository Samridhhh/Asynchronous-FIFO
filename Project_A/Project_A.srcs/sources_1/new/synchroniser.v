`timescale 1ns / 1ps
module synchronizer #(
    parameter WIDTH = 3
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH:0]   d_in,
    output reg  [WIDTH:0]   d_out
);

  reg [WIDTH:0] q1;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q1    <= {WIDTH+1{1'b0}};
      d_out <= {WIDTH+1{1'b0}};
    end else begin
      q1    <= d_in;
      d_out <= q1;
    end
  end

endmodule