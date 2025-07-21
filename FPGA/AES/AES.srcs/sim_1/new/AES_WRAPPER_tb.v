`timescale 1ns/1ps

module AES_WRAPPER_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg enable;
    reg [7:0] data_in;

    // Outputs
    wire [7:0] data_out;
    wire valid;

    // Instantiate the AES_WRAPPER module
    AES_WRAPPER dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .data_in(data_in),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #1 clk = ~clk;

    reg [7:0] plaintext_array [0:15];
    reg [7:0] key_array [0:15];
    integer i;

    // Stimulus
    initial begin
        $display("---- AES_WRAPPER Testbench Start ----");

        // Initialize inputs
        rst_n = 0;
        enable = 0;
        data_in = 8'h00;

        // Sample plaintext "Two One Nine Two"
        plaintext_array[0]  = 8'h54; // T
        plaintext_array[1]  = 8'h77; // w
        plaintext_array[2]  = 8'h6F; // o
        plaintext_array[3]  = 8'h20; //  
        plaintext_array[4]  = 8'h4F; // O
        plaintext_array[5]  = 8'h6E; // n
        plaintext_array[6]  = 8'h65; // e
        plaintext_array[7]  = 8'h20; //  
        plaintext_array[8]  = 8'h4E; // N
        plaintext_array[9]  = 8'h69; // i
        plaintext_array[10] = 8'h6E; // n
        plaintext_array[11] = 8'h65; // e
        plaintext_array[12] = 8'h20; //  
        plaintext_array[13] = 8'h54; // T
        plaintext_array[14] = 8'h77; // w
        plaintext_array[15] = 8'h6F; // o

        // Sample key "Thats my Kung Fu"
        key_array[0]  = 8'h54; // T
        key_array[1]  = 8'h68; // h
        key_array[2]  = 8'h61; // a
        key_array[3]  = 8'h74; // t
        key_array[4]  = 8'h73; // s
        key_array[5]  = 8'h20; //  
        key_array[6]  = 8'h6D; // m
        key_array[7]  = 8'h79; // y
        key_array[8]  = 8'h20; //  
        key_array[9]  = 8'h4B; // K
        key_array[10] = 8'h75; // u
        key_array[11] = 8'h6E; // n
        key_array[12] = 8'h67; // g
        key_array[13] = 8'h20; //  
        key_array[14] = 8'h46; // F
        key_array[15] = 8'h75; // u

        // Reset sequence
        #12;
        rst_n = 1;

        // Send plaintext bytes (one per clock cycle with enable high)
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            enable = 1;
            data_in = plaintext_array[i];
        end

        // Send key bytes
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            enable = 1;
            data_in = key_array[i];
        end

        // Disable input
        @(posedge clk);
        enable = 0;
        data_in = 8'h00;

        // Wait for valid output and print data
        wait (valid);
        $display("---- Cipher Output ----");
        for (i = 0; i <= 16; i = i + 1) begin
            @(posedge clk);
            if (valid)
                $display("Cipher Byte %0d = %h", i, data_out);
        end

        // End of simulation
        #20;
        $display("---- AES_WRAPPER Testbench End ----");
        $stop;
    end

endmodule
