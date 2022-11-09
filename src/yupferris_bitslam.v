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
        if (write_addr) begin
            addr <= addr_data;
        end
    end

    reg [5:0] max_phase;

    always @(posedge clk) begin
        if (write_data && addr == 5'h00) begin
            max_phase <= data;
        end
    end

    reg [7:0] phase;

    assign io_out = phase;

    always @(posedge clk) begin
        if (phase >= max_phase) begin
            phase <= 8'h00;
        end
        else begin
            phase <= phase + 8'h01;
        end
    end

endmodule
