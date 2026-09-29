module pos_edge_detector (
    input wire clk,      // Clock signal
    input wire rst,      // Active-high synchronous reset
    input wire sig_in,   // Input signal to monitor
    output wire edge_out // High for 1 cycle on a rising edge
);

    reg sig_dly; // Stores the delayed version of the signal

    always @(posedge clk) begin
        if (rst) begin
            sig_dly <= 1'b0;
        end else begin
            sig_dly <= sig_in;
        end
    end

    // High only when current signal is 1 and previous signal was 0
    assign edge_out = sig_in & ~sig_dly;

endmodule


module neg_edge_detector (
    input wire clk,
    input wire rst,
    input wire sig_in,
    output wire edge_out
);

    reg sig_dly;

    always @(posedge clk) begin
        if (rst) begin
            sig_dly <= 1'b0;
        end else begin
            sig_dly <= sig_in;
        end
    end

    // High only when current signal is 0 and previous signal was 1
    assign edge_out = ~sig_in & sig_dly;

endmodule

module any_edge_detector (
    input wire clk,
    input wire rst,
    input wire sig_in,
    output wire edge_out
);

    reg sig_dly;

    always @(posedge clk) begin
        if (rst) begin
            sig_dly <= 1'b0;
        end else begin
            sig_dly <= sig_in;
        end
    end

    // High when current signal differs from previous signal
    assign edge_out = sig_in ^ sig_dly;

endmodule
