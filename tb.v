`timescale 1ns / 1ps

module edge_detector_tb;

    // Inputs to the UUT (Unit Under Test)
    reg clk;
    reg rst;
    reg sig_in;

    // Outputs from the UUTs
    wire pos_edge_detected;
    wire neg_edge_detected;
    wire any_edge_detected;

    // 1. Instantiate the Rising Edge Detector
    pos_edge_detector uut_pos (
        .clk(clk),
        .rst(rst),
        .sig_in(sig_in),
        .edge_out(pos_edge_detected)
    );

    // 2. Instantiate the Falling Edge Detector
    neg_edge_detector uut_neg (
        .clk(clk),
        .rst(rst),
        .sig_in(sig_in),
        .edge_out(neg_edge_detected)
    );

    // 3. Instantiate the Any Edge Detector
    any_edge_detector uut_any (
        .clk(clk),
        .rst(rst),
        .sig_in(sig_in),
        .edge_out(any_edge_detected)
    );

    // Clock Generation: 100MHz clock (10ns period)
    always begin
        #5 clk = ~clk;
    end

    // Stimulus Block
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        sig_in = 0;

        // Hold reset for 2 clock cycles
        #20;
        rst = 0;
        #10;

        // --- Test case 1: Rising Edge ---
        $display("Applying Rising Edge at %t", $time);
        sig_in = 1; 
        #30; // Hold high for 3 clock cycles

        // --- Test case 2: Falling Edge ---
        $display("Applying Falling Edge at %t", $time);
        sig_in = 0;
        #40; // Hold low for 4 clock cycles

        // --- Test case 3: Consecutive pulses ---
        $display("Applying fast toggle at %t", $time);
        sig_in = 1; #10;
        sig_in = 0; #20;

        // --- Test case 4: Reset behavior during a high signal ---
        sig_in = 1; #20;
        rst = 1;    #20;
        rst = 0;    #20;

        // End Simulation
        $display("Simulation Finished.");
        $finish;
    end

    // (Optional) Generate a VCD file for waveform viewing (GTKWave/Vivado)
    initial begin
        $dumpfile("edge_detector_tb.vcd");
        $dumpvars(0, edge_detector_tb);
    end

endmodule
