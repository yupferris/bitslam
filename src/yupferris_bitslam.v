`default_nettype none

module yupferris_bitslam(
    input [7:0] io_in,
    output [7:0] io_out
);

    wire clk = io_in[0];

    wire addr_data_sel = io_in[1];
    wire write_addr = ~addr_data_sel;
    wire write_data = addr_data_sel;
    wire [5:0] addr_data = io_in[7:2];
    wire [5:0] data = addr_data;

    reg [5:0] addr;

    always @(posedge clk) begin
        if (write_addr)
            addr <= addr_data;
    end

    reg [5:0] max_clk_div_counter;

    always @(posedge clk) begin
        if (write_data && addr == 5'h00)
            max_clk_div_counter <= data;
    end

    reg [5:0] clk_div_counter;
    wire tick = clk_div_counter >= max_clk_div_counter;

    always @(posedge clk) begin
        if (tick) begin
            clk_div_counter <= 6'h00;
        end
        else begin
            clk_div_counter <= clk_div_counter + 6'h01;
        end
    end

    reg [2:0] lfsr_tap_mask;

    always @(posedge clk) begin
        if (write_data && addr == 5'h01)
            lfsr_tap_mask <= data[2:0];
    end

    reg [7:0] lfsr;
    wire tap3 = lfsr[3] & lfsr_tap_mask[0];
    wire tap6 = lfsr[6] & lfsr_tap_mask[1];
    wire tap7 = lfsr[7] & lfsr_tap_mask[2];

    always @(posedge clk) begin
        if (tick) begin
            if (lfsr == 8'h00) begin
                lfsr <= 8'h01;
            end
            else begin
                lfsr <= {lfsr[6:0], tap3 ^ tap6 ^ tap7};
            end
        end
    end

    // TODO: Some kind of volume control
    assign io_out = {7'h00, lfsr[0]};

    // TODO: More voices?

endmodule
