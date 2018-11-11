device jtagport builtin
iice new {IICE_0} -type regular
iice controller -iice {IICE_0} none
iice sampler -iice {IICE_0} -depth 1024

signals add -iice {IICE_0} -silent -trigger  {/u_master_if/fifoRd}
signals add -iice {IICE_0} -silent -sample  {/u_master_if/bitcnt}\
{/u_master_if/clk}
signals add -iice {IICE_0} -silent -trigger -sample  {/com_rdy}\
{/u_master_if/state_rg}
iice clock -iice {IICE_0} -edge positive {/clk}

