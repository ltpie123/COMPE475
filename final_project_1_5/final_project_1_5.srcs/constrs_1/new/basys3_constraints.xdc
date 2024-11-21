## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset button (Center button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## MIDI note input (using switches for now)
set_property PACKAGE_PIN V17 [get_ports {midi_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {midi_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {midi_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {midi_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[3]}]
set_property PACKAGE_PIN W15 [get_ports {midi_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {midi_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {midi_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {midi_in[6]}]

## Waveform selector (using right two switches)
set_property PACKAGE_PIN W13 [get_ports {wav_sel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {wav_sel[0]}]
set_property PACKAGE_PIN V2 [get_ports {wav_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {wav_sel[1]}]

## PWM Audio output (using JA PMOD header)
set_property PACKAGE_PIN J1 [get_ports pwm_audio_out]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_audio_out]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
