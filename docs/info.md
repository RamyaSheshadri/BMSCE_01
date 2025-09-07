<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# How it works

# 2-bit Magnitude Comparator

**Author:** BMSCE

## Project Description
- This project implements a **2-bit magnitude comparator** in Verilog for the Tiny Tapeout platform.  
- It compares two unsigned 2-bit numbers (A and B) and produces three outputs indicating whether:
    - **A > B**, **A = B**, or **A < B**.  
- The design uses simple Boolean logic with assign statements, making it lightweight and suitable for synthesis and tapeout.

## Logic Implementation

Let `A = A1 A0` and `B = B1 B0`:

## Logic Implementation

### Equality (A = B):
```verilog
assign uo_out[1] = (~(A1 ^ B1)) & (~(A0 ^ B0));
```

Both bits must match for the equality output to be high.

### Greater Than (A > B):
```verilog
 assign uo_out[0] = (A1 & ~B1) | ((~(A1 ^ B1)) & (A0 & ~B0));
```
If the MSB of A is greater than B, or if MSBs are equal and LSB of A > LSB of B, output is high.


### Less Than (A < B):
```verilog
assign uo_out[2] = (~A1 & B1) | ((~(A1 ^ B1)) & (~A0 & B0));
```

| Pin          | Function           |
| ------------ | ------------------ |
| `ui_in[1:0]` | Input A (2-bit)    |
| `ui_in[3:2]` | Input B (2-bit)    |
| `uo_out[0]`  | A > B              |
| `uo_out[1]`  | A = B              |
| `uo_out[2]`  | A < B              |
| Other pins   | Unused / tied to 0 |

Bidirectional pins (uio_in, uio_out, uio_oe) are not used in this project.


# How to test

- Simulation:
 - The design was verified with a simple Verilog testbench covering all input combinations.

### Block diagram:
<img width="621" height="639" alt="Screenshot 2025-09-06 154503" src="https://github.com/user-attachments/assets/a8a5434f-202c-4c3a-9724-71f6f60b06f5" />

### Detailed view:
<img width="1515" height="761" alt="Screenshot 2025-09-06 154427" src="https://github.com/user-attachments/assets/e3ee0233-18fd-4c26-83fc-91158ff46037" />

### Output waveform:
<img width="1506" height="763" alt="Screenshot 2025-09-06 154232" src="https://github.com/user-attachments/assets/4bcef419-39ea-42ae-931b-ad438502eeea" />

### 
All outputs correctly reflect the comparator behavior.

## External hardware

- For this 2-bit comparator Tiny Tapeout project, no external hardware is needed.
- The design is fully combinational digital logic: just gates (AND, OR, NOT, XNOR).
- Tiny Tapeout provides a standard chip template, power rails, and I/O pads.
- All inputs (ui_in) and outputs (uo_out) connect directly to the chip pins — no microcontrollers, FPGAs, or other boards are required.
- Verification is done via a Verilog testbench or simulation in local environment; hence we don’t need physical hardware until the chip is fabricated.
