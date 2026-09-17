`timescale 1ns/1ns
module ALU1bit(
    input  wire dataA,
    input  wire dataB,
    input  wire Cin,
    input  wire [5:0] Signal,
    output wire Result,
    output wire Cout
);

    wire and_res = dataA & dataB;
    wire or_res  = dataA | dataB;
    wire sum_result;
    wire sum_cout;

    wire B_check = (Signal == 6'b100010) ? ~dataB : dataB;

    
    FullAdder fa (
        .A   (dataA),
        .B   (B_check),
        .Cin (Cin), 
        .Sum (sum_result),
        .Cout(sum_cout)
    );

    assign Result = (Signal == 6'b100100) ? and_res :
                    (Signal == 6'b100101) ? or_res  :
                    (Signal == 6'b100000 || Signal == 6'b001001) ? sum_result :
                    (Signal == 6'b100010) ? sum_result :
                    (Signal == 6'b101010) ? sum_result :
                    1'b0;

    assign Cout = sum_cout;

endmodule
