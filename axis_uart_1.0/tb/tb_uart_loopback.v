`timescale 1ns / 1ps

module tb_uart_loopback (
);


	reg aclk = 0;
	reg aresetn = 0;
	/* Dynamic Configuration */				/* Active when DYNAMIC_CONFIG == 1 */
	/* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26] */
	reg [26:0]s_axis_config_tdata = 0;
	reg s_axis_config_tvalid = 0;
	wire s_axis_config_tready;
	/* AXI-Stream Interface (Slave) */
	reg [8:0]s_axis_tdata = 0;
	reg s_axis_tvalid = 0;
	wire s_axis_tready;
	/* AXI-Stream Interface (Master) */
	wire [8:0]m_axis_tdata;
	wire [4:0] uart1_error;				/* Parity Error */
	wire m_axis_tvalid;
	reg m_axis_tready = 0;
	//
	wire [31:0] tx_data_count;
	wire [31:0] rx_data_count;
	// UART Port
	wire tx;
	wire rx;
	assign rx = tx;
	
	wire rts;						/* Active when FLOW_CONTROL == 1 */
	reg cts = 0;							/* Active when FLOW_CONTROL == 1 */

axis_uart_v1_0 #(
	72000000,
	1800000,
	1, 			/* 0(none), 1(even), 2(odd), 3(mark), 4(space) */
	8, 		/* Byte Size (16 max) */
	0, 		/* 0(one stop), 1(two stops) */
	32,		/* FIFO Depth */
	0,		/* RTS/CTS */
	0	/* Dynamic Configuration */
)
axis_uart_v1_0_inst
(
	aclk,
	aresetn,
	/* Dynamic Configuration */				/* Active when DYNAMIC_CONFIG == 1 */
	/* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26] */
	s_axis_config_tdata,	
	s_axis_config_tvalid,
	s_axis_config_tready,
	/* AXI-Stream Interface (Slave) */
	s_axis_tdata,
	s_axis_tvalid,
	s_axis_tready,
	/* AXI-Stream Interface (Master) */
	m_axis_tdata,
	m_axis_tvalid,
	m_axis_tready,
	uart1_error,
	//
	tx_data_count,
	rx_data_count,
	// UART Port
	tx,
	rx,
	rts,						/* Active when FLOW_CONTROL == 1 */
	cts							/* Active when FLOW_CONTROL == 1 */
);

    wire [8:0]m2_axis_tdata;
	wire [4:0] uart2_error;				/* Parity Error */
	wire m2_axis_tvalid;
	reg m2_axis_tready = 1;
	wire [31:0] rx2_data_count;
	wire rx2;
	
axis_uart_v1_0 #(
	72000000,
	1840000,
	1, 			/* 0(none), 1(even), 2(odd), 3(mark), 4(space) */
	8, 		/* Byte Size (16 max) */
	0, 		/* 0(one stop), 1(two stops) */
	4,		/* FIFO Depth */
	0,		/* RTS/CTS */
	0	/* Dynamic Configuration */
)
axis_uart_v1_0_inst_2
(
	.aclk(aclk),
	.aresetn(aresetn),
	/* Dynamic Configuration */				/* Active when DYNAMIC_CONFIG == 1 */
	/* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26] */
//	s_axis_config_tdata,	
//	s_axis_config_tvalid,
//	s_axis_config_tready,
	/* AXI-Stream Interface (Slave) */
//	s_axis_tdata,
//	s_axis_tvalid,
//	s_axis_tready,
	/* AXI-Stream Interface (Master) */
	.m_axis_tdata(m2_axis_tdata),
	.error(uart2_error),				/* Parity Error */
	.m_axis_tvalid(m2_axis_tvalid),
	.m_axis_tready(m2_axis_tready),
	//
//	.tx_data_count,
	.rx_data_count(rx2_data_count),
	// UART Port
//	tx,
	.rx(tx)
//	rts,						/* Active when FLOW_CONTROL == 1 */
//	cts							/* Active when FLOW_CONTROL == 1 */
);


always #5 aclk = ~aclk;

task axis_write;
input [31:0] data;
begin
    while (~s_axis_tready) @(posedge aclk);
    #2
    s_axis_tvalid = 1;
    s_axis_tdata = data;

    @(posedge aclk);
    #2 s_axis_tvalid = 0;

end
endtask

initial begin
    #20
    aresetn = 1;

    @(posedge aclk);

    #1
    m_axis_tready = 1;
    axis_write(0);
    axis_write(1);
    axis_write(2);
    axis_write(3);
    axis_write(4);
    axis_write(5);
    //
    m_axis_tready = 0;


    axis_write(6);
    axis_write(7);
    axis_write(8);
    axis_write(9);
    axis_write(10);

    #1000 
//    @(posedge aclk);
//    #1 
//    m_axis_tready = 1;

    #1000
//    repeat(10) @(posedge aclk);
    $stop;
end

endmodule
