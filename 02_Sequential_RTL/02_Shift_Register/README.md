# 4-Bit Shift Register (Conveyor Belt Design)

## 📌 Overview
This directory contains the RTL design and verification suite of a 4-bit Serial-In to Serial-Out (SISO) shift register. It models a hardware "conveyor belt" where data bits are sampled on the rising edge of the clock and shifted through internal flip-flops sequentially.

## 🖧 Hardware Architecture & Waveform Design
* **Logic Type:** Edge-triggered synchronous sequential logic.
* **Reset Type:** Asynchronous Active-Low (`rst_n`).
* **Data Path:** `d -> q_reg[0] -> q_reg[1] -> q_reg[2] -> q_reg[3] -> q_out`.

### Shifting Sequence (Single Pulse Test)
When a single clock-wide pulse is injected at `d`, the data shifts across the registers creating a clear diagonal staircase pattern:
Clock Cycle 0: 0000 (Reset State)
Clock Cycle 1: 1000 (q_reg[0] captures '1')
Clock Cycle 2: 0100 (q_reg[1] captures '1')
Clock Cycle 3: 0010 (q_reg[2] captures '1')
Clock Cycle 4: 0001 (q_reg[3] captures '1' -> Out to q_out)


---

## 🔍 Key Verification Takeaways
* **Resolved Simulator State Retention:** Encountered and fixed a common Vivado glitch where old compiled snapshots are held in simulator memory by forcing a clean environment relaunch.
* **Timing Alignment:** Debugged a data-to-clock edge racing issue by shifting stimulus drive times to ensure signals meet setup and hold conditions across active rising edges.
