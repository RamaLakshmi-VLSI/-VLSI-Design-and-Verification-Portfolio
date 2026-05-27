# Parameterized Synchronous FIFO Buffer Core

## 📌 Overview
This repository contains a fully parameterized, synthesizable Synchronous First-In, First-Out (FIFO) memory buffer core designed for high-throughput data queueing between independent synchronous hardware sub-systems. The core features a dual-port memory matrix, synchronized read/write tracking pointers, and automated boundary condition status flags to prevent data overrun (overflow) and underrun (underflow) scenarios.

## 🧠 Hardware Architecture & Flag Generation Logic
The design utilizes a synchronized dual-pointer circular queue topology. To handle the classic FIFO ambiguity problem—where the read and write pointers point to identical memory indices during both an entirely empty state and an entirely full state—an additional Most Significant Bit (MSB) is integrated into both tracking registers to serve as a **Lap Counter**.

### Pointer Mathematical Model
* **Memory Depth ($N$):** Configured via parameter `DEPTH`.
* **Physical Address Bits:** $M = \log_2(N)$, represented by `ADDR_WIDTH`.
* **Total Pointer Register Width:** $M + 1$ bits (Index + Lap Flag).

### Combinational Flag Formulations
```verilog
assign empty = (w_ptr[ADDR_WIDTH] == r_ptr[ADDR_WIDTH]) && 
               (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);

assign full  = (w_ptr[ADDR_WIDTH] != r_ptr[ADDR_WIDTH]) && 
               (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);
```
* **Empty Condition:** Active when both the Write and Read pointers reside within the identical lap loop and point to the matching address index.
* **Full Condition:** Active when the Write pointer has advanced exactly one full lap ahead of the Read pointer while intersecting the identical underlying physical memory address index.

---

## 🧪 Simulation Profile & Verification Trace
Functional verification was executed using a dense behavioral simulation loop running under a 50MHz timing constraint.

### Functional Analysis Milestones
* **Asynchronous Initial Flush:** Asserting `rst_n` drops all internal pointer addresses back to zero, forcing the immediate assertion of `empty` while keeping `full` low.
* **Saturation & Overwrite Guard:** Pushing a sequential data stream continuously until the storage array is saturated. On the 8th clock edge, the lap counter bit toggles, asserting the `full` flag. Subsequent write requests are combinationally blocked inside the RTL to prevent data corruption.
* **Drain & Underrun Guard:** Popping data elements sequentially from the full boundary down to zero. Upon fetching the final valid data word, the `empty` flag asserts instantly, masking out corrupt uninitialized read values.

---

## 🔍 Key Engineering Takeaways
* **Circular Queue Boundary Control:** Implemented the lap-counter MSB architecture to elegantly resolve structural state collisions without requiring complex adder trees.
* **Silicon Overflow Protection:** Designed robust internal control interlocks (`!full` and `!empty`) to preserve data state integrity under hostile traffic conditions.
* **Advanced Verification Mastery:** Developed multi-phase behavioral simulation sequences to aggressively sweep hardware designs through hard boundary states.
