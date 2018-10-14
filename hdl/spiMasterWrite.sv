module spiMasterWrite
    #(parameter DATA_WIDTH=16,
      parameter CSNPOL = 1'b0,
      parameter DPOL = 1'b1,
      parameter CPOL = 1'b1)
    (input clk, arstn,
     input [DATA_WIDTH-1:0] wdat,
     input load,
     output reg busy,
     output reg sck, mosi, csn); 
    
    reg [4:0] bitcnt_rg;
    reg [DATA_WIDTH-1:0] wdat_rg;
    reg busy_reg;
    reg [2:0] state_rg;

    parameter idle_s=0, start_s=1, high_s=2, low_s=3, done_s=4;

    always @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            bitcnt_rg <= 5'b0;
            state_rg <= idle_s;
            csn  <= ~CSNPOL;
            mosi <= ~DPOL;
            sck  <= ~CPOL;
        end else begin
            case(state_rg)
                
                idle_s: begin
                    csn <= ~CSNPOL;
                    if(load) begin
                        state_rg <= start_s;
                        wdat_rg  <= wdat;
                        csn <= CSNPOL;
                        bitcnt_rg <= 5'b0;
                    end
                end
                start_s: begin
                    mosi <= wdat_rg[DATA_WIDTH-1];
                    state_rg <= high_s;
                end

                high_s: begin
                    sck <= CPOL;
                    state_rg <= low_s;
                    wdat_rg <= {wdat_rg[DATA_WIDTH-2:0], 1'b0};
                    bitcnt_rg <= bitcnt_rg + 1;
                end
                low_s: begin
                    sck <= ~CPOL;
                    mosi <= wdat_rg[DATA_WIDTH-1];
                    if (bitcnt_rg == DATA_WIDTH) begin
                        state_rg <= done_s;
                    end else begin
                        state_rg <= high_s;
                    end


                end
                done_s: state_rg <= idle_s; // delay before csn is deasserted
            endcase // state
        end
    end

endmodule

