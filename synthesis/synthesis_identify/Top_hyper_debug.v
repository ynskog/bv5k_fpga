// available hyper connections - for debug and ip models
// timestamp: 1540730437


`ifndef SYN_HYPER_CONNECT
`define SYN_HYPER_CONNECT 1
module syn_hyper_connect(out) /* synthesis syn_black_box=1 syn_noprune=1 */;
parameter w = 1;
parameter tag = "xxx";
parameter dflt = 0;
parameter mustconnect = 1'b1;
output [w-1:0] out;
endmodule
`endif

module Top_hyper_debug(dummy);
input dummy; /* avoid compiler error for no ports */

wire clk_0;
syn_hyper_connect clk_connect_0(clk_0);
defparam clk_connect_0.tag = "clk";


wire mclk_0;
syn_hyper_connect mclk_connect_0(mclk_0);
defparam mclk_connect_0.tag = "uQ_adc_if.mclk";

wire mclk_1;
syn_hyper_connect mclk_connect_1(mclk_1);
defparam mclk_connect_1.tag = "uI_adc_if.mclk";


wire scka_0;
syn_hyper_connect scka_connect_0(scka_0);
defparam scka_connect_0.tag = "uQ_adc_if.scka";

wire scka_1;
syn_hyper_connect scka_connect_1(scka_1);
defparam scka_connect_1.tag = "uI_adc_if.scka";


wire sckb_0;
syn_hyper_connect sckb_connect_0(sckb_0);
defparam sckb_connect_0.tag = "uQ_adc_if.sckb";

wire sckb_1;
syn_hyper_connect sckb_connect_1(sckb_1);
defparam sckb_connect_1.tag = "uI_adc_if.sckb";


wire sdi_0;
syn_hyper_connect sdi_connect_0(sdi_0);
defparam sdi_connect_0.tag = "uQ_adc_if.sdi";

wire sdi_1;
syn_hyper_connect sdi_connect_1(sdi_1);
defparam sdi_connect_1.tag = "uI_adc_if.sdi";


wire sync_0;
syn_hyper_connect sync_connect_0(sync_0);
defparam sync_connect_0.tag = "uQ_adc_if.sync";

wire sync_1;
syn_hyper_connect sync_connect_1(sync_1);
defparam sync_connect_1.tag = "uI_adc_if.sync";


wire drl_0;
syn_hyper_connect drl_connect_0(drl_0);
defparam drl_connect_0.tag = "uQ_adc_if.drl";

wire drl_1;
syn_hyper_connect drl_connect_1(drl_1);
defparam drl_connect_1.tag = "uI_adc_if.drl";


wire sdoa_0;
syn_hyper_connect sdoa_connect_0(sdoa_0);
defparam sdoa_connect_0.tag = "uQ_adc_if.sdoa";

wire sdoa_1;
syn_hyper_connect sdoa_connect_1(sdoa_1);
defparam sdoa_connect_1.tag = "uI_adc_if.sdoa";


wire enable_0;
syn_hyper_connect enable_connect_0(enable_0);
defparam enable_connect_0.tag = "uQ_adc_if.enable";

wire enable_1;
syn_hyper_connect enable_connect_1(enable_1);
defparam enable_connect_1.tag = "uI_adc_if.enable";


wire ldctrl_0;
syn_hyper_connect ldctrl_connect_0(ldctrl_0);
defparam ldctrl_connect_0.tag = "uQ_adc_if.ldctrl";

wire ldctrl_1;
syn_hyper_connect ldctrl_connect_1(ldctrl_1);
defparam ldctrl_connect_1.tag = "uI_adc_if.ldctrl";


wire valida_0;
syn_hyper_connect valida_connect_0(valida_0);
defparam valida_connect_0.tag = "uQ_adc_if.valida";

wire valida_1;
syn_hyper_connect valida_connect_1(valida_1);
defparam valida_connect_1.tag = "uI_adc_if.valida";


wire [4:0] state_rg_0;
syn_hyper_connect state_rg_connect_0(state_rg_0);
defparam state_rg_connect_0.w = 5;
defparam state_rg_connect_0.tag = "uQ_adc_if.state_rg";

wire [4:0] state_rg_1;
syn_hyper_connect state_rg_connect_1(state_rg_1);
defparam state_rg_connect_1.w = 5;
defparam state_rg_connect_1.tag = "uI_adc_if.state_rg";


wire identify_sampler_ready_0;
syn_hyper_connect identify_sampler_ready_connect_0(identify_sampler_ready_0);
defparam identify_sampler_ready_connect_0.tag = "ident_coreinst.IICE_0_INST.b3_SoW.identify_sampler_ready";


wire Identify_IICE_0_trigger_ext_0;
syn_hyper_connect Identify_IICE_0_trigger_ext_connect_0(Identify_IICE_0_trigger_ext_0);
defparam Identify_IICE_0_trigger_ext_connect_0.tag = "ident_coreinst.IICE_0_INST.Identify_IICE_0_trigger_ext";


wire [7:0] ujtag_wrapper_uireg_0;
syn_hyper_connect ujtag_wrapper_uireg_connect_0(ujtag_wrapper_uireg_0);
defparam ujtag_wrapper_uireg_connect_0.w = 8;
defparam ujtag_wrapper_uireg_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_uireg";


wire ujtag_wrapper_urstb_0;
syn_hyper_connect ujtag_wrapper_urstb_connect_0(ujtag_wrapper_urstb_0);
defparam ujtag_wrapper_urstb_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_urstb";


wire ujtag_wrapper_udrupd_0;
syn_hyper_connect ujtag_wrapper_udrupd_connect_0(ujtag_wrapper_udrupd_0);
defparam ujtag_wrapper_udrupd_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_udrupd";


wire ujtag_wrapper_udrck_0;
syn_hyper_connect ujtag_wrapper_udrck_connect_0(ujtag_wrapper_udrck_0);
defparam ujtag_wrapper_udrck_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_udrck";


wire ujtag_wrapper_udrcap_0;
syn_hyper_connect ujtag_wrapper_udrcap_connect_0(ujtag_wrapper_udrcap_0);
defparam ujtag_wrapper_udrcap_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_udrcap";


wire ujtag_wrapper_udrsh_0;
syn_hyper_connect ujtag_wrapper_udrsh_connect_0(ujtag_wrapper_udrsh_0);
defparam ujtag_wrapper_udrsh_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_udrsh";


wire ujtag_wrapper_utdi_0;
syn_hyper_connect ujtag_wrapper_utdi_connect_0(ujtag_wrapper_utdi_0);
defparam ujtag_wrapper_utdi_connect_0.tag = "ident_coreinst.comm_block_INST.jtagi.ujtag_wrapper_utdi";

endmodule
