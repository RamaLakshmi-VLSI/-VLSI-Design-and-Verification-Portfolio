# 1-Bit Full Adder Design

## 📌 Overview
This project implements a fundamental 1-Bit Full Adder, a core combinational building block used for binary arithmetic in Arithmetic Logic Units (ALUs). Unlike a Half Adder, a Full Adder computes the sum of three distinct single-bit binary inputs, allowing for cascading architectures to handle multi-bit addition.

## 🖧 Hardware Architecture & Boolean Expressions
The circuit processes three inputs to compute a 2-bit binary result represented by a Sum and a Carry-Out bit. 

### Mathematical Formulations
* **Sum ($S$):** $A \oplus B \oplus C_{in}$
* **Carry-Out ($C_{out}$):** $(A \cdot B) + (C_{in} \cdot (A \oplus B))$

### Truth Table
| Input A | Input B | Carry-In (Cin) | Sum (S) | Carry-Out (Cout) |
| :-----: | :-----: | :------------: | :-----: | :--------------: |
|    0    |    0    |       0        |    0    |        0         |
|    0    |    0    |       1        |    1    |        0         |
|    0    |    1    |       0        |    1    |        0         |
|    0    |    1    |       1        |    0    |        1         |
|    1    |    0    |       0        |    1    |        0         |
|    1    |    0    |       1        |    0    |        1         |
|    1    |    1    |       0        |    0    |        1         |
|    1    |    1    |       1        |    1    |        1         |

---

## 🧪 Verification Strategy
The accompanying testbench applies an exhaustive stimulus sweep across all 8 possible input vector combinations. The design was verified using behavioral simulation to ensure no timing paths violate combinational settling bounds.

## 🔍 Key Engineering Takeaways
* **Cascading Foundation:** Verified the structural boundary conditions necessary to extend single-bit cells into multi-bit structures like Ripple Carry Adders (RCA).
* **Glitch Mitigation:** Observed and analyzed signal settling states in the waveform viewer to understand how propagation delays affect combinational outputs before reaching a stable state.
