# Synchronous Non-Overlapping 1101 Sequence Detector

## 📌 Overview
This project implements a fully synchronous Finite State Machine (FSM) designed to detect a specific 4-bit serial data sequence (`1101`) from an incoming 1-bit input stream (`din`). Sequence detection is a foundational digital design mechanic used heavily across industry-standard serial communication protocols (such as SPI, I2C, and Ethernet) to locate packet frame headers or start-of-frame markers.

## 🖧 State Machine Architecture
The module is designed using a multi-state **Moore FSM Architecture**, meaning the output pulse remains perfectly decoupled from input wire transients and depends exclusively on the current active state register. 

### State Allocations (One-Hot Style)
To optimize setup and hold timing margins at higher frequencies, the control path is explicitly mapped to a 5-bit One-Hot state vector:
* **`IDLE` (5'b00001):** Standby state. Circuit holds here while searching for the initial pattern bit.
* **`STATE_1` (5'b00010):** Registered a valid first bit (`1`).
* **`STATE_11` (5'b00100):** Registered a valid second bit (`1-1`).
* **`STATE_110` (5'b01000):** Registered a valid third bit (`1-1-0`).
* **`STATE_1101` (5'b10000):** Target sequence completed (`1-1-0-1`). Asserting output pulse.

### Fallback & Recovery Dynamics
The state transitions are structurally hardwired to dynamically handle broken or partial sequences without locking up or losing timing alignment.
* If a bit sequence breaks early (e.g., receiving a `0` when standing in `STATE_1` or `STATE_110`), the machine drops all progress and returns to `IDLE` safely.
* If the machine receives a `1` while sitting in `STATE_11`, it loops back to itself to retain the `1-1` historical state string, treating the new bit as the continuation of a valid stream.

Because this specific implementation is **non-overlapping**, once the machine transitions into the target `STATE_1101` and fires its flag, it flushes its internal tracking memory completely, returning to `IDLE` on the following clock cycle to begin a completely fresh search window.

---

## 🧪 Simulation & Behavioral Verification
The behavioral verification plan focuses on sampling accuracy at the picosecond/nanosecond boundary. 

Through intensive simulation testing, the design demonstrates clear resilience against timing racing conditions. The internal state register successfully updates immediately following the active clock edge by evaluating the input stream setup window fractions of a picosecond before the transition event, ensuring that `dout` asserts high for exactly one full clock cycle when a true pattern match occurs.

---

## 🔍 Key Engineering Takeaways
* **Deterministic Timing & Sampling Mechanics:** Successfully tracked sub-nanosecond/picosecond simulator evaluation dynamics to observe how input data setups are registered at active clock transitions without initiating race conditions.
* **Zero-Leakage State Recovery:** Architected a defensive combinational state-recovery matrix that naturally prevents deadlocks, false-positive triggers, and accidental memory latches during stream corruption windows.
* **One-Hot Optimization for VLSI Pipelines:** Leveraged One-Hot encoding parameters to minimize decoding logic delay paths, building a structure highly optimized for high-speed hardware synthesis.
