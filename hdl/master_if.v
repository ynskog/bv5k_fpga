
module master_if
    #(parameter BLOCKSIZE=1024)
    (input clk, arstn,
     input [10:0] wrcnt,
     input mosi,
     output reg fifoRd,
     input [7:0] rdata,
     output miso, 
     output reg rdy);

    reg [2:0] bitcnt;
    reg [3:0] state_rg;


    parameter idle_s=1, read1_s=2, read2_s=3,transfer_s=4;

    assign miso = rdata[bitcnt];

    always @(wrcnt) begin
        rdy = (wrcnt*8 >= BLOCKSIZE) ? 1'b1 : 1'b0;
    end

    always @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            state_rg <= idle_s;
            bitcnt <= 3'd0;
            fifoRd <= 1'b0;
        end else begin
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
                    state_rg <= read2_s;
                end

                read2_s: begin
                    state_rg <= transfer_s;
                end

                transfer_s: begin
                    bitcnt <= bitcnt + 1;
                    if( mosi == 1'b1) begin 
                        state_rg <= idle_s;
                    end else if(bitcnt==5) begin
                        fifoRd <= 1'b1;
                    end
                end
            endcase // state_rg
        end
    end


endmodule

