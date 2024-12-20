LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.all;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        bat_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat y position
        bat_y2 : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat2 y position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        score1_inc : OUT STD_LOGIC_vector(15 downto 0);
        score2_inc : OUT STD_LOGIC_vector(15 downto 0)
       
     
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
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
    -- bat vertical position
    CONSTANT bat_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100, 11);
    Constant bat_x2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(700, 11);
    -- current ball motion - initialized to (+ ball_speed) pixels/frame in both X and Y directions
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    signal score1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal score2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal trigger : std_logic := '0';
    signal trigger2 : std_logic := '0';
    signal offscreen_trigger : std_logic := '0';
    
BEGIN
    red <= NOT (bat_on OR bat_on2); -- color setup for red ball and cyan bat on white background
    green <= NOT ball_on;
    blue <= NOT ball_on;

  --ECP entity Component Portmap;
    
    -- process to draw round ball
    -- set ball_on if current pixel address is covered by ball position
    balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= ball_x THEN -- vx = |ball_x - pixel_col|
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN -- vy = |ball_y - pixel_row|
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
    -- process to draw bat
    -- set bat_on if current pixel address is covered by bat position
    batdraw : PROCESS (bat_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_x - bat_w) OR (bat_x <= bat_w)) AND
         pixel_col <= bat_x + bat_w AND
             pixel_row >= bat_y - bat_h AND
             pixel_row <= bat_y + bat_h THEN
                bat_on <= '1';
        ELSE
            bat_on <= '0';
        END IF;
    END PROCESS;
    
    batdraw2 : PROCESS (bat_y2, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_x2 - bat_w) OR (bat_x2 <= bat_w)) AND
         pixel_col <= bat_x2 + bat_w AND
             pixel_row >= bat_y2 - bat_h AND
             pixel_row <= bat_y2 + bat_h THEN
                bat_on2 <= '1';
        ELSE
            bat_on2 <= '0';
        END IF;
    END PROCESS;
    -- process to move ball once every frame (i.e., once every vsync pulse)
    mball : PROCESS
           VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            game_on <= '1';
            ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
        ELSIF ball_y <= bsize THEN -- bounce off top wall
            ball_y_motion <= ball_speed; -- set vspeed to (+ ball_speed) pixels
        ELSIF ball_y + bsize >= 600 THEN -- if ball meets bottom wall
            ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
        
        END IF;
        
        -- account for the offscreen trigger
        if bsize <= ball_x AND 800 >= ball_x + bsize then
            offscreen_trigger <= '0';
        end if;
        
        -- allow for bounce off left or right of screen
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
        END IF;
        -- allow for bounce off bat
        IF game_on = '1' AND (ball_x + bsize/2) >= (bat_x - bat_w) AND
         (ball_x - bsize/2) <= (bat_x + bat_w) AND
             (ball_y + bsize/2) >= (bat_y - bat_h) AND
             (ball_y - bsize/2) <= (bat_y + bat_h) THEN
                ball_x_motion <= ball_speed + 1; -- set vspeed to (ball_speed) pixels 
                   trigger <= '1';
           
                END IF;
                IF trigger = '1' then
                       score1 <= score1 + 1;
                       trigger <= NOT trigger;
        END IF;

        
          IF game_on = '1' AND (ball_x + bsize/2) >= (bat_x2 - bat_w) AND
         (ball_x - bsize/2) <= (bat_x2 + bat_w) AND
             (ball_y + bsize/2) >= (bat_y2 - bat_h) AND
             (ball_y - bsize/2) <= (bat_y2 + bat_h) THEN
                ball_x_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels 
                   trigger2 <= '1';
        END IF;
                IF trigger2 = '1' then
                       score2 <= score2 + 1;
                       trigger2 <= NOT trigger2;
        END IF;
 
        -- compute next ball vertical position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_y is close to zero and ball_y_motion is negative
        temp := ('0' & ball_y) + (ball_y_motion(10) & ball_y_motion);
        IF game_on = '0' THEN
            ball_y <= CONV_STD_LOGIC_VECTOR(440, 11);
        ELSIF temp(11) = '1' THEN
            ball_y <= (OTHERS => '0');
        ELSE ball_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next ball horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_x is close to zero and ball_x_motion is negative
        temp := ('0' & ball_x) + (ball_x_motion(10) & ball_x_motion);
        IF temp(11) = '1' THEN
            ball_x <= (OTHERS => '0');
        ELSE ball_x <= temp(10 DOWNTO 0);
        END IF;
    END PROCESS;
    score1_inc <= score1(15 downto 0);
    score2_inc <= score2(15 downto 0);
END Behavioral;
