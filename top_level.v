module top
(
    input           clk_i,
    input           rst_i,
    
    output          sdram_clk_o,
    output          sdram_cke_o,
    output [1:0]    sdram_dqm_o,
    output          sdram_cas_o,
    output          sdram_ras_o,
    output          sdram_we_o,
    output          sdram_cs_o,
    output [1:0]    sdram_ba_o,
    output [12:0]   sdram_addr_o,
    inout  [15:0]   sdram_data_io
);

wire [ 15:0]        sdram_data_in_w;
wire [ 15:0]        sdram_data_out_w;
wire                sdram_data_out_en_w;

sdram_axi
u_sdram
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    // AXI port
    ,.inport_awvalid_i(...)
    ,.inport_awaddr_i(...)
    ,.inport_awid_i(...)
    ,.inport_awlen_i(...)
    ,.inport_awburst_i(...)
    ,.inport_wvalid_i(...)
    ,.inport_wdata_i(...)
    ,.inport_wstrb_i(...)
    ,.inport_wlast_i(...)
    ,.inport_bready_i(...)
    ,.inport_arvalid_i(...)
    ,.inport_araddr_i(...)
    ,.inport_arid_i(...)
    ,.inport_arlen_i(...)
    ,.inport_arburst_i(...)
    ,.inport_rready_i(...)
    ,.inport_awready_o(...)
    ,.inport_wready_o(...)
    ,.inport_bvalid_o(...)
    ,.inport_bresp_o(...)
    ,.inport_bid_o(...)
    ,.inport_arready_o(...)
    ,.inport_rvalid_o(...)
    ,.inport_rdata_o(...)
    ,.inport_rresp_o(...)
    ,.inport_rid_o(...)
    ,.inport_rlast_o(...)

    // SDRAM Interface
    ,.sdram_clk_o()
    ,.sdram_cke_o(sdram_cke_o)
    ,.sdram_cs_o(sdram_cs_o)
    ,.sdram_ras_o(sdram_ras_o)
    ,.sdram_cas_o(sdram_cas_o)
    ,.sdram_we_o(sdram_we_o)
    ,.sdram_dqm_o(sdram_dqm_o)
    ,.sdram_addr_o(sdram_addr_o)
    ,.sdram_ba_o(sdram_ba_o)
    ,.sdram_data_input_i(sdram_data_in_w)
    ,.sdram_data_output_o(sdram_data_out_w)
    ,.sdram_data_out_en_o(sdram_data_out_en_w)
);

ODDR2 
#(
    .DDR_ALIGNMENT("NONE"),
    .INIT(1'b0),
    .SRTYPE("SYNC")
)
u_clock_delay
(
    .Q(sdram_clk_o),
    .C0(clk_i),
    .C1(~clk_i),
    .CE(1'b1),
    .R(1'b0),
    .S(1'b0),
    .D0(1'b0),
    .D1(1'b1)
);

genvar i;
for (i=0; i < 16; i = i + 1) 
begin
  IOBUF 
  #(
    .DRIVE(12),
    .IOSTANDARD("LVTTL"),
    .SLEW("FAST")
  )
  u_data_buf
  (
    .O(sdram_data_in_w[i]),
    .IO(sdram_data_io[i]),
    .I(sdram_data_out_w[i]),
    .T(~sdram_data_out_en_w)
  );
end

endmodule