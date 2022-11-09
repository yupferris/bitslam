`default_nettype none

module yupferris_bitslam(
    input [7:0] io_in,
    output [7:0] io_out
);

    wire clk = io_in[0];
    wire reset = io_in[1];

    reg [7:0] counter;

    assign io_out = counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end

endmodule
