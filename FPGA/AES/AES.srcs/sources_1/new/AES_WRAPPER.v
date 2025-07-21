module AES_WRAPPER (
    input clk,
    input rst_n,
    input enable,                  // High for 16 cycles to input plain_text, then 16 cycles for key
    input [7:0] data_in,           // Serial input: plaintext first, then key
    output reg [7:0] data_out,     // Serial output: cipher_text bytes
    output reg valid               // High when data_out is valid
);

    reg [7:0] plain_buf [0:15];
    reg [7:0] key_buf   [0:15];
    reg [4:0] sample_count;
    reg [4:0] output_count;
    reg input_phase;               // 0 = plaintext, 1 = key
    reg aes_enable;
    wire aes_done;
    wire [127:0] cipher_out;

    // Input Serial to Parallel
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sample_count <= 0;
            input_phase <= 0;
            aes_enable <= 0;
            for (integer i = 0; i < 16; i = i + 1) begin
                plain_buf[i] <= 0;
                key_buf[i]   <= 0;
            end
        end else if (enable) begin
            if (!input_phase) begin
                plain_buf[sample_count] <= data_in;
            end else begin
                key_buf[sample_count] <= data_in;
            end
            sample_count <= sample_count + 1;

            if (sample_count == 15) begin
                if (!input_phase) begin
                    input_phase <= 1;
                    sample_count <= 0;
                end else begin
                    aes_enable <= 1'b1;  // Trigger AES after last key byte
                end
            end
        end else begin
            sample_count <= 0;
            aes_enable <= 0;
            input_phase <= 0;
        end
    end

    // Instantiate AES module
    AES aes_inst (
        .clk(clk),
        .rst_n(rst_n),
        .enable(aes_enable),
        .plain_text({plain_buf[0], plain_buf[1], plain_buf[2], plain_buf[3],
                     plain_buf[4], plain_buf[5], plain_buf[6], plain_buf[7],
                     plain_buf[8], plain_buf[9], plain_buf[10], plain_buf[11],
                     plain_buf[12], plain_buf[13], plain_buf[14], plain_buf[15]}),
        .key({key_buf[0], key_buf[1], key_buf[2], key_buf[3],
              key_buf[4], key_buf[5], key_buf[6], key_buf[7],
              key_buf[8], key_buf[9], key_buf[10], key_buf[11],
              key_buf[12], key_buf[13], key_buf[14], key_buf[15]}),
        .done(aes_done),
        .cipher_text(cipher_out)
    );

    // Output Parallel to Serial
    reg [7:0] cipher_buf [0:15];
    reg valid_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_count <= 0;
            data_out <= 0;
            valid_reg<=0;
            for (integer i = 0; i < 16; i = i + 1) begin
                cipher_buf[i] <= 0;
            end
        end else if (aes_done || valid_reg) begin
            if (aes_done) begin
                cipher_buf[0]  <= cipher_out[127:120];
                cipher_buf[1]  <= cipher_out[119:112];
                cipher_buf[2]  <= cipher_out[111:104];
                cipher_buf[3]  <= cipher_out[103:96];
                cipher_buf[4]  <= cipher_out[95:88];
                cipher_buf[5]  <= cipher_out[87:80];
                cipher_buf[6]  <= cipher_out[79:72];
                cipher_buf[7]  <= cipher_out[71:64];
                cipher_buf[8]  <= cipher_out[63:56];
                cipher_buf[9]  <= cipher_out[55:48];
                cipher_buf[10] <= cipher_out[47:40];
                cipher_buf[11] <= cipher_out[39:32];
                cipher_buf[12] <= cipher_out[31:24];
                cipher_buf[13] <= cipher_out[23:16];
                cipher_buf[14] <= cipher_out[15:8];
                cipher_buf[15] <= cipher_out[7:0];
                //output_count <= output_count+1;
                valid_reg <= 1'b1;
            end else begin
                data_out <= cipher_buf[output_count];
                output_count <= output_count + 1;
                if (output_count == 15) begin
                    valid_reg <= 0;
                end
            end
        end
    end
    always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
    valid<=0;
    end
    else begin
        valid<=valid_reg;
    end
    
    end
endmodule
