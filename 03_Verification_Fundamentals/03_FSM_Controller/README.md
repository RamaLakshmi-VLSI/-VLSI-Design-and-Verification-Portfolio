# Finite State Machine (FSM) System Controller

## 📌 Overview
This project implements a synchronous, synchronous-reset finite state machine (FSM) designed to function as a core hardware system controller. Unlike stateless combinational circuits, this module incorporates sequential memory elements to track historical operations, enabling deterministic data path routing across distinct operational states.

## 🖧 Hardware Architecture & State Topology
The controller is designed using a structural **Moore Machine** topology, ensuring that control outputs are clean and dependent solely on the active state register rather than changing directly with asynchronous input glitches.

### State Assignments (One-Hot Encoding)
To maximize timing closure efficiency and reduce combinational logic depth at higher frequencies, the design implements a 3-bit One-Hot state vector:
* **`IDLE` (3'b001):** System standby mode waiting for processing commands.
* **`READ` (3'b010):** Asserts the master data read channel mask.
* **`WRITE` (3'b100):** Asserts the master data write channel mask.

### State Transition Dynamics
The control flow supports fully connected, direct-jump transition paths between execution cycles, bypassing the mandatory standby step to minimize execution latency.

* **IDLE State Paths:**
  * Moves to `READ` when the command vector equals `2'b01`.
  * Moves to `WRITE` when the command vector equals `2'b10`.
  * Preserves the `IDLE` state under all other input patterns.
* **READ State Paths:**
  * Drops back to `IDLE` when the command vector clears to `2'b00`.
  * Jumps directly to `WRITE` when the command vector shifts to `2'b10`.
  * Latches within `READ` to hold continuous burst cycles otherwise.
* **WRITE State Paths:**
  * Drops back to `IDLE` when the command vector clears to `2'b00`.
  * Jumps directly to `READ` when the command vector shifts to `2'b01`.
  * Latches within `WRITE` to hold continuous burst cycles otherwise.

---

## 🧪 Verification Strategy
The verification environment targets control path boundary coverage. The testbench framework releases an asynchronous active-low reset signal, cycles through isolated Read and Write command windows, and pushes consecutive back-to-back state changes to validate timing margin stability.

---

## 🔍 Key Engineering Takeaways
* **Direct-Jump Interlocking Optimization:** Validated a fully connected state transition matrix that optimizes processing throughput by allowing single-cycle context switches directly between execution modes.
* **Glitch Isolation via Moore Modeling:** Enforced strict Moore output mappings where control flags remain completely isolated from input bus switching noise during mid-cycle transients, eliminating downstream clock-domain race conditions.
* **Defensive Latch Prevention:** Implemented total-coverage default state assignments across combinational logic evaluation blocks, guaranteeing that synthesis tools implement pure logic networks without accidental storage artifacts.
