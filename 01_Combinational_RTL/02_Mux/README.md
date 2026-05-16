# 2-to-1 Multiplexer (Mux) Design

## 📌 Overview
This project contains the implementation of a 2-to-1 Multiplexer (Mux). A multiplexer serves as a digital data selector, routing one of multiple input signals to a single output line based on the control state of a selection line. It is a foundational block for steering data within hardware pipelines and bus architectures.

## 🖧 Hardware Architecture & Boolean Expression
The behavior of this data selector is governed by the conditional routing equation:
$$Y = (A \cdot \overline{Sel}) + (B \cdot Sel)$$

### Truth Table
| Input A | Input B | Select (Sel) | Output Y | Operational Mode |
| :-----: | :-----: | :----------: | :-----: | :--------------- |
|    0    |    X    |      0       |    0    | Routing Input A  |
|    1    |    X    |      0       |    1    | Routing Input A  |
|    X    |    0    |      1       |    0    | Routing Input B  |
|    X    |    1    |      1       |    1    | Routing Input B  |

---

## 🧪 Verification Strategy
The verification plan sweeps the select line across changing data boundaries to confirm high-fidelity signal tracking. Test cases evaluate both static routing conditions and dynamic switching behavior under opposing input states.

## 🔍 Key Engineering Takeaways
* **Latch Avoidance:** Structured using an exhaustive combinational sensitivity list to ensure complete evaluation blocks, preventing the tool from inferring unintended transparent latches.
* **Crosstalk & Isolation Verification:** Confirmed via waveform analysis that changes on an unselected input channel create zero transient ripple or energy leakage at the output port.
