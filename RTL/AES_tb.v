`timescale 1ns/1ps

module AES_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg enable;
    reg [127:0] plain_text;
    reg [127:0] key;

    // Outputs
    wire done;
    wire [127:0] cipher_text;

    // Instantiate the AES module
    AES dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .plain_text(plain_text),
        .key(key),
        .done(done),
        .cipher_text(cipher_text)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("---- AES Testbench Start ----");

        // Initialize inputs
        rst_n = 0;
        enable = 0;
        plain_text = 128'h54776F204F6E65204E696E652054776F; // "Two One Nine Two"
        key        = 128'h5468617473206D79204B756E67204675; // "Thats my Kung Fu"

        // Wait for 2 clocks
        #12;
        rst_n = 1;

        // Start AES operation
        #10;
        enable = 1;
  
        // Wait until done signal is asserted
        #400;

        // Display the ciphertext
        $display("Cipher Text = %h", cipher_text);

        // Stop simulation
        #10;
        $display("---- AES Testbench End ----");
        $stop;
    end

endmodule

