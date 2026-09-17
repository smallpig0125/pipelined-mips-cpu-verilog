module pipeline_MEM_WB(clk, rst, i_memtoreg, i_regwrite, i_memdata, i_alu, i_dst,
                             o_memtoreg, o_regwrite, o_memdata, o_alu, o_dst);

    // basic need
input clk, rst;
    
    // WB stage ctrl
input i_memtoreg, i_regwrite;
output o_memtoreg, o_regwrite;
reg o_memtoreg, o_regwrite;
    
    // data transfer
input [31:0] i_memdata, i_alu;
input [4:0] i_dst;
output [31:0] o_memdata, o_alu;
output [4:0] o_dst;
reg [31:0] o_memdata, o_alu;
reg [4:0] o_dst;
    
    always @( posedge clk )
    begin
        if ( rst )
        begin
o_memtoreg <= 1'b0;
            o_regwrite <= 1'b0;
            o_memdata <= 32'd0;
            o_alu <= 32'd0;
            o_dst <=5'd0;
        end
        else
        begin
o_memtoreg <= i_memtoreg;
            o_regwrite <= i_regwrite;
            o_memdata <= i_memdata;
            o_alu <= i_alu;
            o_dst <= i_dst;
        end
    end
endmodule