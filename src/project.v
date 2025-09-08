/*
 * Copyright (c) 2024 BMSCE
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_BMSCE_project_1 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

   // Split inputs
  wire A1 = ui_in[1];
  wire A0 = ui_in[0];
  wire B1 = ui_in[3];
  wire B0 = ui_in[2];

  // Explicit Boolean equations
  assign uo_out[1] = (~(A1 ^ B1)) & (~(A0 ^ B0));                        // A == B
  assign uo_out[0] = (A1 & ~B1) | ((~(A1 ^ B1)) & (A0 & ~B0));           // A > B
  assign uo_out[2] = (~A1 & B1) | ((~(A1 ^ B1)) & (~A0 & B0));           // A < B

  // Unused outputs tied to 0
  assign uo_out[7:3] = 5'b00000;

  // Not using bidirectional IOs
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Avoid warnings for unused signals
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
