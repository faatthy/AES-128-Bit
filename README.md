# AES Encryption Wrapper for FPGA

This repository contains the **AES Hardware Wrapper** written in Verilog, designed for FPGA prototyping.
The wrapper interfaces a standard AES core with serial input/output and control signals, enabling easy hardware integration.

---

## 🔥 Project Overview

* **AES Core** — Standard 128-bit AES block
* **AES\_WRAPPER** — Converts parallel AES core to serial I/O interface (8-bit input/output)
* **Testbench** — Simulates AES\_WRAPPER behavior with sample plaintext/key

---

## 🛠️ Block Diagram

<img width="492" height="309" alt="image" src="https://github.com/user-attachments/assets/c2334309-817a-41c2-a7f1-72de63dcd151" />


---

## 📝 Features

* ✅ Serial Plaintext and Key Input (8-bit bus)
* ✅ Serial Ciphertext Output (8-bit bus)
* ✅ AES starts automatically after input collection
* ✅ Output ready signal (`valid`) for ciphertext monitoring
* ✅ Suitable for FPGA & ASIC integration

---

## 🚀 Usage

### RTL Files

* `AES.v` — AES core (must implement 128-bit encryption logic)
* `AES_WRAPPER.v` — Wrapper around AES core with serial interface

### Simulation

* `AES_WRAPPER_tb.v` — Testbench simulating wrapper operation

<p align="center">
  <img src="images/aes_waveform.png" alt="AES Simulation Waveform" width="600"/>
</p>

---

## 🖥️ FPGA Integration Example

* **Clock** — 100 MHz
* **I/O Standard** — LVCMOS18
* **Reset** — Active Low
* **Timing Constraints** — Provided for ZCU106

<p align="center">
  <img src="images/fpga_io_setup.png" alt="FPGA I/O Setup Example" width="500"/>
</p>

---

## 📂 Directory Structure

```
├── src
│   ├── AES.v
│   ├── AES_WRAPPER.v
├── sim
│   ├── AES_WRAPPER_tb.v
├── constraints
│   ├── AES_WRAPPER.xdc
├── images
│   ├── aes_wrapper_block.png
│   ├── aes_waveform.png
│   ├── fpga_io_setup.png
├── README.md
```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**Fathy Mostafa**
Bachelor of Electronics & Communications Engineering
Cairo University

---

## ⭐ Give a Star if You Like the Project!
