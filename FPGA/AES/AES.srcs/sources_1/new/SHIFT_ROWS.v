//  Module: SHIFT_ROWS
//
module SHIFT_ROWS
    (
        input clk,
        input rst_n,
        input en,
        input [127:0] data_in,
        output reg  [127:0] data_shift,
        output reg done
    );

    reg [31:0] row1,row2,row3,row4;
    always @(posedge clk,negedge rst_n)begin
        if(!rst_n)begin
            data_shift<=0;
            done<=0;


        end
        else if (en)begin
            data_shift<={row1,row2,row3,row4};
            done<=1;

        end
        else begin
            done<=0;
        end


    end

    always@(*)begin

         row1 = {data_in[127:120] ,data_in[87:80] ,data_in[47:40] ,data_in[7:00]} ; 
         row2 = {data_in[95:88] ,data_in[55:48] ,data_in[15:8] ,data_in[103:96]} ; 
         row3 = {data_in[63:56] ,data_in[23:16] ,data_in[111:104] ,data_in[71:64]} ; 
         row4 = {data_in[31:24] ,data_in[119:112] ,data_in[79:72] ,data_in[39:32]} ;



    end

    
endmodule: SHIFT_ROWS
