module DebouncePort #(
    parameter integer C_FREQ_CLK_SAMPLE_HZ = 1000000,
    parameter integer C_DWIDTH = 32,
    parameter integer C_TRIMODE = 1,
    parameter integer C_DEBOUNCE_TIME = 12 // ms
) (
    input clk,
    input sample_clk,
    input reset_n,
    input [C_DWIDTH-1:0] r_gpio_i,
    output [C_DWIDTH-1:0] r_gpio_o,
    output [C_DWIDTH-1:0] r_gpio_t,

    output reg [C_DWIDTH-1:0] l_gpio_i,
    input [C_DWIDTH-1:0] l_gpio_o,
    input [C_DWIDTH-1:0] l_gpio_t
);

    localparam DEBOUNCE_TIME = (C_FREQ_CLK_SAMPLE_HZ/1000) * C_DEBOUNCE_TIME;

    wire [C_DWIDTH-1:0] debounce_out;

    reg [C_DWIDTH-1:0] dout_tmp;

    assign r_gpio_o = (C_TRIMODE==0)? 1'bz: l_gpio_o;
    assign r_gpio_t = (C_TRIMODE==0)? 1'b1: l_gpio_t;

    always @(posedge clk ) begin
        dout_tmp <= debounce_out;
        l_gpio_i <= dout_tmp;
    end



    genvar i;
    generate
        for (i = 0; i < C_DWIDTH; i = i+1) begin
            DebouncePin #(.DEBOUNCE_TIME(DEBOUNCE_TIME))
            debounce_inst(.clk(sample_clk), .areset_n(reset_n), .din(r_gpio_i[i]), .dout(debounce_out[i]));
        end
    endgenerate
    
endmodule