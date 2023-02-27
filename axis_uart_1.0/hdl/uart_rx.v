`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: mcjtag
// 
// Create Date: 03.10.2019 14:15:45
// Design Name: 
// Module Name: uart_rx
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

module uart_rx #(
	parameter BAUD_PRESCALER = 12,	
	parameter PARITY = 0,
	parameter BYTE_SIZE = 8,
	parameter STOP_BITS = 0,
	parameter FIFO_DEPTH = 16
)
(
	/* AXI-Stream Ports */
	input wire aclk,
	input wire aresetn,
	/* Dynamic Configuration */
	input wire [26:0]s_axis_config_tdata,
	input wire s_axis_config_tvalid,
	output wire s_axis_config_tready,
	/* Data */
	output wire [8:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,

	/* recv_timeout | overrun | frame | noise | parity */
	output wire [4:0]error,
	//
	output wire [31:0] rx_data_count,
	/* UART Port */
	input wire rxd,
	output wire rtsn
);

localparam STATE_IDLE = 0;
localparam STATE_START = 1;
localparam STATE_BYTE = 2;
localparam STATE_PAR = 3;
localparam STATE_STOP = 4;
localparam STATE_END = 5;

localparam PARITY_NONE = 3'd0;
localparam PARITY_EVEN = 3'd1;
localparam PARITY_ODD = 3'd2;
localparam PARITY_MARK = 3'd3;
localparam PARITY_SPACE = 3'd4;

localparam STOP_BITS_ONE = 1'd0;
localparam STOP_BITS_TWO = 1'd1;

reg [3:0]state;

reg [15:0]prescaler;
reg [2:0]parity;
reg [3:0]byte_size;
reg [0:0]stop_bits;
reg uart_rx_en;

reg pre_en;
wire pre_stb;
wire pre_half;

reg [8:0]s_data;
reg s_valid;
wire s_ready;

reg [8:0]rx_data;
reg rx_par;
reg rx_par_rcv;

reg [3:0]byte_cnt;
reg [15:0]bit_cnt;
reg bit_rec;
reg haftbit_rec;

reg parity_error;
reg overrun_error;
wire noise_error;
reg frame_error;

assign error = {1'b0, overrun_error, frame_error, noise_error, parity_error};

wire afull;

(* IOB = "TRUE" *) reg rxd_in;
(* IOB = "TRUE" *) reg rtsn_out;

wire rx_fall;
wire rx_rise;

assign s_axis_config_tready = (state == STATE_IDLE) ? 1'b1 : 1'b0;

/* Configuration */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		prescaler <= BAUD_PRESCALER;
		parity <= PARITY;
		byte_size <= BYTE_SIZE;
		stop_bits <= STOP_BITS;
		uart_rx_en <= 1'b1;
	end else begin
		if ((s_axis_config_tvalid == 1'b1) && (s_axis_config_tready == 1'b1)) begin
			prescaler <= s_axis_config_tdata[15:0];
			parity <= s_axis_config_tdata[18:16];
			byte_size <= s_axis_config_tdata[22:19];
			stop_bits <= s_axis_config_tdata[23];
			uart_rx_en <= s_axis_config_tdata[24];
		end
	end
end

/* In */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		rxd_in <= 1'b0;
		rtsn_out <= 1'b1;
	end else begin
		rxd_in <= rxd;
		rtsn_out <= (afull) ? 1'b1 : 1'b0;
	end
end

/* Bit recognition */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		bit_cnt <= 0;
	end else begin
		if (state != STATE_IDLE) begin
			if (pre_stb == 1'b1) begin
				bit_cnt <= 0;
			end else begin
				bit_cnt <= bit_cnt + rxd_in;
			end
		end else begin
			bit_cnt <= 0;
		end
	end
end

always @(*) begin
	if (aresetn == 1'b0) begin
		bit_rec <= 1'b0;
		haftbit_rec <= 1'b0;
	end else begin
		if (pre_stb == 1'b1) begin
			bit_rec <= (bit_cnt >= {1'b0,prescaler[15:1]}) ? 1'b1 : 1'b0;
			haftbit_rec <= (bit_cnt >= {2'b0,prescaler[15:2]})? 1'b1: 1'b0;
		end
	end
end

/* State Machine */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		pre_en <= 1'b0;
		s_data <= 0;
		s_valid <= 1'b0;
		rx_data <= 0;
		byte_cnt <= 0;
		rx_par_rcv <= 1'b0;
		state <= STATE_IDLE;
		parity_error <= 1'b0;
		overrun_error <= 1'b0;
		frame_error <= 1'b0;
	end else begin
		case (state)
		STATE_IDLE: begin
			parity_error <= 1'b0;
			overrun_error <= 1'b0;
			s_valid <= 1'b0;

			if ((rx_fall == 1'b1) && uart_rx_en) begin
				pre_en <= 1'b1;
				state <= STATE_START;
			end else begin
				pre_en <= 1'b0;
			end
		end
		STATE_START: begin
			if (pre_stb == 1'b1) begin
				if (bit_rec == 1'b0) begin
					byte_cnt <= 0;
					rx_data <= 0;
					state <= STATE_BYTE;
				end else begin
					state <= STATE_IDLE;
				end
			end
		end
		STATE_BYTE: begin
			if (pre_stb == 1'b1) begin
//				rx_data <= {rx_data[7:0], bit_rec};
				
				rx_data[byte_cnt] <= bit_rec;

				if (byte_cnt == (byte_size - 1)) begin
					if (parity == PARITY_NONE) begin
						state <= STATE_STOP;
					end else begin
						state <= STATE_PAR;
					end
				end else begin
					byte_cnt <= byte_cnt + 1;
				end
			end
		end
		STATE_PAR: begin
			if (pre_stb == 1'b1) begin
				rx_par_rcv <= bit_rec;
				state <= STATE_STOP;
			end
		end
		STATE_STOP: begin
			if (pre_half == 1'b1) begin
				frame_error <= haftbit_rec? 1'b0: 1'b1;
				state <= STATE_END;
			end
		end
		STATE_END: begin
			frame_error <= 1'b0;

			if ((parity != PARITY_NONE) && (rx_par != rx_par_rcv)) begin
				parity_error <= 1'b1;
			end else begin
				if (s_ready) begin
					s_valid <= 1'b1;
					s_data <= rx_data;
				end else begin
					overrun_error <= 1'b1;
				end
			
			end


			state <= STATE_IDLE;
			pre_en <= 1'b0;
		end
		endcase
	end
end

/* Parity Calculation */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		rx_par <= 1'b0;
	end else begin
		case (state)
		STATE_BYTE: begin
			if (pre_stb == 1'b1) begin
				case (parity)
				PARITY_EVEN: rx_par <= rx_par + bit_rec;
				PARITY_ODD: rx_par <= rx_par + bit_rec;
				default: rx_par <= rx_par;
				endcase
			end
		end
		STATE_PAR: begin
			rx_par <= rx_par;
		end
		STATE_STOP: begin
			rx_par <= rx_par;
		end
		default: begin
			case (parity)
			PARITY_EVEN: rx_par <= 1'b0;
			PARITY_ODD: rx_par <= 1'b1;
			PARITY_MARK: rx_par <= 1'b1;
			PARITY_SPACE: rx_par <= 1'b0;
			endcase
		end
		endcase
	end
end

uart_fifo #(
	.DATA_WIDTH(9),
	.DATA_DEPTH(FIFO_DEPTH)
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

uart_prescaler prescaler_inst (
	.clk(aclk),
	.rst(~aresetn),
	.en(pre_en),
	.div(prescaler),	
	.stb(pre_stb),
	.half(pre_half)
);

edge_detect #(
	.ZERO_DELAY("TRUE")
) edge_detect_inst (
	.clk(aclk),
	.sig(rxd_in),
	.fall(rx_fall),
	.rise(rx_rise)
);

noise_detect noise_detect_inst
(
	.clk(aclk),
	.en(uart_rx_en),
	.sig(rxd_in),
	.div(prescaler),
	.noise(noise_error)
);

endmodule

module edge_detect #(
	parameter ZERO_DELAY = "FALSE"
)
(
	input wire clk,
	input wire sig,
	output wire fall,
	output wire rise
);

reg [1:0]sig_ff;
reg fall_out;
reg rise_out;

assign fall = fall_out;
assign rise = rise_out;

always @(posedge clk) begin
	sig_ff[0] <= sig;
	sig_ff[1] <= sig_ff[0];
end

generate if (ZERO_DELAY == "FALSE") begin
	always @(posedge clk) begin
		if (sig_ff[0] & ~sig_ff[1]) begin
			rise_out <= 1'b1;
		end else begin
			rise_out <= 1'b0;
		end
		if (~sig_ff[0] & sig_ff[1]) begin
			fall_out <= 1'b1;
		end else begin
			fall_out <= 1'b0;
		end
	end
end else begin
	always @(sig, sig_ff[0]) begin
		rise_out <= sig & ~sig_ff[0];
		fall_out <= ~sig & sig_ff[0];
	end
end endgenerate

endmodule

module noise_detect
(
	input wire clk,
	input wire en,
	input wire sig,
	input wire [15:0]div,
	output wire noise
);

reg [1:0]sig_ff;
reg noise_out;
reg [15:0]cnt = 0;

assign noise = noise_out;

always @(posedge clk) begin

	sig_ff[0] <= sig;
	sig_ff[1] <= sig_ff[0];

	if (sig_ff[1]) begin
		cnt <= 0;
		noise_out <= (en && (cnt > 0) && (cnt < div[15:1]))? 1'b1: 1'b0;
	end else begin
		noise_out <= 1'b0;
		cnt <= cnt + 1'b1;
	end
end


endmodule