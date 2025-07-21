//  Module: KEY_EXPANSION
//
module KEY_EXPANSION
   (
    input clk , 
    input rst_n,
    input en,
    input [3:0]round,
    input [127:0]key_in,
    output reg [127:0] key_out,
    output reg done 
    );

    reg [31:0] rcon ;
    wire [31:0] w0,w1,w2,w3;

    /*make instanstiate for sbox*/
    wire [31:0] S_BOX_out;
    S_BOX S_BOX_KEY_EXPANSION
    (
         .word_in({key_in[23:0],key_in[31:24]}),  
         .word_out(S_BOX_out)
    );

    /*update w*/

    assign w0 = S_BOX_out ^ rcon ^ key_in[127:96];
    assign w1 = w0 ^ key_in[95:64];
    assign w2 = w1 ^ key_in[63:32];
    assign w3 = w2 ^ key_in[31:0];
    /*rcon always block*/
    always @(*) begin
    case(round)
    4'h1: rcon=32'h01000000;
    4'h2: rcon=32'h02000000;
    4'h3: rcon=32'h04000000;
    4'h4: rcon=32'h08000000;
    4'h5: rcon=32'h10000000;
    4'h6: rcon=32'h20000000;
    4'h7: rcon=32'h40000000;
    4'h8: rcon=32'h80000000;
    4'h9: rcon=32'h1b000000;
    4'ha: rcon=32'h36000000;
    default: rcon=32'h00000000;
  endcase
end 

always @(posedge clk , negedge rst_n)begin
    if(!rst_n)begin
        key_out<=0;
        done<=0;
    end
    else if (en)begin
        key_out<={w0,w1,w2,w3};
        done<=1;

    end
    else begin
        done<=0;

    end



end 
endmodule: KEY_EXPANSION
