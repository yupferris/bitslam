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

    // TODO: Replace with parameterizeable LFSR for different waveforms
    reg [7:0] phase;

    always @(posedge clk) begin
        if (tick)
            phase <= phase + 8'h01;
    end

    // TODO: Some kind of volume control
    assign io_out = {7'h00, phase[7]};

    // TODO: More voices?

endmodule
