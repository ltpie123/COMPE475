## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset button (Center button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## MIDI RX (using UART RX pin)
set_property PACKAGE_PIN B18 [get_ports midi_rx]
set_property IOSTANDARD LVCMOS33 [get_ports midi_rx]

## Switches layout (16 total):
## [15:14] - wav_sel[1:0]       (2 switches)
## [13:10] - sustain_level[3:0] (4 switches)
## [9:7]   - attack_time[2:0]   (3 switches)
## [6:4]   - decay_time[2:0]    (3 switches)
## [3:1]   - release_time[2:0]  (3 switches)

## Waveform selector (SW15, SW14)
set_property PACKAGE_PIN R2 [get_ports {wav_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {wav_sel[1]}]
set_property PACKAGE_PIN T1 [get_ports {wav_sel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {wav_sel[0]}]

## Sustain level (SW13-SW10)
set_property PACKAGE_PIN U1 [get_ports {sustain_level[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sustain_level[3]}]
set_property PACKAGE_PIN W2 [get_ports {sustain_level[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sustain_level[2]}]
set_property PACKAGE_PIN R3 [get_ports {sustain_level[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sustain_level[1]}]
set_property PACKAGE_PIN T2 [get_ports {sustain_level[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sustain_level[0]}]

## Attack time (SW9-SW7)
set_property PACKAGE_PIN T3 [get_ports {attack_time[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {attack_time[2]}]
set_property PACKAGE_PIN V2 [get_ports {attack_time[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {attack_time[1]}]
set_property PACKAGE_PIN W13 [get_ports {attack_time[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {attack_time[0]}]

## Decay time (SW6-SW4)
set_property PACKAGE_PIN W14 [get_ports {decay_time[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {decay_time[2]}]
set_property PACKAGE_PIN V15 [get_ports {decay_time[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {decay_time[1]}]
set_property PACKAGE_PIN W15 [get_ports {decay_time[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {decay_time[0]}]

## Release time (SW3-SW1)
set_property PACKAGE_PIN W17 [get_ports {release_time[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {release_time[2]}]
set_property PACKAGE_PIN W16 [get_ports {release_time[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {release_time[1]}]
set_property PACKAGE_PIN V16 [get_ports {release_time[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {release_time[0]}]

## PWM Audio output (using JA PMOD header)
set_property PACKAGE_PIN J1 [get_ports pwm_audio_out]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_audio_out]

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]