# The JTAG clock(s) - actually it's just one clock (running at 1 MHz) - in the instrumentation logic needs timing constraints
define_clock   {n:ident_coreinst.comm_block_INST.dr2_tck} -period 1000.0 -clockgroup identify_jtag_group1
define_attribute {v:*haps_ddr3_controller*} {syn_hier} {fixed}
