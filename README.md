# General Signal Generator - MATLAB Application

## Overview
The **General Signal Generator** is a MATLAB-based application developed to allow users to generate and manipulate time-domain signals. This interactive tool is designed to help students and professionals explore various signal properties and operations, reinforcing their understanding of signal processing concepts. The application provides immediate visual feedback, making it ideal for both learning and experimentation.

### Project Information
- **Course**: Signals and Systems: Mini Project I
- **University**: University of Alexandria
- **Course Code**: EEC 271
- **Date**: Spring 2024
- **Contributors**: 
  - Yehia Said Gewily
  - Yahya Emad El-Deen El-Kony
  - Ahmed Saeed Muhammed
  - Muhammed Ibrahim Risk

---

## Features
1. **Signal Generation**:
   - Supports the generation of various signal types: DC, Ramp, Polynomial, Exponential, Sinusoidal, Sinc, and Triangle.
   - Allows users to specify signal parameters such as amplitude, frequency, phase, and more.
   - Signal intervals are defined by user-input breakpoints, enabling complex piecewise signal construction.

2. **Signal Operations**:
   - Provides several operations to manipulate signals: Scale, Reverse, Shift, Expand, Compress, Clip, and Derivative.
   - Each operation is applied interactively, and the resulting signal is displayed visually for comparison.

3. **User Interaction**:
   - User inputs are collected for sampling frequency, time scale, breakpoints, and signal type parameters.
   - Operations can be applied iteratively until the user decides to stop, with the option to view both the original and modified signals at any time.

4. **Immediate Visualization**:
   - The generated signals and any modifications are plotted immediately, offering users a clear visual representation of the signal's behavior.
   - This feature is key for understanding the impact of different signal operations and transformations.

---

## Program Structure
### 1. `main.m`
The **main** function coordinates the signal generation and modification process:
- Collects user inputs for signal parameters.
- Generates the initial signal based on these parameters.
- Allows users to apply various operations to the signal in a loop until they choose to stop.
- Plots both the original and modified signals for comparison.

### 2. `getUserInputs.m`
This function gathers all necessary inputs from the user, including:
- Sampling frequency (Fs)
- Start and end times for the time scale
- Number of breakpoints and their positions
- Type of signal and its specific parameters (e.g., amplitude, frequency, etc.)

### 3. `generateSignal.m`
The signal is constructed using user-defined breakpoints to divide the time scale into intervals. For each interval, the signal type and parameters are chosen dynamically by the user.

### 4. `applyOperations.m`
Modifies the signal based on the user’s choice of operations, such as scaling or shifting. The modified signal is plotted after each operation for immediate feedback.

### 5. `plotSignal.m`
Helper function to plot the signals with appropriate labels, ensuring that users can visualize both the original and modified signals.

### 6. `computeDerivative.m`
This function calculates the derivative of the signal using a central difference method, providing a more accurate and stable estimate compared to basic differentiation techniques.

---

## Installation and Usage
1. **Installation**:
   - Download or clone the repository containing the MATLAB files.
   - Ensure MATLAB is installed on your system.

2. **Running the Application**:
   - Open MATLAB.
   - Navigate to the folder containing the project files.
   - Run the `main.m` file by typing `main` in the MATLAB command window.

3. **User Interaction**:
   - Follow the on-screen prompts to input signal parameters.
   - After generating a signal, select operations to modify it and visualize the results.
   - Continue applying operations or stop to exit the program.

---

## Example Use Cases
### Example 1: DC Signal Generation
1. Generate a simple DC signal with an amplitude of 5.
2. Apply scaling by a factor of 2.
3. Reverse the signal.
4. Plot the results.

### Example 2: Sinusoidal Signal with Time Shift
1. Generate a sinusoidal signal with an amplitude of 1, frequency of 5 Hz, and phase of 0.
2. Apply a time shift of 1 second.
3. View the modified signal.

---

## Future Enhancements
- **Additional Operations**: Include more advanced signal processing operations like filtering.
- **GUI Implementation**: A graphical user interface (GUI) could be added to improve user experience.
- **Data Export**: Add functionality to export generated and modified signals to external files for further analysis.

---

## Conclusion
This project successfully provides a comprehensive platform for generating and manipulating time-domain signals, reinforcing signal processing concepts through practical interaction. With its immediate visual feedback and flexible operations, the **General Signal Generator** is an invaluable tool for both academic learning and practical experimentation.
