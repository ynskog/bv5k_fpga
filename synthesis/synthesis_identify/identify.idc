device jtagport builtin
iice new {IICE_0} -type regular
iice controller -iice {IICE_0} none
iice sampler -iice {IICE_0} -always_armed 1
iice sampler -iice {IICE_0} -qualified_sampling 1
iice sampler -iice {IICE_0} -compression 1
iice sampler -iice {IICE_0} -depth 256

signals add -iice {IICE_0} -silent -sample  {/uI_adc_if/scka}\
{/uI_adc_if/sckb}\
{/uI_adc_if/sdi}\
{/uI_adc_if/sdoa}\
{/uI_adc_if/state_rg}
signals add -iice {IICE_0} -silent -trigger -sample  {/uI_adc_if/busy}\
{/uI_adc_if/drl}\
{/uI_adc_if/enable}\
{/uI_adc_if/ldctrl}\
{/uI_adc_if/mclk}\
{/uI_adc_if/sync}\
{/uI_adc_if/valida}\
{/uQ_adc_if/drl}
iice clock -iice {IICE_0} -edge positive {/clk}

