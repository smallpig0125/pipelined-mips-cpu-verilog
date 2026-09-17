module pipeline_IF_ID( clk, rst, i_pc, i_instr, o_pc, o_instr );
input clk, rst;
input [31:0] i_pc, i_instr;
output [31:0] o_pc, o_instr;
reg [31:0] o_pc, o_instr;

    always @( posedge clk )
    begin
        if ( rst )
        begin
            o_pc <= 32'b0;
            o_instr <= 32'b0;
        end
        else 
        begin
            o_pc <= i_pc;
            o_instr <= i_instr;
        end 
    end
endmodule