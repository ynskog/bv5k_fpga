

module Top ( 

    // ADC interfaces
    // Q channel
    output sync_q,scka_q,sckb_q,sdi_q,mclk_q,
    input sdoa_q,sdob_q,busy_q,drl_q, /* synthesis syn_noprune=1 */

    // I channel
    output sync_i,scka_i,sckb_i,sdi_i,mclk_i,
    input sdoa_i,sdob_i,busy_i,drl_i, /* synthesis syn_noprune=1 */

    // DAC interfaces
    // VCO
    output vco_din, vco_sclk,vco_csn,vco_clrn,
    // AGC
    output agc_din, agc_sclk,agc_csn,agc_clrn,

    // Camera interface
    output flir_mclk, flir_pwrdn,flir_rstn, flir_csn, flir_mosi, flir_sck,
    input flir_miso, /* synthesis syn_noprune=1 */

    // leds
    output led1_blu,led2_blu,led1_grn,led2_grn,

    // communications interface
    output miso_n, miso_p, rdy_n, rdy_p,
    input mosi_n, mosi_p, sck_n, sck_p, /* synthesis syn_noprune=1 */

    // crystal oscillator
    input xosc );

    localparam LEDBLINK = 0;

    // AGC interface
    logic agc_load;
    logic justStarted;
    logic [11:0] agc_data;

    logic [14:0] fifo_rdcnt;
    logic [10:0] fifo_wrcnt;
    logic fifo_rd;

    logic com_mosi, com_miso, com_sck, com_rdy;
    logic clk, arstn;

    logic adc_I_enable, adc_Q_enable;
    logic adc_I_mbusy;
    logic [9:0] adc_I_ctrlword, adc_Q_ctrlword;
    logic adc_I_ldctrl, adc_Q_ldctrl;
    logic adc_I_valida, adc_I_validb;
    logic [31:0] adc_I_dataa,adc_Q_dataa; 
    logic [31:0] adc_I_datab; 
    logic [31:0] eventCnt;

    logic agc_din_int, agc_sclk_int,agc_csn_int,agc_clrn_int;

    logic [7:0] fifo_rdata;

    mainPll u_mainPll ( /* synthesis syn_noprune=1 */
           .POWERDOWN(1'b0),
           .CLKA(xosc),
           .LOCK(arstn),
           .GLA(clk));

    logic test;

    always @(posedge clk) begin
        test <= ~test;
    end

    INBUF_LVDS INBUF_LVDS_0( /* synthesis syn_noprune=1 */
            // Inputs
            .PADP ( mosi_p ),
            .PADN ( mosi_n ),
            // Outputs
            .Y    ( com_mosi ) );
    
    INBUF_LVDS INBUF_LVDS_1( /* synthesis syn_noprune=1 */
            // Inputs
            .PADP ( sck_p ),
            .PADN ( sck_n ),
            // Outputs
            .Y    ( com_sck ) );

    //--------OUTBUF_LVDS
    OUTBUF_LVDS OUTBUF_LVDS_0( /* synthesis syn_noprune=1 */
            // Inputs
            .D    ( com_miso ),
            // Outputs
            .PADP ( miso_p ),
            .PADN ( miso_n ) );

    //--------OUTBUF_LVDS
    OUTBUF_LVDS OUTBUF_LVDS_1( /* synthesis syn_noprune=1 */
            // Inputs
            .D    ( com_rdy ),
            // Outputs
            .PADP ( rdy_p ),
            .PADN ( rdy_n ) );

// Interfaces

    assign agc_clrn = arstn;

 spiMasterWrite #(.DATA_WIDTH(16)) u_AgcCtrl (
    .clk(clk), 
    .arstn(arstn),
    .wdat({agc_data,4'b0000}),
    .load(agc_load),
    .sck(agc_sclk_int),
    .mosi(agc_din_int),
    .csn(agc_csn_int));
    
    assign agc_sclk = agc_sclk_int;
    assign agc_din = agc_din_int;
    assign agc_csn = agc_csn_int;

    // Temporary master sequencer used before we get something proper
    always @(posedge clk, negedge arstn) begin
        if(arstn == 1'b0) begin
            agc_data <= 12'h555; // 1V RMS
            agc_load <= 1'b0;
            justStarted <= 1'b1;
            adc_I_enable <= 1'b0;
            eventCnt <= 32'd0;
            adc_Q_enable <= 1'b0;
            adc_I_ldctrl <= 1'b0;
            adc_Q_ldctrl <= 1'b0;
            adc_I_ctrlword <= 10'b0000100100;
            adc_Q_ctrlword <= 10'b0000100100;
        end else begin
            justStarted <= 1'b0;
            adc_I_ldctrl <= 1'b0;
            adc_Q_ldctrl <= 1'b0;
            
            if(eventCnt < 1000000000) 
                eventCnt <= eventCnt + 1;
            else
                eventCnt <= 32'd1;
            
            agc_load <= 1'b0;
            adc_I_ldctrl <= 1'b0;
            adc_Q_ldctrl <= 1'b0;
            
            if(eventCnt == 500000000) begin
                //justStarted <= 1'b0;
                adc_I_ldctrl <= 1'b1;
                adc_Q_ldctrl <= 1'b1;
            end

            //if(justStarted == 1'b1) begin
            if(eventCnt == 500000100) begin
                //justStarted <= 1'b0;
                adc_I_enable <= 1'b1;
                adc_Q_enable <= 1'b1;
            end

            if(eventCnt == 0) begin
                adc_I_enable <= 1'b0;
                adc_Q_enable <= 1'b0;
            end

            if(eventCnt == 1000) agc_load <= 1'b1;

        end
    end

    adc_if uI_adc_if( 
        .clk(clk), 
        .arstn(arstn),
        .mclk(mclk_i),
        .scka(scka_i),
        .sckb(sckb_i),
        .sdi(sdi_i),
        .drl(drl_i),
        .df(16'd4),
        .sync(sync_i),
        .busy(busy_i),
        .sdoa(sdoa_i),
        .sdob(sdob_i),
        .enable(adc_I_enable),
        .mbusy(adc_I_mbusy),
        .ctrlword(adc_I_ctrlword),
        .ldctrl(adc_I_ldctrl),
        .douta(adc_I_dataa),
        .doutb(adc_I_datab),
        .valida(adc_I_valida),
        .validb(adc_I_validb));

    adc_if uQ_adc_if( 
        .clk(clk), 
        .arstn(arstn),
        .mclk(mclk_q),
        .scka(scka_q),
        .sckb(sckb_q),
        .sdi(sdi_q),
        .drl(drl_q),
        .df(16'd4),
        .sync(sync_q),
        .busy(busy_q),
        .sdoa(sdoa_q),
        .sdob(sdob_q),
        .enable(adc_Q_enable),
        .mbusy(adc_Q_mbusy),
        .ctrlword(adc_Q_ctrlword),
        .ldctrl(adc_Q_ldctrl),
        .douta(adc_Q_dataa),
        .doutb(adc_Q_datab),
        .valida(adc_Q_valida),
        .validb(adc_Q_validb));

    adc_fifo u_adc_fifo ( /* synthesis syn_noprune=1 */
           .DATA({adc_I_dataa,adc_Q_dataa}),
           .Q(fifo_rdata),
           .WE(adc_I_valida),
           .RE(fifo_rd),
           .WRCNT(fifo_wrcnt),
           .RDCNT(fifo_rdcnt),
           .WCLOCK(clk),
           .RCLOCK(com_sck),
           .FULL(),
           .EMPTY(),
           .RESET(arstn));

   master_if #(.BLOCKSIZE(1024)) u_master_if
    (.clk(com_sck),
     .arstn(arstn),
     .wrcnt(fifo_wrcnt),
     .mosi(com_mosi),
     .fifoRd(fifo_rd),
     .rdata(fifo_rdata),
     .miso(com_miso), 
     .rdy(com_rdy));


    generate 
        if(LEDBLINK)begin
            ledctrl u_ledctrl 
             (.clk(clk),
              .arstn(arstn),
              .green({led1_blu,led2_blu}),
              .blue({led1_grn,led2_grn}));
        end else begin
            assign {led1_blu,led2_blu,led1_grn,led2_grn} = 4'b0000;
        end
    endgenerate

    VCO_ctrl 
    #(.TICK_DELAY(16),
      .DATA_WIDTH(12),
      .P1_MAX(1024), 
      .P2_MAX(2048), 
      .P1_STEP_UP(2), 
      .P1_STEP_DOWN(4), 
      .P2_STEP_UP(1),
      .P2_STEP_DOWN(1)) 
    u_VCO_ctrl
    (.clk(clk),
     .arstn(arstn),
     .enable('1),
     .mosi(vco_din),
     .sck(vco_sclk), 
     .csn(vco_csn),
     .clrn(vco_clrn));

endmodule

