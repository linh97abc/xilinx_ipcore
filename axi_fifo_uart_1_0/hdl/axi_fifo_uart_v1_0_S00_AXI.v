
`timescale 1 ns / 1 ps
	module axi_fifo_uart_v1_0_S00_AXI #
	(
		// Users to add parameters here
        parameter integer ACLK_FREQ_HZ = 100000000,
        parameter integer BAUDRATE     = 115200,
        parameter integer PARITY = 0, 			/* 0(none), 1(even), 2(odd), 3(mark), 4(space) */
        parameter integer BYTE_SIZE = 8, 		/* Byte Size (16 max) */
        parameter integer STOP_BITS = 0, 		/* 0(one stop), 1(two stops) */
        parameter integer FIFO_DEPTH = 256,		/* FIFO Depth */
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 6
	)
	(
		// Users to add ports here
		output irq,
	   // UART Port
        output wire tx,
        input wire rx,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);
	
	    wire [15:0] m_axis_uart_tdata;
        wire m_axis_uart_tvalid;
        wire m_axis_uart_tready;
        
        wire [23:0] m_axis_uart_cfg_tdata;
        wire m_axis_uart_cfg_tvalid;
        wire m_axis_uart_cfg_tready;
        
        wire [15:0] s_axis_uart_tdata;
        wire s_axis_uart_tvalid;
        wire s_axis_uart_tready;
		wire s_axis_uart_tuser;
        
       
	
		// axis_uart


    wire uart_cfg_ready;
    wire uart_rx_valid;
    wire uart_rx_user;
    wire uart_tx_ready;
    reg [15:0]uart_tx_data;
    reg uart_tx_valid;

    
    wire  [15:0]uart_rx_data;
    reg uart_rx_ready;
    
        //
	/* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26], en = [31] */
	reg [31:0]uart_cfg_reg;
	wire [31:0] uart_flag_reg;
    reg [31:0] uart_ie_reg;
	reg [31:0] uart_tx_req_reg;
	reg [31:0] uart_rx_req_reg;
    
    wire [31:0] uart_tx_data_count;
    wire [31:0] uart_rx_data_count;

	//
	wire uart_tx_meet_req_flag;
	wire uart_rx_meet_req_flag;

	assign uart_tx_meet_req_flag = ((FIFO_DEPTH - uart_tx_data_count) > uart_tx_req_reg)? 1'b1: 1'b0;
	assign uart_rx_meet_req_flag = (uart_rx_data_count >= uart_rx_req_reg)? 1'b1: 1'b0;
    
    localparam REG_UART_CTRL = 0;
    localparam REG_UART_IE = 1;
	localparam REG_UART_INT_E = 2;
	localparam REG_UART_INT_D = 3;
    localparam REG_UART_FLAG = 4;
	localparam REG_UART_TX_REQ = 5;
	localparam REG_UART_RX_REQ = 6;
    localparam REG_UART_TX_DATA_CNT = 7;
    localparam REG_UART_RX_DATA_CNT = 8;
    localparam REG_UART_TX = 9;
    localparam REG_UART_RX = 10;

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 3;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 16

	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      uart_cfg_reg <= 0;
	      uart_ie_reg <= 0;
		  uart_tx_req_reg <= 0;
		  uart_rx_req_reg <= 0;
	      uart_tx_valid <= 1'b0;
	      uart_tx_data <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        uart_tx_valid <= 1'b0;
	        
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          REG_UART_CTRL: begin
                  if (~S_AXI_WDATA[31] | ~uart_cfg_reg[31]) begin
					uart_cfg_reg[26:0] <= S_AXI_WDATA[26:0];
				  end 
                  uart_cfg_reg[31] <= S_AXI_WDATA[31];
	          end
              REG_UART_IE:
	            begin
	              uart_ie_reg <= S_AXI_WDATA[3:0];
	            end 
			  REG_UART_INT_E:
	            begin
	              uart_ie_reg <= uart_ie_reg | S_AXI_WDATA[3:0];
	            end 
			  REG_UART_INT_D:
	            begin
	              uart_ie_reg <= uart_ie_reg & {28'b1 ,~S_AXI_WDATA[3:0]};
	            end 
			  REG_UART_TX_REQ:
	            begin
	              uart_tx_req_reg <= S_AXI_WDATA;
	            end 
			  REG_UART_RX_REQ:
	            begin
	              uart_rx_req_reg <= S_AXI_WDATA;
	            end 
	          REG_UART_TX:
	            begin
	              uart_tx_data <= S_AXI_WDATA[15:0];
	              uart_tx_valid <= 1'b1;
	            end 
			  default:
			    begin
				  uart_cfg_reg[26] <= 1'b0;
				end
	          
	        endcase
	      end
	  end
	end  

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        REG_UART_CTRL   : reg_data_out <= uart_cfg_reg;
	        REG_UART_IE   : reg_data_out <= uart_ie_reg;
	        REG_UART_FLAG   : reg_data_out <= uart_flag_reg;
			REG_UART_TX_REQ   : reg_data_out <= uart_tx_req_reg;
			REG_UART_RX_REQ   : reg_data_out <= uart_rx_req_reg;
	        REG_UART_TX_DATA_CNT: reg_data_out <= uart_tx_data_count;
	        REG_UART_RX_DATA_CNT: reg_data_out <= uart_rx_data_count;
	        REG_UART_TX   : reg_data_out <= uart_tx_data;
	        REG_UART_RX   : reg_data_out <= uart_rx_data;
	        

	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	      uart_rx_ready <= 1'b0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	          
	          if ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB]  == REG_UART_RX) begin
	            uart_rx_ready <= 1'b1;
	          end else begin
	            uart_rx_ready <= 1'b0;
	          end
	        end   
	    end
	end   

	// Add user logic here
        assign irq = (uart_ie_reg[0] & uart_rx_valid) |
					 (uart_ie_reg[1] & uart_tx_ready) |
					 (uart_ie_reg[2] & uart_rx_meet_req_flag) |
					 (uart_ie_reg[3] & uart_tx_meet_req_flag);
        assign m_axis_uart_tdata = uart_tx_data;
        assign m_axis_uart_tvalid = uart_tx_valid;
        assign uart_tx_ready = m_axis_uart_tready;
        
        assign m_axis_uart_cfg_tdata = uart_cfg_reg[23:0];
        assign m_axis_uart_cfg_tvalid = 1'b1;
        assign uart_cfg_ready = m_axis_uart_cfg_tready;
        
        assign uart_rx_data = s_axis_uart_tdata;
        assign uart_rx_valid = s_axis_uart_tvalid;
		assign uart_rx_user = s_axis_uart_tuser;
        assign s_axis_uart_tready = uart_rx_ready;
        
		assign uart_flag_reg = {
			22'b0,
			uart_tx_meet_req_flag,
			uart_tx_ready,
			5'b0,
			uart_rx_meet_req_flag,
			uart_rx_user,
			uart_rx_valid
			};
        
    wire rts;
    
    assign rtsn = ~rts;

    axis_uart_v1_0# (
        .ACLK_FREQ_HZ(ACLK_FREQ_HZ),
        .BAUDRATE(BAUDRATE),
        .PARITY(PARITY), 			/* 0(none), 1(even), 2(odd), 3(mark), 4(space) */
        .BYTE_SIZE(BYTE_SIZE), 		/* Byte Size (16 max) */
        .STOP_BITS(STOP_BITS), 		/* 0(one stop), 1(two stops) */
        .FIFO_DEPTH(FIFO_DEPTH),		/* FIFO Depth */
        .FLOW_CONTROL(0),		/* RTS/CTS */
        .DYNAMIC_CONFIG(1)
    )
    axis_uart_inst
    (
        .aclk(S_AXI_ACLK),
        .aresetn(S_AXI_ARESETN & ~uart_cfg_reg[26]),
        /* Dynamic Configuration */				/* Active when DYNAMIC_CONFIG == 1 */
        /* bits: prescaler = [15:0], parity = [18:16], byte_size <= [22:19], stop_bits = [23], rx_en = [24], tx_en = [25], reset = [26] */
        .s_axis_config_tdata(m_axis_uart_cfg_tdata),	
        .s_axis_config_tvalid(m_axis_uart_cfg_tvalid),
        .s_axis_config_tready(m_axis_uart_cfg_tready),
        /* AXI-Stream Interface (Slave) */
        .s_axis_tdata(m_axis_uart_tdata),
        .s_axis_tvalid(m_axis_uart_tvalid),
        .s_axis_tready(m_axis_uart_tready),
        /* AXI-Stream Interface (Master) */
        .m_axis_tdata(s_axis_uart_tdata),
        .m_axis_tuser(s_axis_uart_tuser),				/* Parity Error */
        .m_axis_tvalid(s_axis_uart_tvalid),
        .m_axis_tready(s_axis_uart_tready),
        //
        .tx_data_count(uart_tx_data_count),
        .rx_data_count(uart_rx_data_count),
        // UART Port
        .tx(tx),
        .rx(rx),
        .rts(),
        .cts(1'b0)
    );
	// User logic ends

	endmodule
