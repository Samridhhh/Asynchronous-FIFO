`timescale 1ns / 1ps
module asynchronous_fifo #(
    parameter DEPTH      = 8,
    parameter DATA_WIDTH = 8
)(
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  w_en,
    input  wire                  r_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  full,
    output wire                  empty
);

  localparam PTR_WIDTH = $clog2(DEPTH);

 
  wire [PTR_WIDTH:0] g_wptr, b_wptr;
  wire [PTR_WIDTH:0] g_rptr, b_rptr;
  wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;

 
  synchronizer #(.WIDTH(PTR_WIDTH)) sync_wptr (
    .clk(rclk), .rst_n(rrst_n), .d_in(g_wptr), .d_out(g_wptr_sync)
  );

  synchronizer #(.WIDTH(PTR_WIDTH)) sync_rptr (
    .clk(wclk), .rst_n(wrst_n), .d_in(g_rptr), .d_out(g_rptr_sync)
  );

 
  wptr_handler #(.PTR_WIDTH(PTR_WIDTH)) wptr_h (
    .wclk(wclk), .rst_n(wrst_n), .w_en(w_en), .g_rptr_sync(g_rptr_sync),
    .b_wptr(b_wptr), .g_wptr(g_wptr), .full(full)
  );

  rptr_handler #(.PTR_WIDTH(PTR_WIDTH)) rptr_h (
    .rclk(rclk), .rst_n(rrst_n), .r_en(r_en), .g_wptr_sync(g_wptr_sync),
    .b_rptr(b_rptr), .g_rptr(g_rptr), .empty(empty)
  );
 
  
  fifo_mem #(
    .DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH), .PTR_WIDTH(PTR_WIDTH)
  ) mem_inst (
    .wclk(wclk), .w_en(w_en), .rclk(rclk), .r_en(r_en),
    .b_wptr(b_wptr), .b_rptr(b_rptr),
    .data_in(data_in), .full(full), .empty(empty), .data_out(data_out)
  );

endmodule
