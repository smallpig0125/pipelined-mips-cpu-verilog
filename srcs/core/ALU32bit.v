    `timescale 1ns/1ns
    module ALU32bit(
        input  wire [31:0] dataA,
        input  wire [31:0] dataB,
        input  wire [5:0]  Signal,
        input  wire        reset,
        output wire [31:0] dataOut
    );

        wire [30:0] carry;
        wire [31:0] sum;
        wire overflow;

        ALU1bit alu0 (.dataA(dataA[0]), .dataB(dataB[0]), .Cin((Signal == 6'b100010)), .Signal(Signal), .Result(sum[0]), .Cout(carry[0]));
        ALU1bit alu1 (.dataA(dataA[1]), .dataB(dataB[1]), .Cin(carry[0]), .Signal(Signal), .Result(sum[1]), .Cout(carry[1]));
        ALU1bit alu2 (.dataA(dataA[2]), .dataB(dataB[2]), .Cin(carry[1]), .Signal(Signal), .Result(sum[2]), .Cout(carry[2]));
        ALU1bit alu3 (.dataA(dataA[3]), .dataB(dataB[3]), .Cin(carry[2]), .Signal(Signal), .Result(sum[3]), .Cout(carry[3]));
        ALU1bit alu4 (.dataA(dataA[4]), .dataB(dataB[4]), .Cin(carry[3]), .Signal(Signal), .Result(sum[4]), .Cout(carry[4]));
        ALU1bit alu5 (.dataA(dataA[5]), .dataB(dataB[5]), .Cin(carry[4]), .Signal(Signal), .Result(sum[5]), .Cout(carry[5]));
        ALU1bit alu6 (.dataA(dataA[6]), .dataB(dataB[6]), .Cin(carry[5]), .Signal(Signal), .Result(sum[6]), .Cout(carry[6]));
        ALU1bit alu7 (.dataA(dataA[7]), .dataB(dataB[7]), .Cin(carry[6]), .Signal(Signal), .Result(sum[7]), .Cout(carry[7]));
        ALU1bit alu8 (.dataA(dataA[8]), .dataB(dataB[8]), .Cin(carry[7]), .Signal(Signal), .Result(sum[8]), .Cout(carry[8]));
        ALU1bit alu9 (.dataA(dataA[9]), .dataB(dataB[9]), .Cin(carry[8]), .Signal(Signal), .Result(sum[9]), .Cout(carry[9]));
        ALU1bit alu10 (.dataA(dataA[10]), .dataB(dataB[10]), .Cin(carry[9]), .Signal(Signal), .Result(sum[10]), .Cout(carry[10]));
        ALU1bit alu11 (.dataA(dataA[11]), .dataB(dataB[11]), .Cin(carry[10]), .Signal(Signal), .Result(sum[11]), .Cout(carry[11]));
        ALU1bit alu12 (.dataA(dataA[12]), .dataB(dataB[12]), .Cin(carry[11]), .Signal(Signal), .Result(sum[12]), .Cout(carry[12]));
        ALU1bit alu13 (.dataA(dataA[13]), .dataB(dataB[13]), .Cin(carry[12]), .Signal(Signal), .Result(sum[13]), .Cout(carry[13]));
        ALU1bit alu14 (.dataA(dataA[14]), .dataB(dataB[14]), .Cin(carry[13]), .Signal(Signal), .Result(sum[14]), .Cout(carry[14]));
        ALU1bit alu15 (.dataA(dataA[15]), .dataB(dataB[15]), .Cin(carry[14]), .Signal(Signal), .Result(sum[15]), .Cout(carry[15]));
        ALU1bit alu16 (.dataA(dataA[16]), .dataB(dataB[16]), .Cin(carry[15]), .Signal(Signal), .Result(sum[16]), .Cout(carry[16]));
        ALU1bit alu17 (.dataA(dataA[17]), .dataB(dataB[17]), .Cin(carry[16]), .Signal(Signal), .Result(sum[17]), .Cout(carry[17]));
        ALU1bit alu18 (.dataA(dataA[18]), .dataB(dataB[18]), .Cin(carry[17]), .Signal(Signal), .Result(sum[18]), .Cout(carry[18]));
        ALU1bit alu19 (.dataA(dataA[19]), .dataB(dataB[19]), .Cin(carry[18]), .Signal(Signal), .Result(sum[19]), .Cout(carry[19]));
        ALU1bit alu20 (.dataA(dataA[20]), .dataB(dataB[20]), .Cin(carry[19]), .Signal(Signal), .Result(sum[20]), .Cout(carry[20]));
        ALU1bit alu21 (.dataA(dataA[21]), .dataB(dataB[21]), .Cin(carry[20]), .Signal(Signal), .Result(sum[21]), .Cout(carry[21]));
        ALU1bit alu22 (.dataA(dataA[22]), .dataB(dataB[22]), .Cin(carry[21]), .Signal(Signal), .Result(sum[22]), .Cout(carry[22]));
        ALU1bit alu23 (.dataA(dataA[23]), .dataB(dataB[23]), .Cin(carry[22]), .Signal(Signal), .Result(sum[23]), .Cout(carry[23]));
        ALU1bit alu24 (.dataA(dataA[24]), .dataB(dataB[24]), .Cin(carry[23]), .Signal(Signal), .Result(sum[24]), .Cout(carry[24]));
        ALU1bit alu25 (.dataA(dataA[25]), .dataB(dataB[25]), .Cin(carry[24]), .Signal(Signal), .Result(sum[25]), .Cout(carry[25]));
        ALU1bit alu26 (.dataA(dataA[26]), .dataB(dataB[26]), .Cin(carry[25]), .Signal(Signal), .Result(sum[26]), .Cout(carry[26]));
        ALU1bit alu27 (.dataA(dataA[27]), .dataB(dataB[27]), .Cin(carry[26]), .Signal(Signal), .Result(sum[27]), .Cout(carry[27]));
        ALU1bit alu28 (.dataA(dataA[28]), .dataB(dataB[28]), .Cin(carry[27]), .Signal(Signal), .Result(sum[28]), .Cout(carry[28]));
        ALU1bit alu29 (.dataA(dataA[29]), .dataB(dataB[29]), .Cin(carry[28]), .Signal(Signal), .Result(sum[29]), .Cout(carry[29]));
        ALU1bit alu30 (.dataA(dataA[30]), .dataB(dataB[30]), .Cin(carry[29]), .Signal(Signal), .Result(sum[30]), .Cout(carry[30]));
        ALU1bit alu31 (.dataA(dataA[31]), .dataB(dataB[31]), .Cin(carry[30]), .Signal(Signal), .Result(sum[31]), .Cout(overflow));

        wire slt = ( dataA < dataB ) ? 1 : 0;
        wire [31:0] slt_result = {31'b0, slt};
        assign dataOut = reset ? 32'b0 :
                        (Signal == 6'b101010) ? slt_result : 
                        sum;
    

    endmodule
