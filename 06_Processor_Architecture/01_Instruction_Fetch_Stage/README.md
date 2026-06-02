# RISC-V (RV32I) Instruction Fetch Subsystem Architecture

## 📌 Overview
This directory contains the foundational hardware execution stage of a 32-bit single-cycle RISC-V (RV32I) processor core: the **Instruction Fetch (IF) Stage**. Comprising a runtime-configurable Program Counter (PC) module and a high-speed combinational Instruction Memory look-up array, this subsystem cooperatively fetches sequential machine instructions from program memory space every master clock cycle.

---

## 📐 Microarchitectural Specification & Circuit Topologies



### 1. Program Counter Core (`riscv_pc.v`)
The Program Counter functions as a synchronous 32-bit pointer register that maintains the active instruction memory execution track.
* **Sequential Control Loop:** Under normal operating conditions, the module executes sequential instruction increments by computing a combinational look-ahead step:
$$\text{Next PC} = \text{Current PC} + 4$$
* **Control Hazard Overrides:** To support branch decisions (e.g., `beq`, `bne`) and unconditional jumps (`jal`), the core integrates a combinational 2-to-1 multiplexer driven by an execution-stage control flag (`branch_taken`). When asserted, the PC instantly bypasses sequential increments and latches the pre-calculated `branch_target_addr` bus instead.

### 2. Word-Aligned Instruction Memory Core (`riscv_instruction_mem.v`)
The Instruction Memory is modeled as a read-only lookup table (ROM) holding compiled 32-bit RV32I integer instruction structures.
* **Byte-to-Word Address Translation:** Because standard computer memories are byte-addressed while RV32I instructions are uniformly 4 bytes (32 bits) wide, consecutive valid instructions sit at byte multiples of four (`0x0`, `0x4`, `0x8`, `0xC`).
* **Hardware Addressing Formulation:** To map these 32-bit byte-addresses directly onto our hardware register array slots without resource wasting, the core implements a strategic bit-slice index mapping operation:

```verilog
wire [5:0] rom_index = instruction_addr[7:2];
```
### 📐 Microarchitectural Addressing Formulation
By dropping the lowest two bits (`[1:0]`), the hardware performs an instantaneous, zero-cost shift-right operation, effectively dividing the incoming byte address by 4 to cleanly extract word-aligned instruction packets.

---

## 🔍 Key Engineering Takeaways

* **Hardware Port-Width Alignment:** Connected 32-bit address channels flawlessly across structural boundaries, aligning sequential pointer data paths cleanly to instruction memory array ports.
* **Combinational Continuous Array Routing:** Leveraged index-based multiplexing arrays (`assign instruction_out = rom_memory[rom_index]`) to achieve near-instantaneous instruction access without introducing unnecessary clock delays.
* **Protective Guard Routines:** Explored explicit address-masking interlocks (`write_reg_address != 5'd0`) to cleanly enforce core architecture requirements like the hardwired `x0 = 0` constraint.
