module pipeline_EX_MEM(clk, rst, i_memtoreg, i_regwrite, i_memread, i_memwrite, i_alu, i_data2, i_dst,
                            o_memtoreg, o_regwrite, o_memread, o_memwrite, o_alu, o_data2, o_dst);

input clk, rst;
  

input i_memtoreg, i_regwrite;
output o_memtoreg, o_regwrite;
reg o_memtoreg, o_regwrite;
  
    // MEM stage ctrl
input i_memread, i_memwrite;
output o_memread, o_memwrite;
reg o_memread, o_memwrite;
    
    // data transfer
input [31:0] i_alu, i_data2;
input [4:0] i_dst;
output [31:0] o_alu, o_data2;
output [4:0] o_dst;
reg [31:0] o_alu, o_data2;
reg [4:0] o_dst;
    
    always @( posedge clk  )
    begin
        if ( rst )
        begin
o_memtoreg <= 1'b0;
                o_regwrite <= 1'b0;
                o_memread <= 1'b0;
                o_memwrite <= 1'b0;
                o_alu <= 32'd0;
                o_data2 <= 32'd0;
                o_dst <= 5'd0;
        end
        else
        begin
o_memtoreg <= i_memtoreg;
                o_regwrite <= i_regwrite;
                o_memread <= i_memread;
                o_memwrite <= i_memwrite;
                o_alu <= i_alu;
                o_data2 <= i_data2;
                o_dst <= i_dst;
        end
    end
endmodule