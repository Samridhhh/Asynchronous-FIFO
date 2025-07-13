`timescale 1ns / 1ps
module async_fifo_tb;

  parameter DATA_WIDTH = 8;
  parameter DEPTH = 8;
  localparam PTR_WIDTH = $clog2(DEPTH);

  reg                   wclk = 0;
  reg                   rclk = 0;
  reg                   wrst_n = 0;
  reg                   rrst_n = 0;
  reg                   w_en;
  reg                   r_en;
  reg  [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire                  full;
  wire                  empty;

  asynchronous_fifo #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) uut (
    .wclk(wclk), .wrst_n(wrst_n), .rclk(rclk), .rrst_n(rrst_n),
    .w_en(w_en), .r_en(r_en), .data_in(data_in),
    .data_out(data_out), .full(full), .empty(empty)
  );

  // Clock generators
  always #5  wclk = ~wclk;
  always #15 rclk = ~rclk;

  integer i;
  reg [DATA_WIDTH-1:0] queue [0:127];
  integer head = 0, tail = 0;

  initial begin
    // Reset
    wrst_n = 0; rrst_n = 0;
    w_en = 0; r_en = 0; data_in = 0;
    #20;
    wrst_n = 1; rrst_n = 1;

    // Write phase
    for (i = 0; i < DEPTH+2; i = i + 1) begin
      @(posedge wclk);
      w_en     = ~full;
      data_in  = i;
      if (w_en) begin
        queue[tail] = data_in;
        tail = (tail + 1) % DEPTH;
      end
    end

    #40;

    // Read phase
    for (i = 0; i < DEPTH+2; i = i + 1) begin
      @(posedge rclk);
      r_en = ~empty;
      if (r_en) begin
        if (data_out !== queue[head]) $display("ERROR at time %0t: got %0h, expected %0h", $time, data_out, queue[head]);
        head = (head + 1) % DEPTH;
      end
    end

    #20;
    $finish;
  end

endmodule

