# Synthesizable Full-Duplex UART Peripheral Subsystem

## 📌 Overview
This repository contains a complete, production-grade Universal Asynchronous Receiver-Transmitter (UART) communication peripheral subsystem. By nesting a dedicated, parameterized Transmitter (TX) module and an independent Oversampling Receiver (RX) module into a unified structural top-level design wrapper, this hardware architecture enables simultaneous, full-duplex serial data communication.

---

## 📐 Microarchitectural Specification & Sub-Block Topologies

### 1. Parametric Clock Generation & 16x Oversampling Matrix
To safely capture incoming asynchronous data from an external clock domain without sampling transitions on noisy or meta-stable signal edges, the receiver sub-module implements a **16x Oversampling Scheme**.

* **System Clock Frequency ($F_{\text{CLK}}$):** `50,000,000 Hz` (50 MHz)
* **Target Communication Baud Rate ($B$):** `115,200 bits per second`

$$\text{Receiver Sampling Tick Interval} = \frac{F_{\text{CLK}}}{B \times 16} = \frac{50,000,000}{1,843,200} \approx 27 \text{ clock cycles}$$

A high-speed combinational pulse generator triggers an internal `baud_tick` flag precisely every 27 clock cycles. This drives a secondary oversampling tracker inside the receiver FSM:
* **Start Bit Validation:** Upon detecting a falling edge on the input line, the core counts 7 oversampling ticks to locate the exact mathematical **midpoint** of the start bit. If the line is validated low, the frame is confirmed.
* **Payload Serialization:** For subsequent data bits, the engine counts 16 oversampling ticks to step completely past the noisy bit-boundary transitions and samples the signal cleanly at the center of the bit window.

### 2. Double-Flop Synchronizer (Meta-stability Shield)
To isolate the receiver's internal state machine from asynchronous metastability, the inbound `rx` signal passes through a cascaded chain of two sequential D Flip-Flops. This structural interlock allows any unstable voltage states to settle, snapping the raw signal cleanly into the chip's local clock domain.

---

## 🧪 Verification Profile: Internal Loopback Analysis
Functional verification was executed using a dedicated top-level testbench environment utilizing an internal loopback topology (`assign rx = tx`).

### Functional Analysis Milestones
* **Frame Transmit-Receive Alignment:** Instigating a transfer of data byte `8'h5A` (`01011010`) forces the transmitter to serialize the payload, outputting the LSB first over the `tx` wire.
* **Real-Time Data Capture:** The receiver double-flop chain processes the incoming stream simultaneously, stepping through its oversampling routines to shift bits sequentially into an internal holding array.
* **Transaction Validation:** At the $82.4\,\mu\text{s}$ mark, the stop bit is validated high. The internal controller immediately updates the parallel output bus to `5a` and raises `rx_ready` to alert the CPU. No framing errors were recorded.

---

## 🔍 Key Engineering Takeaways
* **Asynchronous Clock Domain Synchronization:** Implemented multi-stage flip-flop synchronization networks to successfully insulate state machines from timing hazards.
* **Midpoint Sampling Architecture:** Developed dual-nested counter arrays (counting 27 cycles per tick, and 16 ticks per bit) to track stable signal plateaus amidst external line noise.
* **Modular Structural Stitching:** Layered hardware modules into a multi-tiered structural hierarchy, keeping execution blocks cleanly isolated and parameterized.
