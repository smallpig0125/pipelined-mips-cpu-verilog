module pipeline_ID_EX( clk, rst, i_memtoreg, i_regwrite, i_memread, i_memwrite, i_alusrc, i_regdst, i_shift, i_opcode, i_func, i_data1, i_data2, i_imm, i_rs, i_rt, i_rd, i_shamt,
                            o_memtoreg, o_regwrite, o_memread, o_memwrite, o_alusrc, o_regdst, o_shift, o_opcode, o_func, o_data1, o_data2, o_imm, o_rs, o_rt, o_rd, o_shamt);

input clk, rst;

input i_memtoreg, i_regwrite, i_memread, i_memwrite, i_alusrc, i_regdst, i_shift;
output o_memtoreg, o_regwrite, o_memread, o_memwrite, o_alusrc, o_regdst, o_shift;
reg o_memtoreg, o_regwrite, o_memread, o_memwrite, o_alusrc, o_regdst, o_shift;
    
input [5:0] i_func;
input [1:0] i_opcode;
output [5:0] o_func;
output [1:0] o_opcode;
reg [5:0] o_func;
reg [1:0] o_opcode;

input [31:0] i_data1, i_data2, i_imm;
output [31:0] o_data1, o_data2, o_imm;
reg [31:0] o_data1, o_data2, o_imm;

input [4:0] i_rs, i_rt, i_rd, i_shamt;
output [4:0] o_rs, o_rt, o_rd, o_shamt;
reg [4:0] o_rs, o_rt, o_rd, o_shamt;

    always @( posedge clk )
    begin
        if ( rst )
        begin
o_memtoreg <= 1'b0;
            o_regwrite <= 1'b0;
            o_memread <= 1'b0;
            o_memwrite <= 1'b0;
            o_alusrc <= 1'b0;
            o_regdst <= 1'b0;
            o_shift <= 1'b0;
            o_opcode <= 2'd0;
            o_func <= 6'd0;
            o_data1 <= 32'd0;
            o_data2 <= 32'd0;
            o_imm <= 32'd0;
            o_shamt <= 5'd0;
            o_rs <= 5'd0;
            o_rt <= 5'd0;
            o_rd <= 5'd0;
        end
        else
        begin
o_memtoreg <= i_memtoreg;
            o_regwrite <= i_regwrite;
            o_memread <= i_memread;
            o_memwrite <= i_memwrite;
            o_alusrc <= i_alusrc;
            o_regdst <= i_regdst;
            o_shift <= i_shift;
            o_opcode <= i_opcode;
            o_func <= i_func;
            o_data1 <= i_data1;
            o_data2 <= i_data2;
            o_imm <= i_imm;
            o_shamt <= i_shamt;
            o_rs <= i_rs;
            o_rt <= i_rt;
            o_rd <= i_rd;
        end
    end

endmodule