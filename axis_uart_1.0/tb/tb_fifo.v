`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 04:47:59 PM
// Design Name: 
// Module Name: tb_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_fifo(

    );

localparam DATA_WIDTH = 16;

reg aclk = 0;
reg aresetn = 0;
reg [DATA_WIDTH-1:0] s_data = 0;
reg s_valid = 0;
wire s_ready;

wire [DATA_WIDTH-1:0] m_axis_tdata;
wire m_axis_tvalid;
reg m_axis_tready = 0;

wire afull;
wire [31:0] rx_data_count;


uart_fifo #(
	.DATA_WIDTH(DATA_WIDTH),
	.DATA_DEPTH(4)
) fifo_sync_inst (
	.aclk(aclk),
	.aresetn(aresetn),
	.s_axis_tdata(s_data),
	.s_axis_tvalid(s_valid),
	.s_axis_tready(s_ready),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready),
	.almost_full(afull),
	.data_count(rx_data_count)
);

always #5 aclk = ~aclk;

initial begin
    #20 
    aresetn = 1;

    @(posedge aclk);

    #1
    m_axis_tready = 1;
    s_valid = 1;
    s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;
    //
    m_axis_tready = 0;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;

    @(posedge aclk);
    #1 s_data = s_data + 1;
    s_valid = 0;
    m_axis_tready = 1;

    repeat(10) @(posedge aclk);
    $stop;
end
endmodule
