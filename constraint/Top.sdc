################################################################################
#  SDC WRITER VERSION "3.1";
#  DESIGN "Top";
#  Timing constraints scenario: "Primary";
#  DATE "Sun Nov 11 11:09:38 2018";
#  VENDOR "Actel";
#  PROGRAM "Microsemi Libero Software Release v11.8 SP3";
#  VERSION "11.8.3.6"  Copyright (C) 1989-2018 Actel Corp. 
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name { main } -period 27.700 { u_mainPll/Core:GLA  } 

create_clock  -name { clk25 } -period 40.000 { xosc  } 

create_clock  -name { com_sck } -period 31.125 { INBUF_LVDS_1/U0/U1:Y  } 



########  Generated Clock Constraints  ########



########  Clock Source Latency Constraints #########



########  Input Delay Constraints  ########



########  Output Delay Constraints  ########



########   Delay Constraints  ########



########   Delay Constraints  ########



########   Multicycle Constraints  ########



########   False Path Constraints  ########



########   Output load Constraints  ########



########  Disable Timing Constraints #########



########  Clock Uncertainty Constraints #########

set_clock_uncertainty 0.8 -from { clk25 } -to { main }

set_clock_uncertainty 0.8 -from { main } -to { clk25 }



