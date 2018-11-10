
`timescale 1ns/100ps

module testur_topp;

parameter SYSCLK_PERIOD = 40;// 25MHZ

reg SYSCLK;
reg NSYSRESET;

initial
begin
    SYSCLK = 1'b0;
    NSYSRESET = 1'b0;
end

//////////////////////////////////////////////////////////////////////
// Reset Pulse
//////////////////////////////////////////////////////////////////////
initial
begin
    #(SYSCLK_PERIOD * 10 )
        NSYSRESET = 1'b1;
end


//////////////////////////////////////////////////////////////////////
// Clock Driver
//////////////////////////////////////////////////////////////////////
always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;


// Interface to AGC DAC
wire agc_din, agc_sclk, agc_csn, agc_clrn;

// Interface to VCO DAC
wire vco_din, vco_sclk, vco_csn, vco_clrn;

reg drl_i, drl_q;
reg busy_i, busy_q;
wire mclk_i, mclk_q;
wire scka_i, scka_q;
reg sdoa_i, sdoa_q;
reg com_mosi;
wire mosi_p, mosi_n;
reg com_sck;
wire sck_p, sck_n;
wire rdy_p, rdy_n, com_rdy;
wire [3:0] led;

// very simple adc simulator
initial forever begin
    drl_i  <= 1'b0;
    busy_i <= 1'b0;
    @(negedge mclk_i); 
    drl_i <= 1'b1;
    busy_i <= 1'b1;
    #600;
    busy_i <= 1'b0;
    drl_i <= 1'b0;
end

always @(posedge scka_i) sdoa_i <= $random;
always @(posedge scka_q) sdoa_q <= $random;

// very simple adc simulator
initial forever begin
    drl_q <= 1'b0;
    busy_q <= 1'b0;
    @(negedge mclk_q); 
    busy_q <= 1'b1;
    drl_q <= 1'b1;
    #600;
    busy_q <= 1'b0;    
    drl_q <= 1'b0;
end

// data readout
initial begin
    com_mosi = 1'b0;
    com_sck = 1'b0;
    forever begin
        @(posedge com_rdy);
        com_mosi <= 1'b1;
        repeat(6) begin
            com_sck = 1'b1;
            #20;
            com_sck = 1'b0;
            #20;
        end
        com_mosi <= 1'b0;
        com_sck = 1'b1;
        #20;
        com_sck = 1'b0;
        #20; 
        com_sck = 1'b1;
        #20;
        com_sck = 1'b0;
        #20; 
        repeat(1024) begin
            #100;
            repeat(8) begin
                com_sck = 1'b1;
                #20;
                com_sck = 1'b0;
                #20;
            end
        end
    end
end

OUTBUF_LVDS u0_OUTBUF_LVDS( 
        // Inputs
        .D    ( com_sck ),
        // Outputs
        .PADP ( sck_p ),
        .PADN ( sck_n ));

OUTBUF_LVDS u1_OUTBUF_LVDS( 
        // Inputs
        .D    ( com_mosi ),
        // Outputs
        .PADP ( mosi_p ),
        .PADN ( mosi_n ));

    INBUF_LVDS u0_INBUF_LVDS( 
            // Inputs
            .PADP ( rdy_p ),
            .PADN ( rdy_n ),
            // Outputs
            .Y    ( com_rdy ) );

//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  Top
//////////////////////////////////////////////////////////////////////
Top Top_0 (
    // Inputs
    .sdoa_q(sdoa_q),
    .sdob_q({1{1'b0}}),
    .busy_q(busy_q),
    .drl_q(drl_q),
    .sdoa_i(sdoa_i),
    .sdob_i({1{1'b0}}),
    .busy_i(busy_i),
    .drl_i(drl_i),
    .flir_miso({1{1'b0}}),
    .mosi_n(mosi_n),
    .mosi_p(mosi_p),
    .sck_n(sck_n),
    .sck_p(sck_p),
    .xosc(SYSCLK),

    // Outputs
    .sync_q( ),
    .scka_q( scka_q),
    .led1_blu(led[0]),
    .led2_blu(led[1]),
    .led1_grn(led[2]),
    .led2_grn(led[3]),
    .sckb_q( ),
    .sdi_q( ),
    .mclk_q(mclk_q ),
    .sync_i( ),
    .scka_i(scka_i),
    .sckb_i( ),
    .sdi_i( ),
    .mclk_i(mclk_i),
    .vco_din(vco_din ),
    .vco_sclk(vco_sclk ),
    .vco_csn(vco_csn ),
    .vco_clrn(vco_clrn ),
    .agc_din(agc_din ),
    .agc_sclk(agc_sclk ),
    .agc_csn(agc_csn ),
    .agc_clrn(agc_clrn ),
    .flir_mclk( ),
    .flir_pwrdn( ),
    .flir_rstn( ),
    .flir_csn( ),
    .flir_mosi( ),
    .flir_sck( ),
    .miso_n( ),
    .miso_p( ),
    .rdy_n( rdy_n),
    .rdy_p( rdy_p)

    // Inouts

);

endmodule

