# CPE-487

## All works are by Anthony Huang and Phineas Howell

# FPGA Pong Game

This project implements the classic Pong game on a Nexys FPGA board with VGA output. The design is written in VHDL and uses additional hardware (VGA monitor, keypad, on-board buttons) to allow interactive gameplay. The ball and paddles are drawn on a VGA display, and player scores are shown on a seven-segment display. Inputs include a keypad for controlling the left paddle and on-board buttons for controlling the right paddle and serving the ball.
![image](https://github.com/user-attachments/assets/ad9bee25-ec19-4bba-afaf-58ab16042340)
![image](https://github.com/user-attachments/assets/b17af6e0-bff2-413d-bbe2-4e515bf572f5)
![nexysboard](https://github.com/user-attachments/assets/874854f8-bf13-4f67-aabb-2b561d80ca17)


## Expected Behavior

Once the system is powered and programmed onto the Nexys board:

1. **Initial State:**  
   The display shows a blank field (the VGA screen with a background), the paddles at default positions, and the score (initially zero) on the seven-segment display.
   
2. **Serving and Gameplay:**  
   Pressing the serve button (`btn0`) launches the ball from the center of the screen. The ball moves toward one paddle. Players must move their paddles to intercept the ball:
   - The **Left Paddle** is controlled by a connected keypad.
   - The **Right Paddle** is controlled by on-board buttons (`btnl` to move up, `btnr` to move down).
   
   When the ball hits a paddle, it bounces back, and the player who hit the ball scores a point.

3. **Scoring System:**  
   Each time a point is scored, that player's score increments on the seven-segment display. Scores are displayed in hexadecimal, going from 0 through F.

4. **Continuing the Game:**  
   After a point is scored, press the serve button (`btn0`) again to re-launch the ball. The game can continue indefinitely, or players can decide to reset scores via a designated keypad key (if integrated).

## Steps to Get the Project Working in Vivado and on the Nexys Board

1. **Open Vivado and Create a New Project:**  
   - Launch Vivado.
   - Create a new RTL project, specify the target device (the one on your Nexys board), and add the provided VHDL source files and `.xdc` constraints file.

2. **Add Source Files and Constraints:**  
   - Include `pong.vhd` (top-level), `bat_n_ball.vhd`, `vga_sync.vhd`, `clk_wiz_0.vhd`, `leddec16.vhd`, and the keypad scanning logic if separate.
   - Add the provided `.xdc` constraint file that assigns pins for VGA signals, buttons, and keypad lines.

3. **Synthesize, Implement, and Generate Bitstream:**  
   - Run Synthesis and Implementation in Vivado.
   - Generate the bitstream file (`.bit`).

4. **Program the Nexys Board:**  
   - Connect the Nexys board to your PC via USB/JTAG.
   - Open the Hardware Manager in Vivado, detect the board, and program the generated `.bit` file.
   
5. **Connect Peripherals:**  
   - Attach a VGA monitor to the VGA port.
   - Connect a keypad to the assigned PMOD pins (if using a PMOD keypad or direct FPGA pins).
   - Ensure the on-board buttons are accessible.

6. **Run the Game:**  
   - Once programmed, you should see the paddles and a blank field.
   - Press `btn0` to serve and start the game.

## Description of Inputs and Outputs to the Nexys Board

- **Inputs:**
  - `clk_in`: Main system clock input from the Nexys board’s oscillator.
  - `btn0`: Serve button.
  - `btnl`: Move right paddle up.
  - `btnr`: Move right paddle down.
  - `E`: Keypad Move left paddle up.
  - `D`: Keypad Move leeft paddle down.
  
- **Outputs:**
  - `VGA_hsync`, `VGA_vsync`: VGA synchronization signals to drive the monitor.
  - `VGA_red[3:0]`, `VGA_green[3:0]`, `VGA_blue[3:0]`: Color signals to VGA.
  - `SEG7_anode[7:0]`, `SEG7_seg[6:0]`: Seven-segment display lines for scores.
  - `KB_row[3:0]`: Row signals to drive the keypad scanning.

The `.xdc` file specifies which FPGA pins connect to these ports, ensuring proper integration with the Nexys board hardware.

## Images and Videos of the Project

A demonstration of the working project is available here:  
[Video of Project Running](https://drive.google.com/file/d/15aVuuxRJrZlPj3xoUsR3up2gvnvvrSjO/view?usp=drive_link)

Note that this video is out of date. It shows a version that calculates the score inocrrectly. The latest version does not have this bug and displays scores correctly.

## Modifications

This project builds upon fundamental VGA output and input control logic. Notable modifications and expansions include:

- **Keypad Integration for Paddle Control:**  
  Instead of using only on-board buttons, the left paddle is controlled by keypad input. This required adding a row-column scanning process, decoding pressed keys, and mapping them to paddle movement.

- **Extended Score Display:**  
  Scores are shown on a multi-digit seven-segment display, requiring a custom VHDL decoder that can handle multiple hexadecimal digits simultaneously.

- **Custom Timing and Movement:**  
  Adjusted the ball speed, paddle step size, and timing signals for smoother gameplay. The `count` signal and various if-conditions ensure that paddle and ball movements occur at a human-playable pace.

## Conclusion and Summary of the Project

**Contributors and Responsibilities:**  
- All team members collectively contributed to coding the VHDL logic, integrating the VGA and keypad interface, and refining the scoring system. Each member assisted in synthesis, debugging, and testing on the Nexys board.

**Timeline and Challenges:**  
- Initial setup and VGA output were completed early on.  
- Integrating the keypad control and ensuring stable paddle movement took additional time due to timing and scanning complexity.  
- Implementing scoring and verifying that increments occurred correctly when the ball went off-screen involved careful debugging.  
- The final milestone involved linking all modules together, adjusting parameters for gameplay feel, and confirming the display updated as intended.

**Difficulties and Solutions:**  
- Achieving stable keypad input required experimenting with scan delays and debouncing logic.  
- Ensuring the ball’s logic and scoring signals were synced with the VGA refresh pulses required careful review of processes and rising edge conditions.

**Project Outcome:**  
The final result is a functioning hardware-accelerated Pong game on an FPGA, complete with VGA output, real-time input from both keypad and buttons, and a live score display. This project demonstrates the integration of multiple FPGA components (I/O, display, timing) to create an interactive and visually engaging system.

