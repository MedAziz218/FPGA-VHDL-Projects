# FPGA 7-Segment Counter for DE10-Lite

A simple 7-segment counter implemented on the DE10-Lite FPGA board using VHDL.

## Overview

This project implements a binary counter that displays values from 0 to 9 on a 7-segment display. The design includes a BCD to 7-segment converter and a clock divider to create a 1Hz counter.

## Features

- **BCD to 7-Segment Display**: Shows numbers 0 to 9.
- **Clock Divider**: Reduces FPGA clock speed for the counter.
- **Reset Function**: Reset the counter using a push-button.
- **Simulation with ModelSim**: Simulated different parts of the design (BCD to 7-segment, clock divider, counter) using ModelSim to verify functionality.
