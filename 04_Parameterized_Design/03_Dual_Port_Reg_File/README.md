# Synchronous Dual-Port Register File with Data Forwarding

## 📌 Overview
In highly pipelined processor architectures (such as a RISC-V execution core), the Arithmetic Logic Unit (ALU) must constantly read operands from and write computation results back to a central register file within tight clock cycles. This project implements an 8-word deep, 32-bit wide Synchronous Dual-Port Register File featuring two independent asynchronous read ports, a synchronous write port, and an internal zero-latency data forwarding (bypass) matrix to handle structural data hazards.

## 🧠 Hardware Architecture & Hazard Mitigation
A structural data hazard occurs when an instruction in a write-back pipeline stage attempts to update a specific register address at the exact same time a subsequent instruction in the decode stage tries to read data from that identical address. 

A naive memory array would return stale "old" data or cause meta-stable read values. To resolve this, this design implements **Write-Before-Read Data Forwarding Logic** via concurrent combinational multiplexing paths.

```verilog
assign r_data_a = (we && (r_addr_a == w_addr)) ? w_data : memory[r_addr_a];
assign r_data_b = (we && (r_addr_b == w_addr)) ? w_data : memory[r_addr_b];
By checking if a read address matches the active write target address during a write transaction, the internal multiplexing path completely bypasses the memory array delay. It routes the incoming write data bus straight to the output ports, ensuring downstream execution pipelines receive the freshest data with zero clock-cycle penalties.

---

## 🧪 Simulation Profile & Verification Trace
Validation was performed utilizing a self-checking behavioral testbench wrapper simulating a 50MHz (20ns cycle) system timing constraint.

### Functional Analysis Milestones
* **Asynchronous Master Reset:** Asserting `rst_n` activates a structural initialization loop that completely flushes the internal memory grid array down to a baseline `0x00000000`.
* **Simultaneous Multi-Port Reading:** Independent data fetching is verified by reading memory row `2` (`0xDEADBEEF`) and row `5` (`0xCAFEBABE`) concurrently over separate output ports without signal cross-talk or bottlenecking.
* **Data Forwarding Operational Success:** Zero-latency data bypass is demonstrated when a write operation to address `4` (`0xAAAABBBB`) directly intersects a read request targeting address `4`. The output port reflects the updating bus value instantly within the concurrent timing window.

---

## 🔍 Key Engineering Takeaways
* **Multi-Dimensional Array Synthesis:** Mastered modeling complex physical memory grids (`reg [WIDTH-1:0] name [0:DEPTH-1]`) in clean, synthesizable hardware representation.
* **Processor Pipeline Hazard Mitigation:** Implemented real-world silicon forwarding logic to solve data dependency hazards common in tier-1 processor design loops.
* **Dual-Port Structural Verification:** Constructed concurrent multi-bus test environments to validate asynchronous and synchronous memory interfaces simultaneously.
