
module VCO_ctrl 
  #(parameter TICK_DELAY = 1,
    parameter DATA_WIDTH = 12,
    parameter P1_MAX = 1024, // pulse 1 maximum value
    parameter P2_MAX = 2024, // pulse 2 maximum value
    parameter P1_STEP_UP = 2, 
    parameter P1_STEP_DOWN = 2, 
    parameter P2_STEP_UP = 2,
    parameter P2_STEP_DOWN = 2) 

  (input logic clk, arstn,
   input logic enable,
   output logic mosi,
   output logic sck, 
   output logic csn,
   output logic clrn);

   logic [15:0] tickcnt;
   logic vco_load;
   logic [DATA_WIDTH-1:0] vco_volt;
   logic tick;

   typedef enum {idle_s, p1_rise_s, p1_fall_s,p2_rise_s,p2_fall_s} states_t;

   states_t state_rg;

   spiMasterWrite #(.DATA_WIDTH(16)) u_AgcCtrl (
      .clk(clk), 
      .arstn(arstn),
      .wdat({vco_volt,4'b0000}),
      .load(vco_load),
      .sck(sck),
      .mosi(mosi),
      .csn(csn));

   always_ff @(posedge clk,negedge arstn) begin
     if(arstn == 1'b0) begin
       tickcnt <= 0;
       tick <= '0;
     end else begin
       tick <= '0;
       if (tickcnt == TICK_DELAY) begin
         tickcnt <= 0;
         tick <= '1;
       end else begin
         tickcnt <= tickcnt + 1;
       end
     end
   end

   always_ff @(posedge clk,negedge arstn) begin
     if(arstn == 1'b0) begin
       vco_load <= '0;
       vco_volt <= 0;
       state_rg <= idle_s;
       clrn <= '0;
     end else begin 
       vco_load <= '0;
       clrn <= '1;
       case(state_rg)
        idle_s: begin
          clrn <= '0;
          if(enable) state_rg <= p1_rise_s;
          vco_volt <= 0;
          vco_load <= '1;
        end 
        p1_rise_s: begin
          if(tick) begin
            vco_volt <= vco_volt + P1_STEP_UP;
            if(vco_volt + P1_STEP_UP >= P1_MAX) begin
              state_rg <= p1_fall_s;
            end
            vco_load <= '1;
          end
        end
        p1_fall_s: begin
          if(tick) begin
            if(vco_volt <= P1_STEP_DOWN) begin
              vco_volt <= 0;
              state_rg <= p2_rise_s;
            end else begin
              vco_volt <= vco_volt - P1_STEP_DOWN;
            end  
            vco_load <= '1;
          end
        end
        p2_rise_s: begin
          if(tick) begin
            vco_volt <= vco_volt + P2_STEP_UP;
            if(vco_volt + P2_STEP_UP >= P2_MAX) begin
              state_rg <= p2_fall_s;
            end
            vco_load <= '1;
          end
        end 
        p2_fall_s: begin
          if(tick) begin
            if(vco_volt <= P2_STEP_DOWN) begin
              vco_volt <= 0;
              state_rg <= enable ? p1_rise_s : idle_s;
            end else begin
              vco_volt <= vco_volt - P2_STEP_DOWN;
            end  
            vco_load <= '1;
          end
        end 
      endcase // state_rg
    end
  end

endmodule

