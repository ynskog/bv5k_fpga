device jtagport builtin
iice new {IICE_0} -type regular
iice controller -iice {IICE_0} none
iice sampler -iice {IICE_0} -depth 128

{/u_master_if/wrcnt}
signals add -iice {IICE_0} -silent -trigger -sample  {/com_rdy}\
{/u_master_if/clk}
iice clock -iice {IICE_0} -edge positive {/clk}
