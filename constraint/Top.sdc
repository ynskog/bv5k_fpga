################################################################################
#  SDC WRITER VERSION "3.1";
#  DESIGN "Top";
#  Timing constraints scenario: "Primary";
#  DATE "Sun Nov 11 16:10:46 2018";
#  VENDOR "Actel";
#  PROGRAM "Microsemi Libero Software Release v11.8 SP3";
#  VERSION "11.8.3.6"  Copyright (C) 1989-2018 Actel Corp. 
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name { main } -period 27.700 -waveform { 0.000 13.850  }  { u_mainPll/Core:GLA  } 

create_clock  -name { clk25 } -period 40.000 -waveform { 0.000 20.000  }  { xosc  } 

create_clock  -name { com_sck } -period 31.125 -waveform { 0.000 15.563  }  { INBUF_LVDS_1/U0/U1:Y  } 



########  Generated Clock Constraints  ########



########  Clock Source Latency Constraints #########



########  Input Delay Constraints  ########

set_input_delay 0.000 -clock { com_sck }  [get_ports { mosi_n mosi_p }] 
set_max_delay 10.000 -from [get_ports { mosi_n mosi_p }]  -to [get_clocks {com_sck}] 
set_min_delay -0.000 -from [get_ports { mosi_n mosi_p }]  -to [get_clocks {com_sck}] 



########  Output Delay Constraints  ########

set_output_delay 0.000 -clock { com_sck }  [get_ports { miso_n miso_p }] 
set_max_delay 25.000 -from [get_clocks {com_sck}]  -to [get_ports { miso_n miso_p }] 
set_min_delay 0.000 -from [get_clocks {com_sck}]  -to [get_ports { miso_n miso_p }] 



########   Delay Constraints  ########



########   Delay Constraints  ########



########   Multicycle Constraints  ########



########   False Path Constraints  ########



########   Output load Constraints  ########



########  Disable Timing Constraints #########



########  Clock Uncertainty Constraints #########

set_clock_uncertainty 0.8 -from { main clk25 com_sck } -to { main clk25 com_sck }



