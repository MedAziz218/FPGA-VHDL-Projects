# FPGA 7-Segment Counter for DE10-Lite

### Overview

This project implements a binary counter for the DE10-Lite FPGA board, which drives a 7-segment display to count from 0 to 9. The core functionality includes a binary-coded decimal (BCD) to 7-segment display converter and a clock divider to generate a 1Hz clock signal. Additionally, a push-button allows the counter to be reset to zero.

### Features

- **BCD to 7-Segment Display**: Displays digits from 0 to 9 using the FPGA's 7-segment display.
- **Clock Divider**: Reduces the 50MHz FPGA clock down to 1Hz, ensuring the counter increments every second.
- **Reset Function**: A manual reset button is included to reset the counter.
- **Simulation Support**: Simulations are performed using ModelSim to verify each part of the design (counter, clock divider, BCD to 7-segment conversion).

---

### Tools Required

- **Quartus Prime 20.1**: For compilation and uploading the design to the DE10-Lite board.
- **ModelSim 20.1**: For simulating the VHDL design before hardware implementation.

---

### Running the Project

1. **Clone the Repository**: Clone the project repository to your local machine.
2. **Open the Project in Quartus**:
    - Launch Quartus Prime.
    - Navigate to `File > Open Project`.
    - Select the project file (`Counter7Segment.qpf`).
3. **Compile the Design**: Use the Quartus compiler to build the design.
4. **Upload to FPGA**:
    - Use the Quartus Programmer to upload the design to the DE10-Lite board.

---

### Simulation with ModelSim

1. **Setup Simulation in Quartus**:
    - Go to `Assignments > Settings`.
    - In the "Settings" window, navigate to `EDA Tool Settings > Simulation`.
    - Set the **Tool Name** to "ModelSim-Altera".
    - Select **VHDL** as the output format.
    - Set the output directory (preferably to `...\Counter7Segment\simulation\modelsim`).

2. **Add the Test Bench**:
    - In the same Simulation Settings window, under **NativeLink Settings**, check "Compile test bench".
    - Click **Test Benches** and add the `test_bench.vhd` file located in `src\test_bench.vhd`.
    - Click **Add**, then **OK**.
    - Apply the settings and close the window.

3. **Specify ModelSim Installation Path**:
    - Go to `Tools > Options > General > EDA Tool Options`.
    - Set the **ModelSim-Altera Path** to your ModelSim installation location (usually `C:\intelFPGA\20.1\modelsim_ase\win32aloem`).
    - Click **OK** to save and exit.

4. **Running the Simulation**:
    - Compile the project in Quartus.
    - Go to `Tools > Run Simulation Tool > RTL Simulation` to run the simulation.

---

This setup will let you test the 7-segment counter design using ModelSim before uploading it to the FPGA board.