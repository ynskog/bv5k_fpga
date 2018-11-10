module adc_if
    #(parameter MCLK_DIV=36)
    (input clk, arstn,
    
    output logic mclk, scka,sckb, sdi, sync,
    input logic drl,busy,sdoa,sdob,

    input logic [15:0] downsampling, // downsampling factor

    input logic enable,
    output logic mbusy,

    input logic [9:0] ctrlword,
    input logic ldctrl, // load control word

    output logic [31:0] douta,
    output logic [31:0] doutb,
    output logic valida, validb);

    logic [4:0] bitcnt_rg;
    logic [11:0] ctrlword_rg;
    logic [5:0] sampleCnt;
    logic [15:0] readoutCnt;
    logic sampleTrigger;
    logic cfgTrigger;
    logic readoutTrigger;

    typedef enum {idle_s, sample_s, convert_s, program_s, busy_s, 
          rdlow_s, rdhigh_s, prglow_s, prghigh_s, done_s, wait_prog_s } states_t;

    states_t state_rg;

    always_ff @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            mclk <= 1'b0;
        end else begin
            mclk <= 1'b0;
            if((enable && sampleTrigger) || cfgTrigger) begin
                mclk <= 1'b1;
            end
        end
    end

    always_ff @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            sampleCnt     <= 6'd0;
            sampleTrigger <= 1'b0;
        end else begin
            sampleTrigger <= 1'b0;
            if (sampleCnt  == MCLK_DIV-1) begin
                sampleTrigger <= 1'b1;
                sampleCnt     <= 6'd0;
            end else begin
                sampleCnt     <= sampleCnt + 1;
            end
        end
    end

    always_ff @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            readoutCnt     <= 16'd0;
            readoutTrigger <= 1'b0;
        end else begin
            readoutTrigger <= 1'b0;
            if(sampleTrigger && enable) begin
                if(readoutCnt == downsampling-1) begin
                    readoutTrigger <= 1'b1;
                    readoutCnt     <= 16'd0;
                end else begin
                    readoutCnt <= readoutCnt + 1;
                end
            end
        end
    end

    always_ff @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            bitcnt_rg   <= 6'b0;
            state_rg    <= idle_s;
            sdi         <= 1'b0;
            scka        <= 1'b0;
            sckb        <= 1'b0;
            doutb       <= 32'b0;
            douta       <= 32'b0;
            valida      <= 1'b0;
            validb      <= 1'b0;
            ctrlword_rg <= 10'b0;
            sync        <= 1'b0;
            cfgTrigger  <= 1'b0;
        end else begin
            valida <= 1'b0;
            validb <= 1'b0;
            sync   <= 1'b0;
            cfgTrigger <= 1'b0;
            case(state_rg) 
                idle_s : begin
                    bitcnt_rg <= 6'b0;
                    if(ldctrl) begin
                        bitcnt_rg <= 6'd12;
                        ctrlword_rg <= {2'b10,ctrlword};
                        state_rg <= wait_prog_s;
                        cfgTrigger <= 1'b1; // configuration window opens following a conversion cycle, so start one now
                    end else if(enable && sampleTrigger) begin
                        state_rg <= convert_s;
                    end
                end
    
                wait_prog_s: begin
                    if(busy) state_rg <= program_s;
                end

                // start programming
                program_s : begin
                    // Here we wait for the conversion to finish before we can start programming
                    if(~busy) begin
                        sdi <= ctrlword_rg[bitcnt_rg-1];
                        bitcnt_rg <= bitcnt_rg - 1;
                        state_rg <= prghigh_s;
                    end
                end
    
                // start
                prghigh_s: begin
                    scka     <= 1'b1;
                    state_rg <= prglow_s;
                end
    
                prglow_s: begin
                    scka     <= 1'b0;
                    if (bitcnt_rg == 6'd0) begin
                        state_rg  <= idle_s;
                    end else begin
                        state_rg  <= prghigh_s;
                        sdi       <= ctrlword_rg[bitcnt_rg-1];
                        bitcnt_rg <= bitcnt_rg - 1;
                    end
                end

                convert_s: begin
                   if(readoutTrigger) begin
                    bitcnt_rg <= 6'd32;
                    state_rg <= busy_s;
                   end else begin
                     state_rg <= idle_s;
                   end
               end

               busy_s: begin
                if(~drl) begin
                    state_rg <= rdhigh_s;
                    sync <= 1'b1;
                end
               end

               rdhigh_s: begin
                scka <= 1'b1;
                douta[bitcnt_rg-1] <= sdoa;
                bitcnt_rg <= bitcnt_rg - 1;
                state_rg <= rdlow_s;
               end

               rdlow_s: begin
                scka <= 1'b0;
                if(bitcnt_rg == 32'd0) begin
                    valida <= 1'b1;
                    state_rg <= idle_s;
                end else begin
                    state_rg <= rdhigh_s;
                end
               end

            endcase // state_rg
        end
    end

endmodule

