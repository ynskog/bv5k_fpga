
module master_if
    #(parameter BLOCKSIZE=1024)
    (input clk, arstn,
     input [9:0] wrcnt,
     input mosi,
     output logic fifoRd,
     output logic fifoClr,
     input [7:0] rdata,
     output logic miso);

    typedef enum {idle_s,read1_s,read2_s,transfer_s} states_t;

    logic [2:0] bitcnt;
    states_t state_rg;

    always @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            state_rg <= idle_s;
            bitcnt <= 3'd0;
            fifoRd <= 1'b0;
            fifoClr <= 1'b0;
            miso <= 1'b0;
        end else begin
            fifoClr <= 1'b0;
            fifoRd <= 1'b0;

            case(state_rg) 
                idle_s : begin
                    bitcnt <= 3'd0;
                    if( mosi == 1'b0) begin
                        fifoRd <= 1'b1;
                        state_rg <= read1_s;
                    end
                end

                read1_s: begin
                    if( mosi == 1'b1 ) begin
                        fifoClr <= 1'b1;
                        state_rg <= idle_s;
                    end else begin
                        state_rg <= read2_s;
                    end
                end

                read2_s: begin
                    state_rg <= transfer_s;
                end

                transfer_s: begin
                    bitcnt <= bitcnt + 1;
                    miso <= rdata[7-bitcnt];
                    if(bitcnt==5) begin
                        if( mosi == 1'b1) begin
                            state_rg <= idle_s;
                        end else begin
                            fifoRd <= 1'b1;
                        end
                    end
                end
            endcase // state_rg
        end
    end

endmodule

