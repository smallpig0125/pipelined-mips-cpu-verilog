module control_single(
    opcode, funct, instr, shamt,
    RegDst, ALUSrc, MemtoReg, RegWrite,
    MemRead, MemWrite, Branch, Jump,
    shift_or_not, ALUOp
);
    input [5:0] opcode, funct;
    input [31:0] instr;
    input [4:0] shamt;

    output RegDst, ALUSrc, MemtoReg, RegWrite;
    output MemRead, MemWrite, Branch, Jump;
    output shift_or_not;
    output [1:0] ALUOp;

    reg RegDst, ALUSrc, MemtoReg, RegWrite;
    reg MemRead, MemWrite, Branch, Jump;
    reg shift_or_not;
    reg [1:0] ALUOp;

    parameter R_FORMAT = 6'd0;
    parameter LW      = 6'd35;
    parameter SW      = 6'd43;
    parameter BEQ     = 6'd4;
    parameter J       = 6'd2;
    parameter JAL     = 6'd3;
    parameter ADDIU   = 6'd9;

    parameter DIVU    = 6'd27;
    parameter MFHI    = 6'd16;
    parameter MFLO    = 6'd18;

    parameter NOTSHIFT = 5'd0;
    parameter NOP = 32'd0;

    always @(opcode or funct or instr or shamt) begin
        case (opcode)
            R_FORMAT: begin
                // NOP 判斷
                if (instr == NOP) begin
                    RegDst = 1'b0; ALUSrc = 1'b0; MemtoReg = 1'b0;
                    RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0;
                    Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b00;
                    shift_or_not = 1'b0;
                end
                // divu 處理
                else if (funct == DIVU) begin
                    RegDst = 1'b0; ALUSrc = 1'b0; MemtoReg = 1'b0;
                    RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0;
                    Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b11;
                    shift_or_not = 1'b0;
                end
                // mfhi / mflo 處理
                else if (funct == MFHI || funct == MFLO) begin
                    RegDst = 1'b1; ALUSrc = 1'b0; MemtoReg = 1'b1;
                    RegWrite = 1'b1; MemRead = 1'b0; MemWrite = 1'b0;
                    Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b11;
                    shift_or_not = 1'b0;
                end
                // 一般 R-type 指令（add, sub, and, or, slt）
                else if (shamt == NOTSHIFT) begin
                    RegDst = 1'b1; ALUSrc = 1'b0; MemtoReg = 1'b1;
                    RegWrite = 1'b1; MemRead = 1'b0; MemWrite = 1'b0;
                    Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b10;
                    shift_or_not = 1'b0;
                end
                // shift 類指令（srl）
                else begin
                    RegDst = 1'b1; ALUSrc = 1'b0; MemtoReg = 1'b1;
                    RegWrite = 1'b1; MemRead = 1'b0; MemWrite = 1'b0;
                    Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b10;
                    shift_or_not = 1'b1;
                end
            end
            LW: begin
                RegDst = 1'b0; ALUSrc = 1'b1; MemtoReg = 1'b0;
                RegWrite = 1'b1; MemRead = 1'b1; MemWrite = 1'b0;
                Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b00;
                shift_or_not = 1'b0;
            end
            SW: begin
                RegDst = 1'b0; ALUSrc = 1'b1; MemtoReg = 1'b0;
                RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b1;
                Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b00;
                shift_or_not = 1'b0;
            end
            BEQ: begin
                RegDst = 1'b0; ALUSrc = 1'b0; MemtoReg = 1'b0;
                RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0;
                Branch = 1'b1; Jump = 1'b0; ALUOp = 2'b01;
                shift_or_not = 1'b0;
            end
            J: begin
                RegDst = 1'b0; ALUSrc = 1'b0; MemtoReg = 1'b0;
                RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0;
                Branch = 1'b0; Jump = 1'b1; ALUOp = 2'b00;
                shift_or_not = 1'b0;
            end
            JAL: begin
                RegDst = 1'b0; ALUSrc = 1'b0; MemtoReg = 1'b0;
                RegWrite = 1'b1; MemRead = 1'b0; MemWrite = 1'b0;
                Branch = 1'b0; Jump = 1'b1; ALUOp = 2'b00;
                shift_or_not = 1'b0;
            end
            ADDIU: begin
                RegDst = 1'b0; ALUSrc = 1'b1; MemtoReg = 1'b0;
                RegWrite = 1'b1; MemRead = 1'b0; MemWrite = 1'b0;
                Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b00;
                shift_or_not = 1'b0;
            end
            default: begin
                $display("control_single unimplemented opcode %d", opcode);
                RegDst = 1'b0; ALUSrc = 1'b0; MemtoReg = 1'b0;
                RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0;
                Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b00;
                shift_or_not = 1'b0;
            end
        endcase
    end
endmodule
