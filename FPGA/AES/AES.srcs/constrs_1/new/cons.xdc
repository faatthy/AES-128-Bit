# Clock Constraints (100 MHz)
create_clock -period 10.000 -name clk [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property PACKAGE_PIN AF18 [get_ports clk]

# Reset Pin (connected to push button SW4 on ZCU106)
set_property PACKAGE_PIN AG13 [get_ports rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]

# Enable Pin (PMODA pin)
set_property PACKAGE_PIN AG14 [get_ports enable]
set_property IOSTANDARD LVCMOS18 [get_ports enable]

# Data Input (8-bit) - Using PMODB
set_property PACKAGE_PIN AF15 [get_ports {data_in[0]}]
set_property PACKAGE_PIN AF16 [get_ports {data_in[1]}]
set_property PACKAGE_PIN AG15 [get_ports {data_in[2]}]
set_property PACKAGE_PIN AD17 [get_ports {data_in[3]}]
set_property PACKAGE_PIN AH14 [get_ports {data_in[4]}]
set_property PACKAGE_PIN AD16 [get_ports {data_in[5]}]
set_property PACKAGE_PIN AJ14 [get_ports {data_in[6]}]
set_property PACKAGE_PIN AJ15 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[*]}]

# Data Output (8-bit) - Using PMODC
set_property PACKAGE_PIN AK14 [get_ports {data_out[0]}]
set_property PACKAGE_PIN AK15 [get_ports {data_out[1]}]
set_property PACKAGE_PIN AA14 [get_ports {data_out[2]}]
set_property PACKAGE_PIN AB14 [get_ports {data_out[3]}]
set_property PACKAGE_PIN AL15 [get_ports {data_out[4]}]
set_property PACKAGE_PIN AL16 [get_ports {data_out[5]}]
set_property PACKAGE_PIN AM14 [get_ports {data_out[6]}]
set_property PACKAGE_PIN AM15 [get_ports {data_out[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[*]}]

# Valid Signal (using LED0 for visibility)
set_property PACKAGE_PIN AP8 [get_ports valid]
set_property IOSTANDARD LVCMOS18 [get_ports valid]

# Input Timing Constraints
set_input_delay -clock [get_clocks clk] -max 2.000 [get_ports {data_in[*]}]
set_input_delay -clock [get_clocks clk] -min 1.000 [get_ports {data_in[*]}]
set_input_delay -clock [get_clocks clk] -max 2.000 [get_ports enable]
set_input_delay -clock [get_clocks clk] -min 1.000 [get_ports enable]

# Output Timing Constraints
set_output_delay -clock [get_clocks clk] -max 2.000 [get_ports {data_out[*]}]
set_output_delay -clock [get_clocks clk] -min 1.000 [get_ports {data_out[*]}]
set_output_delay -clock [get_clocks clk] -max 2.000 [get_ports valid]
set_output_delay -clock [get_clocks clk] -min 1.000 [get_ports valid]

# Asynchronous Reset False Path
set_false_path -from [get_ports rst_n]
