# 4-Bit Shift Register (Conveyor Belt Design)

## 📌 Overview
This project implements a 4-bit Serial-In to Serial-Out (SISO) shift register using structural/behavioral Verilog. It models a hardware "conveyor belt" where data bits are sampled on the rising edge of the clock and shifted through internal flip-flops sequentially.

## 🖧 Hardware Architecture & Waveform Design
* **Logic Type:** Edge-triggered synchronous sequential logic.
* **Reset Type:** Asynchronous Active-Low (`rst_n`).
* **Data Path:** `d -> q_reg[0] -> q_reg[1] -> q_reg[2] -> q_reg[3] -> q_out`.

### Shifting Sequence (Single Pulse Test)
When a single clock-wide pulse is injected at `d`, the data shifts across the registers creating a textbook diagonal staircase pattern:
Clock Cycle 0: 0000 (Reset State)
Clock Cycle 1: 1000 (q_reg[0] captures '1')
Clock Cycle 2: 0100 (q_reg[1] captures '1')
Clock Cycle 3: 0010 (q_reg[2] captures '1')
Clock Cycle 4: 0001 (q_reg[3] captures '1' -> Out to q_out)
---

