module adc_if
    #(parameter MCLK_DIV=48)
    (input clk, arstn,
    
    output reg mclk, scka,sckb, sdi, sync,
    input drl,busy,sdoa,sdob,

    input [15:0] df, // downsampling factor

    input enable,
    output reg mbusy,

    input [9:0] ctrlword,
    input ldctrl, // load control word

    output reg [31:0] douta,
    output reg [31:0] doutb,
    output reg valida, validb);

    reg [4:0] bitcnt_rg;
    reg [11:0] ctrlword_rg;
    reg [4:0] state_rg;
    reg [5:0] sampleCnt;
    reg [15:0] readoutCnt;
    reg sampleTrigger;
    reg cfgTrigger;
    reg readoutTrigger;

    parameter idle_s=0, sample_s=1, convert_s=2, program_s=3, busy_s=4, 
              rdlow_s=5, rdhigh_s=6, prglow_s=7, prghigh_s=8, done_s=9, wait_prog_s = 10;

    always @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            mclk <= 1'b0;
        end else begin
            mclk <= 1'b0;
            if((enable && sampleTrigger) || cfgTrigger) begin
                mclk <= 1'b1;
            end
        end
    end

    always @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            sampleCnt     <= 6'd0;
            sampleTrigger <= 1'b0;
        end else begin
            sampleTrigger <= 1'b0;
            if (sampleCnt  == MCLK_DIV) begin
                sampleTrigger <= 1'b1;
                sampleCnt     <= 6'd0;
            end else begin
                sampleCnt     <= sampleCnt + 1;
            end
        end
    end

    always @(posedge clk,negedge arstn) begin
        if(arstn == 1'b0) begin
            readoutCnt     <= 16'd0;
            readoutTrigger <= 1'b0;
        end else begin
            readoutTrigger <= 1'b0;
            if(sampleTrigger && enable) begin
                if(readoutCnt == df-1) begin
                    readoutTrigger <= 1'b1;
                    readoutCnt     <= 16'd0;
                end else begin
                    readoutCnt <= readoutCnt + 1;
                end
            end
        end
    end

    always @(posedge clk,negedge arstn) begin
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
                    if(drl) state_rg <= program_s;
                end

                // start programming
                program_s : begin
                    // Here we wait for the conversion to finish before we can start programming
                    if(~drl) begin
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
                   //mclk <= 1'b1; 
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

