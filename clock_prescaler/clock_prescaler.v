module clock_prescaler #(
    parameter integer C_PRESCALE = 16,
    parameter integer C_FREQ_HZ = 0
) (
    input aclk,
    input aresetn,

    output wire out_clk
);
    reg r_out_clk = 0;

    function integer clogb2;
    input [31:0]value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
    endfunction

    localparam CNT_DWIDTH = clogb2(C_PRESCALE);

    localparam PERIOD = C_PRESCALE/2 - 1;
    reg [CNT_DWIDTH-1:0] cnt = PERIOD;

    assign out_clk = r_out_clk;

    always @(posedge aclk or negedge aresetn) begin
        if (~aresetn) begin
            r_out_clk <= 0;
            cnt <= PERIOD;
        end else begin
            if (cnt == 0) begin
                r_out_clk <= ~r_out_clk;
                cnt <= PERIOD;
            end else begin
                cnt <= cnt - 1'b1;
            end
        end
    end
endmodule