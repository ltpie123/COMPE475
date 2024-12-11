# Clock definition (100 MHz system clock)
create_clock -period 10.000 -name sys_clk [get_ports clk]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Reset button (Center button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# PWM Audio Output on Pmod JA[0]
set_property PACKAGE_PIN J1 [get_ports pwm_audio_out]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_audio_out]
# Enhanced PWM timing constraints
set_output_delay -clock [get_clocks sys_clk] -max 2.0 [get_ports pwm_audio_out]
set_output_delay -clock [get_clocks sys_clk] -min 0.5 [get_ports pwm_audio_out]
# Set maximum skew for PWM output
set_max_delay -from [all_registers] -to [get_ports pwm_audio_out] 4.0
# Relax timing for audio path
set_multicycle_path -setup 2 -to [get_ports pwm_audio_out]
set_multicycle_path -hold 1 -to [get_ports pwm_audio_out]

# MIDI Input on Pmod JA[1]
set_property PACKAGE_PIN L2 [get_ports midi_rx]
set_property IOSTANDARD LVCMOS33 [get_ports midi_rx]

# MIDI interface timing (31.25kHz * 256 = 8MHz for oversampling)
create_clock -period 125.000 -name midi_clk [get_ports midi_rx]

# Clock Domain Crossing
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks midi_clk]

# Set false path for reset
set_false_path -from [get_ports reset]

# Power configuration
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]