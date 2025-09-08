
# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_comparator(dut):
    dut._log.info("Starting 2-bit comparator test")

    # Clock setup (needed for Tiny Tapeout wrapper)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)  # wait for reset release

    # Test all 2-bit combinations
    for A in range(4):  # 0..3
        for B in range(4):
            dut.ui_in.value = (B << 2) | A  # ui_in[1:0]=A, ui_in[3:2]=B
            await ClockCycles(dut.clk, 1)
            await cocotb.triggers.Timer(1, units="ns")

            # Expected outputs
            expected_gt = int(A > B)
            expected_eq = int(A == B)
            expected_lt = int(A < B)

            # Read the DUT outputs as integer
            uo_val = int(dut.uo_out.value)

            # Bit positions: [0]=GT, [1]=EQ, [2]=LT
            got_gt = (uo_val >> 0) & 1
            got_eq = (uo_val >> 1) & 1
            got_lt = (uo_val >> 2) & 1

            # Assert the outputs
            assert got_gt == expected_gt, f"A={A}, B={B}, A>B mismatch"
            assert got_eq == expected_eq, f"A={A}, B={B}, A=B mismatch"
            assert got_lt == expected_lt, f"A={A}, B={B}, A<B mismatch"
