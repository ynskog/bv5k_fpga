device jtagport builtin
iice new {IICE_0} -type regular
iice controller -iice {IICE_0} none
iice sampler -iice {IICE_0} -depth 8

signals add -iice {IICE_0} -silent -trigger -sample  {/sync_q}
iice clock -iice {IICE_0} -edge positive {/clk}
