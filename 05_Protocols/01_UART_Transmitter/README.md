# Synthesizable Full-Duplex UART Transmitter Core

## 📌 Overview
This repository contains a robust, synthesizable Universal Asynchronous Receiver-Transmitter (UART) Transmitter IP core designed in Verilog HDL. The module handles the parallel-to-serial conversion of 8-bit data bytes, wrapping the payload with mandatory framing constraints (1 Start Bit, 1 Stop Bit) while operating under a completely configurable system clock frequency and baud rate matrix.

## 📐 Internal Timing & Baud Rate Divider Math
Because UART communication operates asynchronously without a shared reference clock line, the local silicon core must calculate precise data bit tracking windows using internal high-speed counters.

### Hardware Formulation
* **System Clock Frequency ($F_{\text{CLK}}$):** `50,000,000 Hz` (50 MHz)
* **Target Communication Baud Rate ($B$):** `115,200 bits per second`

$$\text{Clock Cycles Per Bit} = \frac{F_{\text{CLK}}}{B} = \frac{50,000,000}{115,200} \approx 434 \text{ clock cycles}$$

The core utilizes a 9-bit timing division counter (`clk_count`) to track this window. It asserts state transitions exactly every 434 clock cycles, ensuring a rock-solid communication cadence.

---

## 🚦 Finite State Machine (FSM) Architecture
The serialization engine is driven by an explicit 4-state Finite State Machine:

* **`STATE_IDLE` (2'b00):** Holds the physical `tx` line at a stable logic high (`1`). Awaits a control pulse from the CPU on `tx_start` to latch the parallel data bus into an internal shadow holding register (`tx_data_reg`).
* **`STATE_START` (2'b01):** Pulls the physical line to logic low (`0`) for exactly 434 clock cycles, validating the frame packet start marker for downstream receivers.
* **`STATE_DATA` (2'b10):** Sequentially steps an internal 3-bit MUX pointer (`bit_index`) from `0` to `7`. This serializes the payload byte, driving the `tx` wire with the Least Significant Bit (LSB) first up to the Most Significant Bit (MSB).
* **`STATE_STOP` (2'b11):** Returns the physical line to a logic high (`1`) to execute frame closure, pulses the `tx_done` pin to alert the internal processor, and transitions smoothly back to `STATE_IDLE`.

---

## 🔍 Key Engineering Takeaways
* **Hardware Parallel-to-Serial Conversion:** Leveraged index-based multiplexing (`tx_data_reg[bit_index]`) to flatten an 8-bit parallel register into a serialized bitstream over a single physical wire.
* **Derived Parametric Clock Division:** Avoided hardcoded timing thresholds by relying on compile-time parameter expressions (`CLK_FREQ / BAUD_RATE`) to maintain portability across varied silicon targets.
* **Packet Framing Integrity Protection:** Locked input buses during active transaction loops using internal holding registers, preventing upstream processor operations from inducing frame corruption.
