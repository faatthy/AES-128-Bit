module MIX_COLUMNS (
    input clk,
    input rst_n,
    input en,
    input [127:0] data_in,
    output reg [127:0] data_mix,
    output reg done
);

    // Byte-level signals for each column
    reg [7:0] byte0, byte1, byte2, byte3;

    // Output bytes for each column
    reg [7:0] col0_out0, col0_out1, col0_out2, col0_out3;
    reg [7:0] col1_out0, col1_out1, col1_out2, col1_out3;
    reg [7:0] col2_out0, col2_out1, col2_out2, col2_out3;
    reg [7:0] col3_out0, col3_out1, col3_out2, col3_out3;

    // Final 128-bit result
    reg [127:0] mix_columns_result;

    // GF(2^8) multiplication by 2
    function [7:0] multiply_by_2;
        input [7:0] b;
        begin
            multiply_by_2 = (b[7] == 1) ? ((b << 1) ^ 8'h1b) : (b << 1);
        end
    endfunction

    // GF(2^8) multiplication by 3
    function [7:0] multiply_by_3;
        input [7:0] b;
        begin
            multiply_by_3 = multiply_by_2(b) ^ b;
        end
    endfunction

    // Combinational logic for MixColumns transformation
    always @(*) begin
        // Column 0 (bytes 127:96)
        byte0 = data_in[127:120];
        byte1 = data_in[119:112];
        byte2 = data_in[111:104];
        byte3 = data_in[103:96];

        col0_out0 = multiply_by_2(byte0) ^ multiply_by_3(byte1) ^ byte2 ^ byte3;
        col0_out1 = byte0 ^ multiply_by_2(byte1) ^ multiply_by_3(byte2) ^ byte3;
        col0_out2 = byte0 ^ byte1 ^ multiply_by_2(byte2) ^ multiply_by_3(byte3);
        col0_out3 = multiply_by_3(byte0) ^ byte1 ^ byte2 ^ multiply_by_2(byte3);

        // Column 1 (bytes 95:64)
        byte0 = data_in[95:88];
        byte1 = data_in[87:80];
        byte2 = data_in[79:72];
        byte3 = data_in[71:64];

        col1_out0 = multiply_by_2(byte0) ^ multiply_by_3(byte1) ^ byte2 ^ byte3;
        col1_out1 = byte0 ^ multiply_by_2(byte1) ^ multiply_by_3(byte2) ^ byte3;
        col1_out2 = byte0 ^ byte1 ^ multiply_by_2(byte2) ^ multiply_by_3(byte3);
        col1_out3 = multiply_by_3(byte0) ^ byte1 ^ byte2 ^ multiply_by_2(byte3);

        // Column 2 (bytes 63:32)
        byte0 = data_in[63:56];
        byte1 = data_in[55:48];
        byte2 = data_in[47:40];
        byte3 = data_in[39:32];

        col2_out0 = multiply_by_2(byte0) ^ multiply_by_3(byte1) ^ byte2 ^ byte3;
        col2_out1 = byte0 ^ multiply_by_2(byte1) ^ multiply_by_3(byte2) ^ byte3;
        col2_out2 = byte0 ^ byte1 ^ multiply_by_2(byte2) ^ multiply_by_3(byte3);
        col2_out3 = multiply_by_3(byte0) ^ byte1 ^ byte2 ^ multiply_by_2(byte3);

        // Column 3 (bytes 31:0)
        byte0 = data_in[31:24];
        byte1 = data_in[23:16];
        byte2 = data_in[15:8];
        byte3 = data_in[7:0];

        col3_out0 = multiply_by_2(byte0) ^ multiply_by_3(byte1) ^ byte2 ^ byte3;
        col3_out1 = byte0 ^ multiply_by_2(byte1) ^ multiply_by_3(byte2) ^ byte3;
        col3_out2 = byte0 ^ byte1 ^ multiply_by_2(byte2) ^ multiply_by_3(byte3);
        col3_out3 = multiply_by_3(byte0) ^ byte1 ^ byte2 ^ multiply_by_2(byte3);

        // Combine all output bytes into final 128-bit result
        mix_columns_result = {
            col0_out0, col0_out1, col0_out2, col0_out3,
            col1_out0, col1_out1, col1_out2, col1_out3,
            col2_out0, col2_out1, col2_out2, col2_out3,
            col3_out0, col3_out1, col3_out2, col3_out3
        };
    end

    // Sequential logic to latch output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_mix <= 128'd0;
            done <= 1'b0;
        end else if (en) begin
            data_mix <= mix_columns_result;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule
