//  Module: AES
//
module AES
   (
        input clk,
        input rst_n,
        input enable,
        input [127:0]plain_text,
        input [127:0]key,
        output reg done,
        output reg [127:0] cipher_text
    );

    /*blocks enable*/
    reg add_round_en;
    reg shift_en;
    reg mix_en;
    reg key_expansion_en;
    /*blocks done*/
    wire add_round_done;
    wire shift_done;
    wire mix_done;
    wire key_expansion_done;
    /*blocks outputs*/
    wire [127:0]add_round_out;
    wire [127:0]S_BOX_OUT;
    wire [127:0]shift_out;
    wire [127:0]mix_out;
    wire [127:0]key_expansion_out;

    /*blocks data inputs*/
    reg [127:0] add_round_in;
    reg [127:0] add_round_key_in;
    
    reg [127:0] key_save,key_save_reg; /*to save the key after make expansion */
    /*round numbers*/

    reg [3:0] round;
    reg [3:0] round_comp;

    reg [2:0] current_state,next_state;

    localparam  IDLE_STATE              =3'b00,
                Initial_ADD_ROUND_STATE =3'b001,
                ADD_ROUND_STATE         =3'b010,
                SHIFT_STATE             =3'b011,
                MIX_STATE               =3'b100;


    always @(posedge clk ,negedge rst_n)begin

        if(!rst_n)begin
            current_state<=IDLE_STATE;
            round<=0;
            key_save_reg<=0;
        end
        else begin
            current_state<=next_state;
            round<=round_comp;
            key_save_reg<=key_save;
        end
    end

    always @(*)begin
        case(current_state)
        IDLE_STATE:begin
                if(enable)begin
                    next_state=Initial_ADD_ROUND_STATE;
                end
                else begin
                    next_state=IDLE_STATE;
                end

            end
        Initial_ADD_ROUND_STATE:begin
            next_state=SHIFT_STATE;

        end
        ADD_ROUND_STATE:begin
                next_state=SHIFT_STATE;
            end
            SHIFT_STATE:begin
                if(add_round_done)begin
                if(round<10)begin
                    next_state=MIX_STATE;
                end
                else begin
                    next_state=ADD_ROUND_STATE;
                end
            end
        end
        MIX_STATE:begin
            if(shift_done)begin
                next_state=ADD_ROUND_STATE;
            end
        end
    endcase
    end


    /*control signals*/

    always@(*)begin
        case(current_state)
            IDLE_STATE:begin
                add_round_en=0;
                shift_en=0;
                mix_en=0;
                key_expansion_en=0;
                round_comp=0;
                add_round_in=0;
                add_round_key_in=0;
                key_save=0;
            end
            Initial_ADD_ROUND_STATE:begin
                add_round_en=1;
                shift_en=0;
                mix_en=0;
                key_expansion_en=0;
                add_round_in=plain_text;
                add_round_key_in=key;
                round_comp=round+1;
                key_save=key;
            end
            SHIFT_STATE:begin
                if(add_round_done)begin
                    add_round_en=0;
                    shift_en=1;
                    mix_en=0;
                    key_expansion_en=0;
                    if(round>=10)begin
                    key_expansion_en=1;
                    end
            end
        end
            MIX_STATE:begin
                if(shift_done)begin
                    add_round_en=0;
                    shift_en=0;
                    mix_en=1;
                    key_expansion_en=1;
                end

            end
            ADD_ROUND_STATE:begin
                if(key_expansion_done)begin
                    add_round_en=1;
                    shift_en=0;
                    mix_en=0;
                    key_expansion_en=0;
                    add_round_key_in=key_expansion_out;
                    key_save=key_expansion_out;
                    round_comp=round+1;
                    if(round>=10)begin
                        add_round_in=shift_out;
                    end
                    else begin
                        add_round_in=mix_out;
                    end
                end
            end
            default:begin
                add_round_en=0;
                shift_en=0;
                mix_en=0;
                key_expansion_en=0;
                round_comp=0;
                add_round_in=0;
                add_round_key_in=0;
            end
    endcase
    end
 
    /*output always*/
    // Output assignment logic: generate final ciphertext and done signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cipher_text <= 128'b0;
        done <= 0;
    end
    else begin
        // Output final cipher text when final round finishes (round == 11)
        if (round == 11 && add_round_done) begin
            cipher_text <= add_round_out;
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end


/*instantiate*/

SHIFT_ROWS shift_top
    (
         .clk(clk),
         .rst_n(rst_n),
         .en(shift_en),
         .data_in(S_BOX_OUT),
         .data_shift(shift_out),
         .done(shift_done)
    );

     MIX_COLUMNS MIX_TOP (
     .clk(clk),
     .rst_n(rst_n),
     .en(mix_en),
     .data_in(shift_out),
     .data_mix(mix_out),
     .done(mix_done)
    );
S_BOX  S_TOP1
    (
        .word_in(add_round_out[127:96]), 
        .word_out(S_BOX_OUT[127:96])
    );
S_BOX  S_TOP2
    (
        .word_in(add_round_out[95:64]), 
        .word_out(S_BOX_OUT[95:64])
    );
    S_BOX  S_TOP3
    (
        .word_in(add_round_out[63:32]), 
        .word_out(S_BOX_OUT[63:32])
    );
    S_BOX  S_TOP4
    (
        .word_in(add_round_out[31:0]), 
        .word_out(S_BOX_OUT[31:0])
    );
    ADD_ROUND_KEY  ADD_ROUND_TOP(
     .clk(clk),
     .rst_n(rst_n),
     .en(add_round_en),
     .data_in(add_round_in),
     .key_in(add_round_key_in),
     .data_round(add_round_out),
     .done (add_round_done)
    );
    KEY_EXPANSION   EXPANSION_TOP
   (
    .clk(clk) , 
    .rst_n(rst_n),
    .en(key_expansion_en),
    .round(round),
    .key_in(key_save_reg),
    .key_out(key_expansion_out),
    .done(key_expansion_done)
    );
endmodule: AES
