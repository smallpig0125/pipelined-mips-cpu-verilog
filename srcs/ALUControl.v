`timescale 1ns/1ns

module ALUControl (
    input  wire       clk,
    input  wire       rst,
    input  wire [5:0] Signal,
    input  wire [1:0] aluop,
    output reg  [5:0] SignaltoALU,
    output reg  [5:0] SignaltoSHT,
    output reg  [5:0] SignaltoDIV,
    output reg  [5:0] SignaltoMUX
);


  parameter AND = 6'b100100;
  parameter OR  = 6'b100101;
  parameter ADD = 6'b100000;
  parameter SUB = 6'b100010;
  parameter SLT = 6'b101010;
  parameter SRL = 6'b000010;

  parameter DIVU= 6'b011011;
  parameter MFHI= 6'b010000;
  parameter MFLO= 6'b010010;

  parameter ADDIU=6'b001001;
  parameter NOP = 6'b000000;


  reg [5:0] temp;
  reg [6:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        temp <= NOP;
        counter <= 0;
    end else begin
        // ALUOp æ±ºå?? temp ?????§å®¹
        case (aluop)
            2'b00: temp <= ADD; // for lw/sw
            2'b01: temp <= SUB; // for beq
            2'b10: begin
                case (Signal)
                    ADD : temp <= ADD;
                    SUB : temp <= SUB;
                    AND : temp <= AND;
                    OR  : temp <= OR;
                    SLT : temp <= SLT;
                    SRL : temp <= SRL;
                    MFHI: temp <= MFHI;
                    MFLO: temp <= MFLO;
                    DIVU: temp <= DIVU;
                    default: temp <= NOP;
                endcase
            end
            default: temp <= NOP;
        endcase

        if (temp == DIVU) begin
            if (counter < 32)
                counter <= counter + 1;
            else begin
                counter <= 0;
                temp <= NOP; // DIVU çµæ?Ÿå?Œæ???™¤
            end
        end
    end
end


always @(posedge clk or posedge rst) begin
    if (rst) begin
        SignaltoALU <= NOP;
        SignaltoSHT <= NOP;
        SignaltoDIV <= NOP;
        SignaltoMUX <= NOP;
    end else begin
        case (temp)
            ADD, SUB, AND, OR, SLT, ADDIU: begin
                SignaltoALU <= temp;
                SignaltoSHT <= NOP;
                SignaltoDIV <= NOP;
                SignaltoMUX <= temp;
            end
            SRL: begin
                SignaltoALU <= NOP;
                SignaltoSHT <= temp;
                SignaltoDIV <= NOP;
                SignaltoMUX <= temp;
            end
            DIVU: begin
                if (counter < 32) begin
                    SignaltoALU <= NOP;
                    SignaltoSHT <= NOP;
                    SignaltoDIV <= DIVU;
                    SignaltoMUX <= NOP;
                end else begin
                    SignaltoALU <= NOP;
                    SignaltoSHT <= NOP;
                    SignaltoDIV <= NOP;
                    SignaltoMUX <= DIVU;
                end
            end
            MFHI, MFLO: begin
                SignaltoALU <= NOP;
                SignaltoSHT <= NOP;
                SignaltoDIV <= NOP;
                SignaltoMUX <= temp;
            end
            default: begin
                SignaltoALU <= NOP;
                SignaltoSHT <= NOP;
                SignaltoDIV <= NOP;
                SignaltoMUX <= NOP;
            end
        endcase
    end
end


endmodule