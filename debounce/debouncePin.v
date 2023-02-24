module DebouncePin #(
    parameter integer DEBOUNCE_TIME = 12000
) (
    input clk,
    input areset_n,
    input din,
    output reg dout
);

    reg [15:0] cnt = DEBOUNCE_TIME - 1;
    reg din_1 = 1'b1;
    reg din_2 = 1'b1;
    always @(posedge clk or negedge areset_n) begin
        if (~reset_n) begin
            din_1 <= 1'b1;
            din_2 <= 1'b1;
            dout <= 1'b1;
            cnt <= DEBOUNCE_TIME - 1;
        end else begin
            din_1 <= din;
            din_2 <= din_1;

            if (dout != din_2) begin
                if (cnt == 0) dout <= din_2;
                else cnt <= cnt -1;
            end else begin
                cnt <= DEBOUNCE_TIME - 1;
            end


        end
    end
    
endmodule