# 2-to-4 Binary Decoder Design

## 📌 Overview
This project implements a 2-to-4 Binary Decoder, a combinational circuit designed to convert binary information from $n$ input lines to a maximum of $2^n$ unique output lines. Decoders are heavily relied upon in computer engineering for memory address decoding, instruction decoding, and data demultiplexing.

## 🖧 Hardware Architecture & Logic Mapping
The circuit decodes a 2-bit binary input value into 4 mutually exclusive outputs. Only one output line is asserted active-high at any given time, corresponding directly to the decimal equivalent of the binary input vector.

### Truth Table
| Input Bit 1 (sel[1]) | Input Bit 0 (sel[0]) | Out 0 (y[0]) | Out 1 (y[1]) | Out 2 (y[2]) | Out 3 (y[3]) |
| :------------------: | :------------------: | :----------: | :----------: | :----------: | :----------: |
|          0           |          0           |      1       |      0       |      0       |      0       |
|          0           |          1           |      0       |      1       |      0       |      0       |
|          1           |          0           |      0       |      0       |      1       |      0       |
|          1           |          1           |      0       |      0       |      0       |      1       |

---

## 🧪 Verification Strategy
The simulation setup applies a continuous binary count increment to the selection bus. The resulting wave trace explicitly maps out the "one-hot" shifting pattern across the output vector bus, proving proper combinational decoding.

## 🔍 Key Engineering Takeaways
* **Bus Vector Slicing:** Utilized structured vector bus arrays to handle inputs and outputs cleanly, laying the groundwork for complex memory indexing logic.
* **One-Hot Encoding Verification:** Confirmed that mutual exclusivity is maintained perfectly across the output bus during switching intervals, preventing dual-line assertion hazards.
