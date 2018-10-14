################################################################################
#  SDC WRITER VERSION "3.1";
#  DESIGN "Top";
#  Timing constraints scenario: "Primary";
#  DATE "Sun Oct 14 11:19:49 2018";
#  VENDOR "Actel";
#  PROGRAM "Microsemi Libero Software Release v11.8 SP3";
#  VERSION "11.8.3.6"  Copyright (C) 1989-2018 Actel Corp. 
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name { u_mainPll/Core:GLA } -period 15.610 -waveform { 0.000 7.805  }  { u_mainPll/Core:GLA  } 
#
# *** Note *** This constraint was converted from a create_generated_clock constraint
#              which used both -divide_by and -multiply_by options:
#              create_generated_clock  -name { u_mainPll/Core:GLA } -divide_by 16  -multiply_by 41  -source { u_mainPll/Core:CLKA } { u_mainPll/Core:GLA  } 


create_clock  -name { clk25 } -period 40.000 -waveform { 0.000 20.000  }  { xosc  } 

create_clock  -name { com_sck } -period 31.250 -waveform { 15.625 0.000  }  { com_sck  } 



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

set_clock_uncertainty 0.8 -from { clk25 } -to { u_mainPll/Core:GLA }

set_clock_uncertainty 0.8 -from { u_mainPll/Core:GLA } -to { clk25 }



