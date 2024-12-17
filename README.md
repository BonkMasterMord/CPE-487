 # CPE-487

## All works are by Anthony Huang and Phineas Howell

# FPGA Pong Game

This project implements the classic Pong game on a Nexys FPGA board with VGA output. The design is written in VHDL and uses additional hardware (VGA monitor, keypad, on-board buttons) to allow interactive gameplay. The ball and paddles are drawn on a VGA display, and player scores are shown on a seven-segment display. Inputs include a keypad for controlling the left paddle and on-board buttons for controlling the right paddle and serving the ball.

<img src="https://github.com/user-attachments/assets/ad9bee25-ec19-4bba-afaf-58ab16042340" alt="Alt Text" width="300" height="200">
<img src="https://github.com/user-attachments/assets/b17af6e0-bff2-413d-bbe2-4e515bf572f5" alt="Alt Text" width="300" height="200">
<img src="https://github.com/user-attachments/assets/874854f8-bf13-4f67-aabb-2b561d80ca17" alt="Alt Text" width="300" height="200">


## Expected Behavior

Once the system is powered and programmed onto the Nexys board:

1. **Initial State:**  
   The display shows a blank field (the VGA screen with a background), the paddles at default positions, and the score (initially zero) on the seven-segment display.
   Implementing two inputs from seperate devices, elminating the need to fight over the buttons on the Nexys board that are already crammed.
   
3. **Serving and Gameplay:**  
   Pressing the serve button (`btn0`) launches the ball from the center of the screen. The ball moves toward one paddle. Players must move their paddles to intercept the ball before it reaches the ends of their screen:
   - The **Left Paddle** is controlled by a connected keypad (`E` to move up, `D` to move down).
   - The **Right Paddle** is controlled by on-board buttons (`btnl` to move up, `btnr` to move down).
   
   When the ball hits a paddle, it bounces back, and the player who hit the ball scores a point.

4. **Scoring System:**  
   Each time a player reflects the ball 1 point is scored, everytime a player hits the ball to the other end of the board will score 2 points. 
   Player's score increments on the seven-segment display.
   Scores are displayed in hexadecimal, going from 0 through F.

6. **Continuing the Game:**  
   After a point is scored, press the serve button (`btn0`) again to re-launch the ball. The game can continue indefinitely, or players can decide to reset scores via a designated keypad key (if integrated).

 <img src="https://github.com/user-attachments/assets/67759aa8-23ae-4f43-96a5-3fdd8dc3806d" alt="Alt Text" width="500" height="400">


## Steps to Get the Project Working in Vivado and on the Nexys Board

1. **Open Vivado and Create a New Project:**  
   - Launch Vivado.
   - Create a new RTL project, specify the target device (the one on your Nexys board), and add the provided VHDL source files and `.xdc` constraints file.

2. **Add Source Files and Constraints:**  
   - Include `pong.vhd` (top-level), `bat_n_ball.vhd`, `vga_sync.vhd`, `clk_wiz_0.vhd`, `leddec16.vhd`, and the keypad scanning logic if separate.
   - Add the provided `pong.xdc` constraint file that assigns pins for VGA signals, buttons, and keypad lines.
  

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

## Description of Inputs and Outputs of button controls to the Nexys Board with constraint file

- **Inputs:**
  - `clk_in`: Main system clock input from the Nexys board’s oscillator.
  - `btn0`: Serve button.
  - `btnl`: Move right paddle up.
  - `btnr`: Move right paddle down.
  - `E`: Keypad Move left paddle up.
  - `D`: Keypad Move leeft paddle down.

```
# Buttons
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {btn0}]
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {btnl}]
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports {btnr}]

# Keypad (4x4) from HexCalc
# Columns as inputs (KB_col[3:0])
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports {KB_col[3]}]
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports {KB_col[2]}]
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports {KB_col[1]}]
set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports {KB_col[0]}]

# Rows as outputs (KB_row[3:0])
set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports {KB_row[3]}]
set_property -dict { PACKAGE_PIN F18 IOSTANDARD LVCMOS33 } [get_ports {KB_row[2]}]
set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports {KB_row[1]}]
set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports {KB_row[0]}]
```

  
- **Outputs:**
  - `VGA_hsync`, `VGA_vsync`: VGA synchronization signals to drive the monitor.
  - `VGA_red[3:0]`, `VGA_green[3:0]`, `VGA_blue[3:0]`: Color signals to VGA.
  - `SEG7_anode[7:0]`, `SEG7_seg[6:0]`: Seven-segment display lines for scores.
  - `KB_row[3:0]`: Row signals to drive the keypad scanning.

The `.xdc` file specifies which FPGA pins connect to these ports, ensuring proper integration with the Nexys board hardware.

## Images and Videos of the Project

A demonstration of the working project is available here:  
[Video of Project Running](https://drive.google.com/file/d/15aVuuxRJrZlPj3xoUsR3up2gvnvvrSjO/view?usp=drive_link)

Note that this video is out of date, but all the physics are functioning properly. It shows a version that calculates the score inocrrectly.  
The latest version does not have this bug and displays scores correctly.

## Modifications

This project builds upon fundamental VGA output and input control logic. Notable modifications and expansions include:

- **Keypad Integration for Paddle Control:**  
  Instead of using only on-board buttons, the left paddle is controlled by keypad input. This required adding a fsm (borrowed from lab 4) with a row-column scanning process, decoding pressed keys, and mapping them to paddle movement.
```
  KB_row <= row_scan;
  col_scan <= KB_col;
    
    -- Keypad scanning process
    keypad_scan : PROCESS(clk_in)
    BEGIN
       IF rising_edge(clk_in) THEN
          scan_delay <= scan_delay + 1;
          IF scan_delay > 64 THEN 
             scan_delay <= 0;
             scan_state <= (scan_state + 1) MOD 4;
             
             CASE scan_state IS
                WHEN 0 =>
                   row_scan <= "1110";
                WHEN 1 =>
                   row_scan <= "1101";
                WHEN 2 =>
                   row_scan <= "1011";
                WHEN 3 =>
                   row_scan <= "0111";
             END CASE;
          END IF;
       END IF;
    END PROCESS;
    
    -- Keypad decode process
    key_decode : PROCESS(row_scan, col_scan)
    BEGIN
       paddle_up <= '0';
       paddle_down <= '0';
       
       IF row_scan = "1110" THEN
          IF col_scan = "1110" THEN
             paddle_down <= '1';
          ELSIF col_scan = "1101" THEN
             paddle_up <= '1';
          END IF;
       END IF;
    END PROCESS;
```
- **Extended Score Display:**  
  Scores are shown on a multi-digit seven-segment display, requiring a custom VHDL decoder that can handle multiple hexadecimal digits simultaneously.
  ```
   sendT <= scoreTover2(15 downto 0) & scoreT2over2(15 downto 0);
  ```

- **Sending OUT score signals back to the top level (pong.vhd)**  
  How we sent scores back into pong.vhd (pong.vhd contains score1_inc & score2_inc) which will be fed into data after some refinement with the bits
 ```
    score1_inc <= score1(15 downto 0);
    score2_inc <= score2(15 downto 0);
  ```
- **Initializing fixed bat positions**  
  Keep Bats at a fixed X position
  ```
    CONSTANT bat_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100, 11);
    Constant bat_x2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(700, 11);
  ```
- **Setting condition to increase score (basically whenever ball hits bat)**
  A trigger would occur everytime the ball reflects off of a bat (borrowed from Lab 6), causing score to increase.
  ```
              trigger <= '1';
           
                END IF;
                IF trigger = '1' then
                       score1 <= score1 + 1;
                       trigger <= NOT trigger;
        END IF;

                     trigger2 <= '1';
        END IF;
                IF trigger2 = '1' then
                       score2 <= score2 + 1;
                       trigger2 <= NOT trigger2;
        END IF;

  ```

- **Custom Timing and Movement:**  
  Adjusted the ball speed, paddle step size, and timing signals for smoother gameplay.
  We adjusted the batwidth and height to fit our pong style profile.
  ```
      CONSTANT bsize : INTEGER := 8; -- ball size in pixels
    signal bat_w : INTEGER := 3; -- bat width in pixels
    constant bat_h : INTEGER := 60; -- bat height in pixels
    -- distance ball moves each frame
    signal ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(6, 11);
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAl bat_on2 : STD_LOGIC;
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in playby
    -- current ball position - intitialized to center of screen
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
  ```
- ** Scoring mechanism for when the ball reaches the left or right of the board**  
  Essesntially we had an offscreen std_logic trigger that would go off everytime the ball reaches the end of the board with the condition that the game is still on  
```
 IF ball_x + bsize >= 800 THEN -- bounce off right wall
            ball_x_motion <= (NOT ball_speed) + 1; -- set hspeed to (- ball_speed) pixels
                if offscreen_trigger = '0' then
                     if game_on = '1' then
                        score1 <= score1 + 4;
                    end if;
                 offscreen_trigger <= '1';
                end if;
                game_on <= '0'; -- and make ball disappear
        ELSIF ball_x <= bsize THEN -- bounce off left wall
            ball_x_motion <= ball_speed; -- set hspeed to (+ ball_speed) pixels
                if offscreen_trigger = '0' then
                if game_on = '1' then
                    score2 <= score2 + 4;
                end if;
                 offscreen_trigger <= '1';
                end if;
                game_on <= '0'; -- and make ball disappear
```
## Conclusion and Summary of the Project

**Contributors and Responsibilities:**  
- Anthony: Responsible for coding bat1's movement, game physics, score count, data inputs, trigger logic, and debuging
- Phineas: Responsible for coding bat2's movement (involving HexCalc), score accuarcy, score display, data outputs, and debuging  
**Timeline and Challenges:**  
- DAY 1: Initial setup and VGA output were completed early on, generated the platform with the two bats that will be displayed.  
- DAY 2: Integrating the keypad control and ensuring stable paddle movement took additional time due to timing and scanning complexity, along side scoring mechanism.  
- DAY 3: Figuring out why the score kept increasing by 2's everytime we bounced the ball, instead of by 1's like we intended. We also debugged any additional kinks in the code.
- DAY 4: The final milestone involved linking all modules together, adjusting parameters for gameplay feel, and confirming the display updated as intended.

**Difficulties and Solutions:**  
Issue: Bat2 did not show up initially   
Solution: We made an "OR" statement for bat1_on and bat2_on so that Bat will also now show up as cyan.
```
 red <= NOT (bat_on OR bat_on2); -- color setup for red ball and cyan bat on white background
    green <= NOT ball_on;
    blue <= NOT ball_on;
```

Issue: Bat1 was unable to bounce the ball back, but Bat2 was able to.  
Solution: Change NOT ball_speed to just ball_speed because it needs to bounce to the right (positve end) 
```
 ball_x_motion <= ball_speed + 1; -- set vspeed to (ball_speed) pixels
```

Issue: Bats kept dissappearing whenever you move too high or too low.  
Solution: Restrict how far you can move up and move down through pixel constraints in pong.vhd
```
     pos1 : PROCESS (clk_in)
    BEGIN
       if rising_edge(clk_in) then
            count <= count + 1;
            IF (btnl = '1' and count = 0 and batpos > **75**) THEN
                batpos <= batpos - 10;
            ELSIF (btnr = '1' and count = 0 and batpos < **530**) THEN
                batpos <= batpos + 10;
            END IF;
        end if;
    END PROCESS;
```

Issue: Bats were not centered everytime the game started.  
Solution: Initialize the Bat's pixel coordinates in the component bat_n_ball under pong.vhd
```
            bat_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(300, 11);
            bat_y2 : IN STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
```
Issue: Scores kept randomely increasing.  
Solution: Add additional conditions when the ball reflects or when the ball enters the other players end.
```
  IF game_on = '1' AND (ball_x + bsize/2) >= (bat_x - bat_w) AND..
  IF game_on = '1' AND (ball_x + bsize/2) >= (bat_x2 - bat_w) AND..
```

Issue: Scores kept increasing in 2's.  
Solution: Shift bits in the top level of pong where they will be sent to data.
```
    scoreTover2 <= '0' & scoreT(scoreT'high downto 1);
    scoreT2over2 <= '0' & scoreT2(scoreT'high downto 1);
```

**Project Outcome:**  
The final result is a functioning hardware-accelerated Pong game on an FPGA, complete with VGA output, real-time input from both keypad and buttons, and a live score display. This project demonstrates the integration of multiple FPGA components (I/O, display, timing) to create an interactive pong style gameplay. 

**Things we could improve or would like to do if given more time**
- Center the ball a bit better so it will fly in a more uniform way.
- Create switches that can change the color of the bats or background, allowing for customization.
- Allow for multiple balls to be served at the same time by adding button input from the HexCalc (more fun game).

