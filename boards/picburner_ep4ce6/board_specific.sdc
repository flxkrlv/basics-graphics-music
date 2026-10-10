create_clock -period "50.0 MHz" [get_ports CLK]

derive_clock_uncertainty

# Buttons, LEDs, UART, TM1638, microphone, DAC and VGA are slow or asynchronous
# to the design clock. They are not timed against the 50 MHz clock.

set_false_path -from RESET                                  -to [all_clocks]
set_false_path -from [get_ports {KEY_SW[*]}]                -to [all_clocks]
set_false_path -from UART_RXD                               -to [all_clocks]
set_false_path -from [get_ports {TM_DIO}]                   -to [all_clocks]
set_false_path -from [get_ports {MIC_SD}]                   -to [all_clocks]
set_false_path -from [get_ports {GPIO[*]}]                  -to [all_clocks]

set_false_path -from * -to [get_ports {LED[*]}]
set_false_path -from * -to [get_ports {UART_TXD}]
set_false_path -from * -to [get_ports {TM_STB TM_CLK TM_DIO}]
set_false_path -from * -to [get_ports {MIC_LR MIC_WS MIC_SCK}]
set_false_path -from * -to [get_ports {DAC_BCK DAC_LRCK DAC_DIN}]
set_false_path -from * -to [get_ports {VGA_*}]
set_false_path -from * -to [get_ports {GPIO[*]}]
