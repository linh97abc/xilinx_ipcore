`timescale 1ns / 1ps

// Pipeline Block RAM No-Change Mode
// File: rams_sp_nc.v

module rams_sp_nc#
( 
   parameter integer DWIDTH = 16,
   parameter integer ADDRWIDTH = 10
)
(
    input clk,
    input we,
    input en,
    input [ADDRWIDTH-1:0] waddr,
    input [ADDRWIDTH-1:0] raddr, 
    input [DWIDTH-1:0] di,
    output [DWIDTH-1:0] dout1,
    output [DWIDTH-1:0] dout2
);

(* ram_style="block" *) reg	[DWIDTH:0] RAM [2**ADDRWIDTH-1:0];
reg	[DWIDTH-1:0] dout1;
reg	[DWIDTH-1:0] dout2;

wire [ADDRWIDTH-1:0] raddr2;

assign raddr2 = raddr + 1'b1;

always @(posedge clk)
begin
  if (en)
  begin
    if (we) RAM[waddr] <= di;

    dout1 <= RAM[raddr];
    dout2 <= RAM[raddr2];
      

  end
end
endmodule
