`timescale 1ns/1ns
module MUX( ALUOut, HiOut, LoOut, Shifter, Signal, dataOut );
input [31:0] ALUOut ;
input [31:0] HiOut ;
input [31:0] LoOut ;
input [31:0] Shifter ;
input [5:0] Signal ;
output [31:0] dataOut ;


reg [31:0] temp ;

parameter AND = 6'b100100;
parameter OR  = 6'b100101;
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter SLT = 6'b101010;

parameter SRL = 6'b000010;

parameter DIVU= 6'b011011;
parameter MFHI= 6'b010000;
parameter MFLO= 6'b010010;

parameter addiu=6'b001001;
parameter NOP = 6'b000000;	
parameter beq = 6'b000100;
parameter lw  = 6'b100011;
parameter sw  = 6'b101011;

assign dataOut = (Signal == AND || 
				  Signal == OR || 
				  Signal == ADD || 
				  Signal == SUB || 
				  Signal == SLT ||
				  Signal == addiu) ? ALUOut :
				  (Signal == MFHI) ? HiOut :
				  (Signal == MFLO) ? LoOut :
				  (Signal == SRL) ? Shifter :
				  32'b0;


endmodule