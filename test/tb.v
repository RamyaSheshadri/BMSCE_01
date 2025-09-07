`default_nettype none
`timescale 1ns / 1ps

/*
 * Testbench for 2-bit magnitude comparator (tt_um_BMSCE_project_1)
 * Proper reset and initialization added to avoid X outputs.
 */

module tb ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Inputs
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  integer A, B;

  // Instantiate the DUT
  tt_um_BMSCE_project_1 uut(
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Clock generation (required by Tiny Tapeout wrapper)
  initial clk = 0;
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs and assert reset
    rst_n = 0;
    ena   = 1;
    ui_in = 8'b0;
    uio_in = 8'b0;

    #10;          // hold reset for 10ns
    rst_n = 1;    // release reset
    #10;          // wait for outputs to stabilize

    // Test all 2-bit combinations for A and B
    for (A = 0; A < 4; A = A + 1) begin
      for (B = 0; B < 4; B = B + 1) begin
        ui_in[1:0] = A;       // A[1:0]
        ui_in[3:2] = B;       // B[1:0]
        uio_in[7:4] = 4'b0;   // unused upper bits
        #10;                   // wait for outputs to settle

        $display("A=%b, B=%b => A_gt_B=%b, A_eq_B=%b, A_lt_B=%b",
                  ui_in[1:0], ui_in[3:2], uo_out[0], uo_out[1], uo_out[2]);
      end
    end

    $finish;
  end

endmodule
