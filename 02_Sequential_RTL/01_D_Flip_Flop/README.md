# D Flip-Flop with Asynchronous Active-Low Reset

## 📌 Overview
This directory contains the RTL implementation and testbench verification of a positive-edge triggered D Flip-Flop (DFF) featuring an asynchronous active-low reset (`rst_n`). The DFF serves as the fundamental 1-bit storage element used to construct more complex sequential systems like registers, counters, and finite state machines.

## 🖧 Hardware Behavior & Logic Principles
* **Trigger Element:** Positive (rising) edge of the clock (`posedge clk`).
* **Reset Control:** Asynchronous Active-Low (`negedge rst_n`). 
  * *Why Asynchronous?* The reset signal overrides the clock entirely. If `rst_n` falls to `0`, the output `q` drops to `0` instantly, completely bypassing the clock state. This ensures a safe, predictable system initialization or emergency state clearing.



### Truth Table
| rst_n | clk | d | q | Comment |
| :---: | :---: | :---: | :---: | :--- |
| **0** | X | X | **0** | Asynchronous Reset (Instantaneous) |
| **1** | ↑ | 0 | **0** | Sampled '0' on rising clock edge |
| **1** | ↑ | 1 | **1** | Sampled '1' on rising clock edge |
| **1** | ↓/Steady | X | **q_prev** | Memory Mode (No change) |

---

## 🔍 Key Verification Takeaways
* **Edge-Triggered Isolation:** Verified that changes on the data input line `d` do not affect the output state `q` during falling clock edges or stable clock phases.
* **Immediate Reset Assertion:** Confirmed via behavioral simulation that the moment `rst_n` transitions to `0`, the output `q` snaps low instantly without waiting for a synchronous clock edge.
