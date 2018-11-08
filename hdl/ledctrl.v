module ledctrl
    (input clk, arstn,
     output [1:0] green,
     output [1:0] blue);

  reg [23:0] cyclecnt;
  reg [7:0] sagtannur;
  reg [7:0] lysnad;
  reg tick;

  always @(posedge clk,negedge arstn) begin
    if(arstn == 1'b0) begin
       cyclecnt <= 24'd0;
       tick <= 1'b0;
    end else begin
       tick <= 1'b0;
       cyclecnt <= cyclecnt + 1;
       if (cyclecnt == 250) begin
           tick <= 1'b1;
           cyclecnt <= 24'd0;
       end 
    end
  end

  always @(posedge clk,negedge arstn) begin
    if(arstn == 1'b0) begin
       sagtannur <= 8'd0;
       lysnad <= 8'd0;
    end else begin
       if(tick) sagtannur <= sagtannur + 1;
       if (sagtannur == 8'd0 && tick) lysnad <= lysnad + 1;
    end
  end

  assign green[0] = lysnad > sagtannur;
  assign blue[0] = lysnad > sagtannur;
  assign green[1] = lysnad < sagtannur;
  assign blue[1] = lysnad < sagtannur;
endmodule // master_if