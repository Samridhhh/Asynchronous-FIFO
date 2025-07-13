`timescale 1ns / 1ps
module wptr_handler #(
    parameter PTR_WIDTH = 3
)(
    input  wire                 wclk,
    input  wire                 rst_n,  //active low
    input  wire                 w_en,  // when it is high and full is low, wptr inc
    input  wire [PTR_WIDTH:0]   g_rptr_sync,
    output reg  [PTR_WIDTH:0]   b_wptr,
    output reg  [PTR_WIDTH:0]   g_wptr,
    output reg                  full
);

  wire [PTR_WIDTH:0] b_wptr_next;
  wire [PTR_WIDTH:0] g_wptr_next;

  assign b_wptr_next = b_wptr + (w_en & ~full);
  assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;

  // Update pointers
  always @(posedge wclk or negedge rst_n) begin
    if (!rst_n) begin
      b_wptr <= {PTR_WIDTH+1{1'b0}};
      g_wptr <= {PTR_WIDTH+1{1'b0}};
    end else begin
      b_wptr <= b_wptr_next;
      g_wptr <= g_wptr_next;
    end
  end

  // Full flag logic
  always @(posedge wclk or negedge rst_n) begin
    if (!rst_n)
      full <= 1'b0;
    else
      full <= (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});
  end

endmodule
