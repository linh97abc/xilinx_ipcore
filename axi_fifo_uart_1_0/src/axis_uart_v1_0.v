`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: mcjtag
// 
// Create Date: 03.10.2019 14:07:08
// Design Name: 
// Module Name: uart_tx
// Project Name: axis_uart
// Target Devices: All
// Tool Versions: 2018.3
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axis_uart_v1_0 #(
	parameter integer ACLK_FREQ_HZ = 100000000,
	parameter integer BAUDRATE     = 115200,
	parameter integer PARITY = 0, 			/* 0(none), 1(even), 2(odd), 3(mark), 4(space) */
	parameter integer BYTE_SIZE = 8, 		/* Byte Size (16 max) */
	parameter integer STOP_BITS = 0, 		/* 0(one stop), 1(two stops) */
	parameter integer FIFO_DEPTH = 256,		/* FIFO Depth */
	parameter integer FLOW_CONTROL = 0,		/* RTS/CTS */
	parameter integer DYNAMIC_CONFIG = 0	/* Dynamic Configuration */
)
(
	input wire aclk,
	input wire aresetn,
	/* Dynamic Configuration */				/* Active when DYNAMIC_CONFIG == 1 */
	/* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26] */
	input wire [26:0]s_axis_config_tdata,	
	input wire s_axis_config_tvalid,
	output wire s_axis_config_tready,
	/* AXI-Stream Interface (Slave) */
	input wire [15:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	/* AXI-Stream Interface (Master) */
	output wire [15:0]m_axis_tdata,
	output wire m_axis_tuser,				/* Parity Error */
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	//
	output wire [31:0] tx_data_count,
	output wire [31:0] rx_data_count,
	// UART Port
	output wire tx,
	input wire rx,
	output wire rts,						/* Active when FLOW_CONTROL == 1 */
	input wire cts							/* Active when FLOW_CONTROL == 1 */
);

localparam integer BAUD_PRESCALER = ACLK_FREQ_HZ/BAUDRATE;

wire s_axis_config_tx_tready;
wire s_axis_config_rx_tready;

wire uart_aresetn;
assign uart_aresetn = ~(s_axis_config_tvalid & s_axis_config_tdata[26]) & aresetn;

assign s_axis_config_tready = (DYNAMIC_CONFIG) ? s_axis_config_tx_tready & s_axis_config_rx_tready : 1'b0;

uart_tx #(
	.BAUD_PRESCALER(BAUD_PRESCALER),
	.PARITY(PARITY),
	.BYTE_SIZE(BYTE_SIZE),
	.STOP_BITS(STOP_BITS),
	.FIFO_DEPTH(FIFO_DEPTH)
) uart_tx_inst (
	.aclk(aclk),
	.aresetn(uart_aresetn),
	.s_axis_config_tdata(s_axis_config_tdata),
	.s_axis_config_tvalid((DYNAMIC_CONFIG) ? s_axis_config_tvalid : 1'b0),
	.s_axis_config_tready(s_axis_config_tx_tready),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tvalid(s_axis_tvalid),
	.s_axis_tready(s_axis_tready),
	.txd(tx),
	.ctsn(FLOW_CONTROL ? cts : 1'b0),
	.tx_data_count(tx_data_count)
);

uart_rx #(
	.BAUD_PRESCALER(BAUD_PRESCALER),
	.PARITY(PARITY),
	.BYTE_SIZE(BYTE_SIZE),
	.STOP_BITS(STOP_BITS),
	.FIFO_DEPTH(FIFO_DEPTH)
) uart_rx_inst (
	.aclk(aclk),
	.aresetn(uart_aresetn),
	.s_axis_config_tdata(s_axis_config_tdata),
	.s_axis_config_tvalid((DYNAMIC_CONFIG) ? s_axis_config_tvalid : 1'b0),
	.s_axis_config_tready(s_axis_config_rx_tready),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tuser(m_axis_tuser),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready),
	.rxd(rx),
	.rtsn(rts),
	.rx_data_count(rx_data_count)
);

endmodule
