`timescale 1ns/1ns
module TotalALU(
    input clk,
    input reset,
    input [31:0] dataA,
    input [31:0] dataB,
    input [5:0] Signal,
    input [1:0] aluop,
    output [31:0] Output
);

// --- Internal signal wires ---
wire [5:0] SignaltoALU;
wire [5:0] SignaltoSHT;
wire [5:0] SignaltoDIV;
wire [5:0] SignaltoMUX;

wire [31:0] ALUOut, ShifterOut, HiOut, LoOut;
wire [63:0] DivAns;
wire [31:0] dataOut;

// --- Instantiate updated ALUControl ---
ALUControl ALUControl_inst (
    .clk(clk),
    .rst(reset),
    .Signal(Signal),
    .aluop(aluop),
    .SignaltoALU(SignaltoALU),
    .SignaltoSHT(SignaltoSHT),
    .SignaltoDIV(SignaltoDIV),
    .SignaltoMUX(SignaltoMUX)
);

// --- ALU operation unit ---
ALU32bit ALU (
    .dataA(dataA),
    .dataB(dataB),
    .Signal(SignaltoALU),
    .reset(reset),
    .dataOut(ALUOut)
);

// --- Divider unit ---
Divider Divider (
    .clk(clk),
    .dataA(dataA),
    .dataB(dataB),
    .Signal(SignaltoDIV),
    .dataOut(DivAns),
    .reset(reset)
);

// --- Shifter unit ---
Shifter Shifter (
    .dataA(dataA),
    .dataB(dataB),
    .Signal(SignaltoSHT),
    .dataOut(ShifterOut),
    .reset(reset)
);

// --- HiLo register unit ---
HiLo HiLo (
    .clk(clk),
    .DivAns(DivAns),
    .HiOut(HiOut),
    .LoOut(LoOut),
    .reset(reset)
);

// --- MUX to select final output based on control ---
MUX MUX (
    .ALUOut(ALUOut),
    .HiOut(HiOut),
    .LoOut(LoOut),
    .Shifter(ShifterOut),
    .Signal(SignaltoMUX),
    .dataOut(dataOut)
);

// --- Output assignment ---
assign Output = dataOut;

endmodule
