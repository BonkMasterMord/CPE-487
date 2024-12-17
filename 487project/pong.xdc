 # Clock input (10 MHz example)
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {clk_in}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk_in}]

# VGA signals
set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports {VGA_hsync}]
set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports {VGA_vsync}]

# VGA Blue
set_property -dict { PACKAGE_PIN B7 IOSTANDARD LVCMOS33 } [get_ports {VGA_blue[0]}]
set_property -dict { PACKAGE_PIN C7 IOSTANDARD LVCMOS33 } [get_ports {VGA_blue[1]}]
set_property -dict { PACKAGE_PIN D7 IOSTANDARD LVCMOS33 } [get_ports {VGA_blue[2]}]
set_property -dict { PACKAGE_PIN D8 IOSTANDARD LVCMOS33 } [get_ports {VGA_blue[3]}]

# VGA Red
set_property -dict { PACKAGE_PIN A3 IOSTANDARD LVCMOS33 } [get_ports {VGA_red[0]}]
set_property -dict { PACKAGE_PIN B4 IOSTANDARD LVCMOS33 } [get_ports {VGA_red[1]}]
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports {VGA_red[2]}]
set_property -dict { PACKAGE_PIN A4 IOSTANDARD LVCMOS33 } [get_ports {VGA_red[3]}]

# VGA Green
set_property -dict { PACKAGE_PIN C6 IOSTANDARD LVCMOS33 } [get_ports {VGA_green[0]}]
set_property -dict { PACKAGE_PIN A5 IOSTANDARD LVCMOS33 } [get_ports {VGA_green[1]}]
set_property -dict { PACKAGE_PIN B6 IOSTANDARD LVCMOS33 } [get_ports {VGA_green[2]}]
set_property -dict { PACKAGE_PIN A6 IOSTANDARD LVCMOS33 } [get_ports {VGA_green[3]}]

# Buttons
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {btn0}]
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {btnl}]
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports {btnr}]

# 7-Segment Display Segments
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[0]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[1]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[2]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[3]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[4]}]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[5]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[6]}]

# 7-Segment Display Anodes
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[7]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[6]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[5]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[4]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[3]}]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[1]}]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[0]}]

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
