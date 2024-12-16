# CPE-487

## All works are by Anthony Huang and Phineas Howell

# Pong on FPGA

This project implements the classic Pong game on an FPGA with VGA output and an integrated scoring system displayed on seven-segment displays. The design uses VHDL to define the logic of the game, including paddle movement, ball physics, and scoring. A keypad and buttons provide inputs to control the paddles, serve the ball, and display the score in real-time.

## Features

- **VGA Output:**  
  Renders the Pong game on a connected VGA monitor, showing the ball, paddles, and playfield boundaries.
  
- **Paddle Control:**  
  - Left paddle controlled by keypad inputs.  
  - Right paddle controlled by on-board buttons (e.g., `btnl` and `btnr`).
  
- **Scoring System:**  
  Once a player scores by getting the ball past the opponent’s paddle, the respective player’s score is incremented. Scores are shown on a four-digit hexadecimal display. The left player’s score is on the left side of the display, and the right player’s score is on the right side.

- **Serve Function:**  
  Pressing the serve button (`btn0`) places the ball back into play from the center of the screen, allowing the next rally to begin immediately.

- **User Interaction via Keypad and Buttons:**  
  - Keypad: Move the left paddle up and down by pressing designated keys.  
  - On-board Buttons (`btnl`, `btnr`): Move the right paddle up and down.  
  - `btn0` (Serve): Start a new volley by serving the ball from the center position.

## Gameplay

1. **Starting a Rally:**  
   Press `btn0` to serve the ball onto the screen. The ball will begin moving toward one of the paddles.

2. **Controlling the Paddles:**  
   The left paddle moves based on keypad input (selected keys cause it to move up or down), and the right paddle is controlled by `btnl` (move up) and `btnr` (move down).

3. **Scoring a Point:**  
   If the ball passes entirely off one side of the screen, the opposite player scores a point. The respective score increments by one digit (in hex) on the seven-segment display.

4. **Continuing the Game:**  
   After a point is scored, press `btn0` again to serve the ball and continue the game.

## How It Works

- **Ball and Paddle Logic:**  
  The `bat_n_ball` component manages the ball’s movement and collision detection. When the ball hits a paddle, it bounces back. If it misses and goes off-screen, the scoring signals (`score1_inc` and `score2_inc`) are generated.

- **Scoring and Display:**  
  The scoring increments happen when `bat_n_ball` detects a point and outputs a score increment vector. This vector is directly mapped to the seven-segment display driver, which updates the displayed score.

- **Keypad Scanning:**  
  The keypad is scanned row-by-row, and the code decodes pressed keys to determine paddle movement commands.

## Controls Summary

- **Left Paddle (Keypad):** Specific keys on the keypad move the paddle up or down.
- **Right Paddle (On-Board Buttons):**
  - `btnl`: Move paddle up.
  - `btnr`: Move paddle down.
- **Serve (`btn0`):** Start the ball in motion at the center of the screen.
- **Score Display:** Automatically updates whenever a player scores.

## Notes

- The vertical position of paddles is bounded so they remain visible on the screen.
- The seven-segment display shows hexadecimal digits for the score, incrementing from 0 through F as points are scored.
- Speeds and positions (like how fast paddles move or the ball’s trajectory) can be tuned by adjusting constants in the VHDL code.
