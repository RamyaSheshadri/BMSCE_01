`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

 integer A, B;  // <-- moved outside initial block

  // Replace tt_um_example with your module name:
tt_um_BMSCE_project_1 uut(
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );
// Clock (not needed for combinational comparator, but required by wrapper)
  initial clk = 0;
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initial conditions
  clk    = 0;
  rst_n  = 0;
  ena    = 0;
  ui_in  = 8'b0;
  uio_in = 8'b0;

  // Apply reset
  #20;
  rst_n = 1;
  ena   = 1;

    for (A = 0; A < 4; A = A + 1) begin
      for (B = 0; B < 4; B = B + 1) begin
        ui_in[1:0] = A;      // A[1:0]
        ui_in[3:2] = B;      // B[1:0]
        uio_in[7:4] = 4'b0;   // unused upper bits
        #10;                 // wait for outputs to settle
        $display("A=%b, B=%b => A_gt_B=%b, A_eq_B=%b, A_lt_B=%b", 
          ui_in[1:0], ui_in[3:2], uo_out[0], uo_out[1], uo_out[2]);

      end
    end
   
  end

endmodule 
  
