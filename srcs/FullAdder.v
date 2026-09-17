`timescale 1ns/1ns
module FullAdder(A, B, Cin, Cout, Sum);
    input A, B, Cin;
    output Cout, Sum;
    
    wire abXOR;
    wire abOR; 
    wire abAND;
    wire carry_temp;
    
    assign abXOR = A ^ B;
    assign Sum = Cin ^ abXOR;
    assign abOR  = A | B;
    assign abAND = A & B;
    assign carry_temp = abOR & Cin;
    assign Cout = carry_temp | abAND;
endmodule
