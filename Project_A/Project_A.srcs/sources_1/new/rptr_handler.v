`timescale 1ns / 1ps
module rptr_handler #(
    parameter PTR_WIDTH = 3
)(
    input  wire                 rclk,
    input  wire                 rst_n,
    input  wire                 r_en, // rclk is ticking and enable =0
    input  wire [PTR_WIDTH:0]   g_wptr_sync,
    output reg  [PTR_WIDTH:0]   b_rptr,
    output reg  [PTR_WIDTH:0]   g_rptr,
    output reg                  empty
);

  wire [PTR_WIDTH:0] b_rptr_next;
  wire [PTR_WIDTH:0] g_rptr_next;

  assign b_rptr_next = b_rptr + (r_en & ~empty);
  assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;

  // Update pointers
  always @(posedge rclk or negedge rst_n) begin
    if (!rst_n) begin
      b_rptr <= {PTR_WIDTH+1{1'b0}};
      g_rptr <= {PTR_WIDTH+1{1'b0}};
    end else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
    end
  end

  // Empty flag logic
  always @(posedge rclk or negedge rst_n) begin
    if (!rst_n)
      empty <= 1'b1;
    else
      empty <= (g_wptr_sync == g_rptr_next);
  end

endmodule
