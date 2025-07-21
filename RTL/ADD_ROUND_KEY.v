module ADD_ROUND_KEY(
    input clk,rst_n,
    input en,
    input [127:0] data_in,
    input [127:0] key_in,
    output reg [127:0] data_round,
    output reg done 
);

always @(posedge clk , negedge rst_n)begin
    if(!rst_n)begin
        data_round<=0;
        done<=0;
    end
    else if (en)begin
        data_round<=data_in^key_in;
        done<=1;
    end
    else begin
        done<=0;
    end
end

endmodule 