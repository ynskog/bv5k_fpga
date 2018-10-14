

module spi_if( output MISO, RDY, input MOSI, SCK);

assign MISO = MOSI;
assign RDY = SCK;

endmodule

