`timescale 1ns / 1ps
module fifo_mem #(
    parameter DEPTH      = 8,
    parameter DATA_WIDTH = 8,
    parameter PTR_WIDTH  = 3
)(
    input  wire                  wclk,
    input  wire                  w_en,
    input  wire                  rclk,
    input  wire                  r_en,
    input  wire [PTR_WIDTH:0]    b_wptr,
    input  wire [PTR_WIDTH:0]    b_rptr,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire                  full,
    input  wire                  empty,
    output reg  [DATA_WIDTH-1:0] data_out
);


  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];


  always @(posedge wclk) begin
    if (w_en & ~full)
      mem[b_wptr[PTR_WIDTH-1:0]] <= data_in;
  end

 
  always @(posedge rclk) begin
    if (r_en & ~empty)
      data_out <= mem[b_rptr[PTR_WIDTH-1:0]];
  end

endmodule
