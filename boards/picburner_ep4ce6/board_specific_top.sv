//============================================================================
// Board top level for the Picburner EP4CE6E22C8N minimal board
// (Altera Cyclone IV E, 144-pin LQFP, 50 MHz oscillator).
//
// Pin numbers are in board_specific.qsf. Pins on the headers are in README.md.
//
// BASE BOARD (no wiring needed):
//   CLK         - 50 MHz oscillator
//   RESET       - button K3, active low
//   KEY_SW[3:0] - buttons K1, K2, K4, K5, active low
//   LED[4:0]    - LEDs DL1..DL5, active LOW (logic 0 lights the LED)
//   UART        - CH340C USB-UART bridge (USB port P5, no wiring needed)
//
// WIRING NEEDED (see the detailed tables below and README.md):
//   TM1638 LED & key module          -> header P2 (+3V3, GND)
//   INMP441 I2S microphone           -> header P4 (+3V3, GND from P3)
//   PCM5102 I2S audio DAC            -> header P4 (+3V3, GND from P3)
//   VGA (4-bit R/G/B + sync)         -> header P2 + external resistor DAC (user)
//   General-purpose I/O              -> header P3 (GPIO[23:0])
//
// Define USE_* flags in lab_specific_board_config.svh of each lab
// (INSTANTIATE_TM1638_BOARD_CONTROLLER_MODULE, INSTANTIATE_MICROPHONE_INTERFACE_MODULE,
// INSTANTIATE_SOUND_OUTPUT_INTERFACE_MODULE, INSTANTIATE_GRAPHICS_INTERFACE_MODULE).
//============================================================================

`include "config.svh"
`include "lab_specific_board_config.svh"

//----------------------------------------------------------------------------
//  HEADER P2 (2 x 12): the TM1638 and VGA pins.
//
//  Header pin   Schematic net   FPGA pin   Signal            Note
//  ----------   -------------   --------   ---------------   -------------------
//   1           IO105           105        VGA_HSYNC         VGA horizontal sync
//   2           IO106           106        VGA_G[2]          VGA green bit 2
//   3           IO103           103        VGA_VSYNC         VGA vertical sync
//   4           IO104           104        VGA_G[3]          VGA green bit 3
//   5           IO100           100        VGA_R[0]          VGA red bit 0 (LSB)
//   6           IO101           101        VGA_B[0]          VGA blue bit 0 (LSB)
//   7           IO98            98         VGA_R[1]          VGA red bit 1
//   8           IO99            99         VGA_B[1]          VGA blue bit 1
//   9           IO85            85         VGA_R[2]          VGA red bit 2
//  10           IO86            86         VGA_B[2]          VGA blue bit 2
//  11           IO77            77         VGA_R[3]          VGA red bit 3 (MSB)
//  12           IO83            83         VGA_B[3]          VGA blue bit 3 (MSB)
//  13           IO76            76         VGA_G[0]          VGA green bit 0 (LSB)
//  14           IO28            28         TM_STB            TM1638 STB (strobe)
//  15           IO30            30         TM_CLK            TM1638 CLK (clock)
//  16           IO31            31         -- free --
//  17           IO32            32         VGA_G[1]          VGA green bit 1
//  18           IO33            33         -- free --
//  19           IO34            34         TM_DIO            TM1638 DIO (data, bidirectional)
//  20           -               -          not connected
//  21, 23       GND                        GND
//  22, 24       GND                        GND
//
//  TM1638 module wiring (5 wires):
//    VCC  -> 3V3 (P3 pin 37 or 38)
//    GND  -> GND (P2 pin 21 or 23, or P3 pin 43..46)
//    STB  -> P2 pin 14 (IO28)
//    CLK  -> P2 pin 15 (IO30)
//    DIO  -> P2 pin 19 (IO34)
//
//  VGA: the 14 signals above go to an external resistor DAC.
//       The DAC is NOT on the board. Build it yourself (see README.md).
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//  HEADER P4 (2 x 23): microphone and audio DAC.
//
//  Header pin   Schematic net   FPGA pin   Signal            Module
//  ----------   -------------   --------   ---------------   -------------------
//   9           IO39            39         MIC_LR            INMP441 pin L/R
//  10           IO38            38         DAC_BCK           PCM5102 pin BCK
//  11           IO43            43         MIC_WS            INMP441 pin WS
//  12           IO42            42         DAC_LRCK          PCM5102 pin LCK
//  13           IO46            46         MIC_SCK           INMP441 pin SCK
//  14           IO44            44         DAC_DIN           PCM5102 pin DIN
//  15           IO50            50         MIC_SD            INMP441 pin SD
//  33           NC                         not connected (X on schematic)
//  Others       -- free --
//
//  INMP441 wiring:
//    VDD  -> 3V3 (P3 pin 37 or 38)
//    GND  -> GND (P3 pin 45 or 46)
//    L/R  -> P4 pin 9  (IO39)  - the FPGA drives 0 = left channel
//    WS   -> P4 pin 11 (IO43)
//    SCK  -> P4 pin 13 (IO46)
//    SD   -> P4 pin 15 (IO50)
//
//  PCM5102 wiring:
//    VIN  -> 3V3 (P3 pin 37 or 38)   (use 3.3 V: the module must be 3.3 V tolerant)
//    GND  -> GND (P3 pin 45 or 46)
//    BCK  -> P4 pin 10 (IO38)
//    LCK  -> P4 pin 12 (IO42)   (LRCK)
//    DIN  -> P4 pin 14 (IO44)
//    SCK  -> GND                (the chip then uses BCK as its system clock)
//    FLT  -> GND                (normal latency filter)
//    DEMP -> GND                (de-emphasis off)
//    XSMT -> 3V3                (un-mute)
//    OUT L/R -> headphones or amplifier (user's job)
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//  HEADER P3 (2 x 23): general-purpose I/O and power.
//
//  Left (odd) pins                         Right (even) pins
//   9  IO143 -> GPIO[22]                    10  IO144 -> GPIO[23]
//  11  IO141 -> (not used)                  12  IO142 -> GPIO[21]
//  13  IO137 -> GPIO[18]                    14  IO138 -> GPIO[19]
//  15  IO135 -> GPIO[16]                    16  IO136 -> GPIO[17]
//  17  IO132 -> GPIO[14]                    18  IO133 -> GPIO[15]
//  19  IO128 -> GPIO[12]                    20  IO129 -> GPIO[13]
//  21  IO126 -> GPIO[10]                    22  IO127 -> GPIO[11]
//  23  IO124 -> GPIO[8]                     24  IO125 -> GPIO[9]
//  25  IO120 -> GPIO[6]                     26  IO121 -> GPIO[7]
//  27  IO115 -> GPIO[4]                     28  IO119 -> GPIO[5]
//  29  IO112 -> GPIO[2]                     30  IO113 -> GPIO[3]
//  31  IO110 -> GPIO[0]                     32  IO111 -> GPIO[1]
//  33  5VCC (5 V)                           34  5VCC (5 V)
//  35  -- (joined to 33)                    36  -- (joined to 34)
//  37  3V3                                  38  3V3
//  39  -- (joined to 37)                    40  -- (joined to 38)
//  41  2V5                                  42  2V5
//  43  GND                                  44  GND
//  45  GND                                  46  GND
//
//  Use the 3V3 pins (37/38) for the TM1638, the INMP441 and the PCM5102.
//  Use the GND pins (43..46) for the grounds.
//  The 5 V pins (33/34) are NOT used by the labs. Do not connect the 3.3 V
//  FPGA IO pins to 5 V signals without a level shifter.
//----------------------------------------------------------------------------

module board_specific_top
# (
    parameter clk_mhz       = 50,
              pixel_mhz     = 25,

              w_key         = 4,   // K1, K2, K4, K5
              w_sw          = 4,   // the same buttons as switches
              w_led         = 5,   // DL1..DL5
              w_digit       = 0,   // no seven-segment display on the board

              w_gpio        = 24,  // header P3, GPIO[23:0]

              screen_width  = 640,
              screen_height = 480,

              w_red         = 4,
              w_green       = 4,
              w_blue        = 4,

              w_x           = $clog2 ( screen_width  ),
              w_y           = $clog2 ( screen_height )
)
(
    input                       CLK,
    input                       RESET,        // K3, active low

    input  [w_key      - 1:0]   KEY_SW,       // K1, K2, K4, K5, active low
    output [w_led      - 1:0]   LED,          // DL1..DL5, active low

    output                      UART_TXD,
    input                       UART_RXD,

    output                      VGA_HSYNC,
    output                      VGA_VSYNC,
    output [w_red      - 1:0]   VGA_R,
    output [w_green    - 1:0]   VGA_G,
    output [w_blue     - 1:0]   VGA_B,

    output                      TM_STB,
    output                      TM_CLK,
    inout                       TM_DIO,

    output                      MIC_LR,
    output                      MIC_WS,
    output                      MIC_SCK,
    input                       MIC_SD,

    output                      DAC_BCK,
    output                      DAC_LRCK,
    output                      DAC_DIN,

    inout  [w_gpio     - 1:0]   GPIO
);

    //------------------------------------------------------------------------

    localparam w_lab_sw = w_sw;

    wire clk = CLK;
    wire rst = ~ RESET;

    //------------------------------------------------------------------------

    localparam w_tm_key   = 8,
               w_tm_led   = 8,
               w_tm_digit = 8;

    //------------------------------------------------------------------------

    // The TM1638 and the on-board signals share the lab inputs and outputs.
    // Inputs are ORed, outputs are shared (the TM1638 LEDs and the board LEDs
    // show the same lab_led bits).

    localparam w_lab_key   = w_tm_key   > w_key   ? w_tm_key   : w_key   ,
               w_lab_led   = w_tm_led   > w_led   ? w_tm_led   : w_led   ,
               w_lab_digit = w_tm_digit > w_digit ? w_tm_digit : w_digit ;

    //------------------------------------------------------------------------

    wire  [w_tm_key    - 1:0] tm_key;
    wire  [w_tm_led    - 1:0] tm_led;
    wire  [w_tm_digit  - 1:0] tm_digit;

    logic [w_lab_key   - 1:0] lab_key;
    wire  [w_lab_led   - 1:0] lab_led;
    wire  [w_lab_digit - 1:0] lab_digit;

    // Seven-segment signals (only for the TM1638 display)

    wire [7:0] abcdefgh;

    //------------------------------------------------------------------------

    always_comb
    begin
        lab_key = '0;

        lab_key [w_key    - 1:0] |= ~ KEY_SW;
        lab_key [w_tm_key - 1:0] |= tm_key;
    end

    // The LEDs on this board are active low.
    assign LED    = ~ lab_led [w_led    - 1:0];
    assign tm_led =    lab_led [w_tm_led - 1:0];

    assign tm_digit = lab_digit [w_tm_digit - 1:0];

    //------------------------------------------------------------------------

    wire slow_clk;

    slow_clk_gen # (.fast_clk_mhz (clk_mhz), .slow_clk_hz (1))
    i_slow_clk_gen (.slow_clk (slow_clk), .*);

    //------------------------------------------------------------------------

    wire [         23:0] mic;
    wire [         15:0] sound;

    wire [w_red   - 1:0] red;
    wire [w_green - 1:0] green;
    wire [w_blue  - 1:0] blue;

    wire [w_x     - 1:0] x;
    wire [w_y     - 1:0] y;

    lab_top
    # (
        .clk_mhz       ( clk_mhz       ),
        .w_key         ( w_lab_key     ),
        .w_sw          ( w_lab_sw      ),
        .w_led         ( w_lab_led     ),
        .w_digit       ( w_lab_digit   ),
        .w_gpio        ( w_gpio        ),

        .screen_width  ( screen_width  ),
        .screen_height ( screen_height ),

        .w_red         ( w_red         ),
        .w_green       ( w_green       ),
        .w_blue        ( w_blue        )
    )
    i_lab_top
    (
        .clk           ( clk           ),
        .slow_clk      ( slow_clk      ),
        .rst           ( rst           ),

        .key           ( lab_key       ),
        .sw            ( ~ KEY_SW     ),

        .led           ( lab_led       ),

        .abcdefgh      ( abcdefgh      ),
        .digit         ( lab_digit     ),

        .x             ( x             ),
        .y             ( y             ),

        .red           ( red           ),
        .green         ( green         ),
        .blue          ( blue          ),

        .uart_rx       ( UART_RXD      ),
        .uart_tx       ( UART_TXD      ),

        .mic           ( mic           ),
        .sound         ( sound         ),

        .gpio          ( GPIO          )
    );

    //------------------------------------------------------------------------

    `ifdef INSTANTIATE_GRAPHICS_INTERFACE_MODULE

        wire vga_vs, vga_hs;
        wire display_on;

        wire [9:0] x10; assign x = x10;
        wire [9:0] y10; assign y = y10;

        vga
        # (
            .CLK_MHZ     ( clk_mhz    ),
            .PIXEL_MHZ   ( pixel_mhz  )
        )
        i_vga
        (
            .clk         ( clk        ),
            .rst         ( rst        ),
            .hsync       ( vga_hs     ),
            .vsync       ( vga_vs     ),
            .display_on  ( display_on ),
            .hpos        ( x10        ),
            .vpos        ( y10        ),
            .pixel_clk   (            )
        );

        // Registers remove glitches of the combinational logic.
        // The VGA outputs are 3.3 V and need an external resistor DAC.

        logic [w_red - 1:0] reg_vga_r, reg_vga_g, reg_vga_b;
        logic               reg_vga_vs, reg_vga_hs;

        always_ff @ (posedge clk or posedge rst)
        begin
            if (rst)
            begin
                reg_vga_r  <= '0;
                reg_vga_g  <= '0;
                reg_vga_b  <= '0;
                reg_vga_vs <= '0;
                reg_vga_hs <= '0;
            end
            else
            begin
                reg_vga_r  <= display_on ? red   : '0;
                reg_vga_g  <= display_on ? green : '0;
                reg_vga_b  <= display_on ? blue  : '0;
                reg_vga_vs <= vga_vs;
                reg_vga_hs <= vga_hs;
            end
        end

        assign VGA_HSYNC = reg_vga_hs;
        assign VGA_VSYNC = reg_vga_vs;
        assign VGA_R     = reg_vga_r;
        assign VGA_G     = reg_vga_g;
        assign VGA_B     = reg_vga_b;

    `else

        assign VGA_HSYNC = 1'b1;
        assign VGA_VSYNC = 1'b1;
        assign VGA_R     = '0;
        assign VGA_G     = '0;
        assign VGA_B     = '0;

        assign x = '0;
        assign y = '0;

    `endif

    //------------------------------------------------------------------------

    wire [$left (abcdefgh):0] hgfedcba;

    generate
        genvar i;

        for (i = 0; i < $bits (abcdefgh); i ++)
        begin : abc
            assign hgfedcba [i] = abcdefgh [$left (abcdefgh) - i];
        end
    endgenerate

    //------------------------------------------------------------------------

    `ifdef INSTANTIATE_TM1638_BOARD_CONTROLLER_MODULE

        tm1638_board_controller
        # (
            .clk_mhz   ( clk_mhz     )
        )
        i_ledkey
        (
            .clk       ( clk         ),
            .rst       ( rst         ),  // Don't reset tm1638_board_controller by its tm_key
            .hgfedcba  ( hgfedcba    ),
            .digit     ( tm_digit    ),
            .ledr      ( tm_led      ),
            .keys      ( tm_key      ),
            .sio_stb   ( TM_STB      ),  // P2 pin 14, IO28
            .sio_clk   ( TM_CLK      ),  // P2 pin 15, IO30
            .sio_data  ( TM_DIO      )   // P2 pin 19, IO34
        );

    `else

        assign TM_STB = 1'b1;
        assign TM_CLK = 1'b1;
        assign TM_DIO = 1'bz;

    `endif

    //------------------------------------------------------------------------

    `ifdef INSTANTIATE_MICROPHONE_INTERFACE_MODULE

        // INMP441 I2S microphone. Pins: see the P4 table above.

        inmp441_mic_i2s_receiver
        # (
            .clk_mhz ( clk_mhz    )
        )
        i_microphone
        (
            .clk     ( clk        ),
            .rst     ( rst        ),
            .lr      ( MIC_LR     ),  // P4 pin  9, IO39 - driven 0 (left channel)
            .ws      ( MIC_WS     ),  // P4 pin 11, IO43
            .sck     ( MIC_SCK    ),  // P4 pin 13, IO46
            .sd      ( MIC_SD     ),  // P4 pin 15, IO50
            .value   ( mic        )
        );

    `else

        assign MIC_LR  = 1'b0;
        assign MIC_WS  = 1'b0;
        assign MIC_SCK = 1'b0;

    `endif

    //------------------------------------------------------------------------

    `ifdef INSTANTIATE_SOUND_OUTPUT_INTERFACE_MODULE

        // PCM5102 I2S audio DAC. The DAC's SCK pin is tied to GND, so the
        // MCLK output of i2s_audio_out is not used.

        wire unused_mclk;

        i2s_audio_out
        # (
            .clk_mhz ( clk_mhz    )
        )
        inst_audio_out
        (
            .clk     ( clk        ),
            .reset   ( rst        ),
            .data_in ( sound      ),
            .mclk    ( unused_mclk),  // not connected to the PCM5102
            .bclk    ( DAC_BCK    ),  // P4 pin 10, IO38
            .lrclk   ( DAC_LRCK   ),  // P4 pin 12, IO42
            .sdata   ( DAC_DIN    )   // P4 pin 14, IO44
        );

    `else

        assign DAC_BCK  = 1'b0;
        assign DAC_LRCK = 1'b0;
        assign DAC_DIN  = 1'b0;

    `endif

endmodule
