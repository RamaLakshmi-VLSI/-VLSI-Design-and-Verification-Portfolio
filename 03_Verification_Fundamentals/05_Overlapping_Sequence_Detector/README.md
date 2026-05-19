# Synchronous Overlapping 1101 Sequence Detector

## 📌 Overview
This project implements a highly optimized synchronous Finite State Machine (FSM) that detects the serial sequence `1101` with active stream overlap capabilities. In high-throughput hardware architectures, parsing protocols must maintain pipeline efficiency by re-evaluating look-ahead bits dynamically, preventing data loss across continuous bitstream transmissions.

## 🖧 Architectural Upgrade: Non-Overlapping vs. Overlapping
The key differentiator of this architecture is its ability to prevent state-flushing overhead upon sequence completion.

* **Non-Overlapping FSM:** Destructively clears its history registers upon pattern matching, resetting unconditionally to the base state and introducing latency overhead during continuous streams.
* **Overlapping FSM (This Design):** Treats the terminating bit of a matching sequence as a functional prefix for the subsequent evaluation window. When a sequence terminates successfully on a `1`, the FSM tracks if the next state contains an existing `1-1` historical context, executing a single-cycle context shift.

### One-Hot State Transition Matrix
The control layer maps to a 5-bit One-Hot state vector to ensure minimum combinational logic propagation path delay:
* `IDLE` (5'b00001) -> Moves to `STATE_1` on `1`, loops on `0`.
* `STATE_1` (5'b00010) -> Moves to `STATE_11` on `1`, resets to `IDLE` on `0`.
* `STATE_11` (5'b00100) -> Loops on `1` (maintaining sequence context), moves to `STATE_110` on `0`.
* `STATE_110` (5'b01000) -> Moves to target `STATE_1101` on `1`, resets to `IDLE` on `0`.
* `STATE_1101` (5'b10000) -> **Overlapping Context Branch:** If `din` is verified high (`1`), the FSM routes back to `STATE_11` instantly, preserving the accumulated data context. If `din` drops low (`0`), it returns to `IDLE`.

---

## 🧪 Simulation Profile & Analysis
Verification was executed using a specialized continuous input stimulus pattern (`1101101`). Behavioral waveform analysis confirms that the output flag asserts high twice during the evaluation timeline. The design successfully captures the mid-stream data overlap on the active clock boundary, maintaining perfect stability across sub-nanosecond/picosecond simulator execution phases.

---

## 🔍 Engineering Takeaways
* **Pipeline Buffer Reuse Optimization:** Reduced state-traversal overhead by implementing memory-reuse mechanics, maintaining continuous stream evaluation metrics.
* **Critical-Path Minimization:** Utilized explicit state parameters to reduce combinational feedback loops, creating a design optimized for high-frequency silicon synthesis.
* **Synchronous Boundary Alignment:** Verified total stability of Moore output signals against data transition windows, guaranteeing zero-glitch propagation to downstream logic elements.
