
module VCO_ctrl 
  #(parameter P1_MAX = 1024, // pulse 1 maximum value
    parameter P2_MAX = 1024, // pulse 2 maximum value
    parameter P1_RISETIME = 1000000, // rise time of pulse 1 in clock cycles
    parameter P1_FALLTIME = 1000000, // fall time of pulse 1 in clock cycles
    parameter P2_RISETIME = 1000000, // rise time of pulse 1 in clock cycles
    parameter P2_FALLTIME = 1000000) // fall time of pulse 1 in clock cycles

  (input logic clk, arstn,
   input logic enable,
   output logic mosi,
   input logic [7:0] rdata,
   output logic sck, 
   output logic csn,
   output logic clrn);

   logic [15:0] tickcnt;
   logic [3:0] state_rg;

   logic [12:0] vco_volt;

   parameter idle_s=1, p1_rise_s=2, p1_fall_s=3,p2_rise_s=4,p2_fall_s=5;

   spiMasterWrite u_AgcCtrl (
      .clk(clk), 
      .arstn(arstn),
      .wdat(vco_volt),
      .load(vco_load),
      .sck(sck),
      .mosi(mosi),
      .csn(csn));


   always_ff @(posedge clk,negedge arstn) begin



endmodule

