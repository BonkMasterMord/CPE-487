LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pong IS
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        btnl : IN STD_LOGIC;
        btnr : IN STD_LOGIC;
        btn0 : IN STD_LOGIC;
        SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- anodes of four 7-seg displays
        SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        KB_row : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        KB_col : IN STD_LOGIC_VECTOR (3 DOWNTO 0)
    
    ); 
END pong;

ARCHITECTURE Behavioral OF pong IS
    SIGNAL pxl_clk : STD_LOGIC := '0'; -- 25 MHz clock to VGA sync module
    -- internal signals to connect modules
    SIGNAL S_red, S_green, S_blue : STD_LOGIC; --_VECTOR (3 DOWNTO 0);
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL batpos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL batpos2 : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL count : STD_LOGIC_VECTOR (20 DOWNTO 0);
    SIGNAL display : std_logic_vector (31 DOWNTO 0); -- value to be displayed
    SIGNAL led_mpx : STD_LOGIC_VECTOR (2 DOWNTO 0); -- 7-seg multiplexing clock
    SIGNAL row_scan : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
    SIGNAL col_scan : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL paddle_up, paddle_down : STD_LOGIC := '0';
    SIGNAL scan_state : INTEGER RANGE 0 TO 3 := 0;
    SIGNAL scan_delay : INTEGER := 0;
    signal scoreT : std_logic_vector(15 downto 0);
    signal scoreT2 : std_logic_vector(15 downto 0);
    signal sendT: std_logic_vector(31 downto 0);
    COMPONENT bat_n_ball IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            bat_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(300, 11);
            bat_y2 : IN STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
            serve : IN STD_LOGIC;
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC;
            score1_inc : OUT STD_LOGIC_vector(15 downto 0);
            score2_inc : OUT STD_LOGIC_vector(15 downto 0)
           
            
        );
    END COMPONENT;
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clk_wiz_0 is
        PORT (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
    END COMPONENT;
    COMPONENT leddec16 IS
        PORT (
            dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
        );
    END COMPONENT; 
    
BEGIN

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
    
    pos : PROCESS (clk_in)
    BEGIN
       IF rising_edge(clk_in) THEN
          count <= count + 1;
          IF (paddle_up = '1' AND count = 0 AND batpos2 > 70) THEN
             batpos2 <= batpos2 - 10;
          ELSIF (paddle_down = '1' AND count = 0 AND batpos2 < 550) THEN
             batpos2 <= batpos2 + 10;
          END IF;
       END IF;
    END PROCESS;
    
    pos2 : PROCESS (clk_in)
    BEGIN
       if rising_edge(clk_in) then
            count <= count + 1;
            IF (btnl = '1' and count = 0 and batpos > 70) THEN
                batpos <= batpos - 10;
            ELSIF (btnr = '1' and count = 0 and batpos < 550) THEN
                batpos <= batpos + 10;
            END IF;
        end if;
    END PROCESS;
    
   
    led_mpx <= count(19 DOWNTO 17); -- 7-seg multiplexing clock    
   sendT <= scoreT(15 downto 0) & scoreT2(15 downto 0);
   
   
    add_bb : bat_n_ball
    PORT MAP(--instantiate bat and ball component
        v_sync => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        bat_y => batpos,
        bat_y2 => batpos2, 
        serve => btn0,
        red => S_red, 
        green => S_green, 
        blue => S_blue,
        score1_inc => scoreT,
        score2_inc => scoreT2
    );
   
    
    vga_driver : vga_sync
    PORT MAP(--instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in => S_red & "000", 
        green_in => S_green & "000", 
        blue_in => S_blue & "000", 
        red_out => VGA_red, 
        green_out => VGA_green, 
        blue_out => VGA_blue, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync => VGA_hsync, 
        vsync => S_vsync
    );
    VGA_vsync <= S_vsync; --connect output vsync
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    led1 : leddec16
    PORT MAP(
      dig => led_mpx, data => sendT,
      anode => SEG7_anode, seg => SEG7_seg
    );
END Behavioral;
