# Synchronous Glitch-Free Clock Multiplexer (Clock Mux)

## 📌 Overview
Dynamic Frequency Scaling (DFS) architectures require real-world Systems-on-Chip (SoCs) to hot-swap active clock sources dynamically (e.g., switching from a high-speed execution clock to a low-power standby clock). This project implements a hardware-synchronized, glitch-free clock multiplexer that prevents the propagation of illegal, narrow clock fragments during dynamic runtime select transitions.

## 🧠 The Hazard: Combinational Clock Switching
Implementing clock switching using native combinational logic gates (`assign out_clk = sel ? clk_1 : clk_0;`) introduces severe structural hazards. If the selection control wire alters state while one clock source is sitting high and the secondary source is sitting low, the output slice drops dead mid-cycle. 

This creates an illegal, hyper-narrow **clock glitch** that violates the minimum pulse-width thresholds of downstream standard cell registers. As a consequence, some pipeline stages latch data prematurely while adjacent stages fail to trigger, completely corrupting internal state machines and causing catastrophic chip failure.

---

## 🖧 Circuit Architecture & Mutual Exclusion
To mitigate glitch hazards, this architecture implements a dual-domain negative-edge handshaking matrix. The fundamental rule is that **a new clock source is never allowed to drive the output node until the currently active clock source has safely gone low.**



### Handshaking Synchronization Matrix
The architecture divides selection tracking across two isolated negative-edge triggered paths:
* **Clock Domain 0 (`out_0_en`):** Evaluates on `negedge clk_0`. It drops its enable flag when `sel` goes high, but can only re-assert when `sel` is low AND `out_1_en` has completely cleared.
* **Clock Domain 1 (`out_1_en`):** Evaluates on `negedge clk_1`. It asserts high only when `sel` goes high AND `out_0_en` has verified a complete de-assertion lockout state.

By executing register updates on the **falling edge** of each clock source, any state transitions occur while the respective clock lines are already sitting in their low phases. This guarantees a safe, stable padding window before the alternative clock assumes control of the output routing path.

---

## 🧪 Simulation Profile & Analysis
Verification was performed by multiplexing between a high-frequency source (`clk_0`, 10ns period) and a low-frequency source (`clk_1`, 20ns period).



### Behavioral Insights
* **Steady-State Phase 1:** While `sel` is driven low (`0`), the output port `out_clk` mirrors the rapid 10ns cycle toggles of `clk_0` perfectly.
* **Dynamic Transition Phase:** When `sel` toggles high (`1`), the FSM prevents instantaneous output shifting. The circuit safely holds `out_clk` low while waiting for `clk_0` to complete its cycle.
* **Steady-State Phase 2:** Once the cross-domain handshake registers confirm total isolation, the network safely activates the secondary channel, and `out_clk` resumes toggling cleanly at the wider 20ns cycle rate without any intermediate voltage spikes.

---

## 🔍 Key Engineering Takeaways
* **Glitch-Free Clock Tree Isolation:** Mastered the use of cross-coupled feedback networks to safely transition asynchronous clock sources without risking state machine de-synchronization.
* **Negative-Edge Phase Optimization:** Leveraged falling-edge register tracking to safely isolate selection transitions inside the low phase of the power grid window.
* **Dynamic Clock Domain Handshaking:** Eliminated timing hazards across asynchronous clock trees, building logic fully compliant with structural Static Timing Analysis (STA) tools.
