module mips_single( clk, rst ) ;
    input clk, rst ;

    // instruction bus
    wire[31:0] instr, ID_instr;

    // break out important fields from instruction
    wire [5:0] opcode;
    wire [5:0] funct, EX_funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [4:0] EX_rs, EX_rt, EX_rd, EX_shamt, WN;
    wire [4:0] MEM_WN;
    wire [31:0] MEM_rd;
    wire [31:0] WB_rd;
    wire [31:0] shamt_32;
    wire [15:0] immed;
    wire [31:0] ID_extend_immed, b_offset;
    wire [31:0] EX_extend_immed;
    wire [25:0] jumpoffset;

    // datapath signals
    wire [4:0] rfile_wn;
    wire [31:0] rfile_rd1, rfile_rd2, rfile_wd, regorimmed, alu_a, alu_b, alu_out, MEM_alu_out, WB_alu_out, b_tgt, pc_next,
                pc, IF_pc_incr, ID_pc_incr, jump_addr, branch_addr;
    wire [31:0] EX_rfile_rd1, EX_rfile_rd2;
    wire [31:0] MEM_rfile_rd2;

    // control signals
    wire RegWrite, PCSrc;
    wire ID_RegWrite, Branch, ID_RegDst, ID_MemtoReg, ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_shift_or_not, Zero, Jump;
    wire EX_RegWrite, EX_RegDst, EX_MemtoReg, EX_MemRead, EX_MemWrite, EX_ALUSrc, EX_shift_or_not;
    wire MEM_RegWrite, MEM_MemtoReg, MEM_MemRead, MEM_MemWrite;
    wire WB_MemtoReg;
    wire [1:0] ID_ALUOp;
    wire [1:0] EX_ALUOp;

    wire is_jal;

    // IF{
    reg32 PC( .clk(clk), .rst(rst), .en_reg(1'b1), .d_in(pc_next), .d_out(pc) );
    add32 PC_Plus_4( .a(pc), .b(32'd4), .result(IF_pc_incr) );
    memory InstrMem( .clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr) );
    // }IF

    pipeline_IF_ID pipeline_IF_ID( .clk(clk), .rst(rst), .i_pc(IF_pc_incr), .i_instr(instr), .o_pc(ID_pc_incr), .o_instr(ID_instr) );

    // ID{
    assign opcode = ID_instr[31:26];
    assign rs = ID_instr[25:21];
    assign rt = ID_instr[20:16];
    assign rd = ID_instr[15:11];
    assign shamt = ID_instr[10:6];
    assign funct = ID_instr[5:0];
    assign immed = ID_instr[15:0];
    assign jumpoffset = ID_instr[25:0];

    assign is_jal = (opcode == 6'd3);

    sign_extend SignExt( .immed_in(immed), .ext_immed_out(ID_extend_immed) );
    assign b_offset = ID_extend_immed << 2;
    add32 BRADD( .a(ID_pc_incr), .b(b_offset), .result(b_tgt) ); 
    assign jump_addr = { ID_pc_incr[31:28], jumpoffset <<2 };

    control_single CTL(.opcode(opcode), .funct(funct), .instr(ID_instr), .shamt(shamt), .RegDst(ID_RegDst), .ALUSrc(ID_ALUSrc), .MemtoReg(ID_MemtoReg), 
                       .RegWrite(ID_RegWrite), .MemRead(ID_MemRead), .MemWrite(ID_MemWrite), .Branch(Branch), 
                       .Jump(Jump), .ALUOp(ID_ALUOp), .shift_or_not(ID_shift_or_not));

    wire final_RegWrite;
    wire [4:0] final_wn;
    wire [31:0] final_wd;

    assign final_RegWrite = is_jal ? 1'b1 : RegWrite;
    assign final_wn = is_jal ? 5'd31 : rfile_wn;
    assign final_wd = is_jal ? ID_pc_incr : rfile_wd;

    reg_file RegFile( .clk(clk), .RegWrite(final_RegWrite), .RN1(rs), .RN2(rt), 
                       .WN(final_wn), .WD(final_wd), .RD1(rfile_rd1), .RD2(rfile_rd2) );

    checkEqual EQ( .inputa(rfile_rd1), .inputb(rfile_rd2), .iseq(Zero), .rst(rst) );

    and BR_AND(PCSrc, Branch, Zero);

    mux2 #(32) PCMUX( .sel(PCSrc), .a(IF_pc_incr), .b(b_tgt), .y(branch_addr) );
    jump_mux #(32) JMUX( .j(Jump), .a(branch_addr), .b(jump_addr), .y(pc_next) );
    // }ID

    pipeline_ID_EX pipeline_ID_EX( .clk(clk), .rst(rst), .i_memtoreg(ID_MemtoReg), .i_regwrite(ID_RegWrite), .i_memread(ID_MemRead), .i_memwrite(ID_MemWrite), .i_alusrc(ID_ALUSrc), .i_regdst(ID_RegDst), .i_shift(ID_shift_or_not), .i_opcode(ID_ALUOp), .i_func(funct), .i_data1(rfile_rd1), .i_data2(rfile_rd2), .i_imm(ID_extend_immed), .i_rs(rs), .i_rt(rt), .i_rd(rd), .i_shamt(shamt),
                                               .o_memtoreg(EX_MemtoReg), .o_regwrite(EX_RegWrite), .o_memread(EX_MemRead), .o_memwrite(EX_MemWrite), .o_alusrc(EX_ALUSrc), .o_regdst(EX_RegDst), .o_shift(EX_shift_or_not), .o_opcode(EX_ALUOp), .o_func(EX_funct), .o_data1(EX_rfile_rd1), .o_data2(EX_rfile_rd2), .o_imm(EX_extend_immed), .o_rs(EX_rs), .o_rt(EX_rt), .o_rd(EX_rd), .o_shamt(EX_shamt)) ;
    // EX{

    mux2 #(32) ALUMUX( .sel(EX_ALUSrc), .a(EX_rfile_rd2), .b(EX_extend_immed), .y(regorimmed) );

    mux2 #(32) alua( .sel(EX_shift_or_not), .a(EX_rfile_rd1), .b(regorimmed), .y(alu_a) );

    assign shamt_32 = {27'b0, EX_shamt};

    mux2 #(32) alub( .sel(EX_shift_or_not), .a(regorimmed), .b(shamt_32), .y(alu_b) );

    TotalALU TotalALU( .clk(clk), .reset(rst), .dataA(alu_a), .dataB(alu_b), .Signal(EX_funct), .aluop(EX_ALUOp), .Output(alu_out) );

    mux2 #(5) rtrdMUX( .sel(EX_RegDst), .a(EX_rt), .b(EX_rd), .y(WN) );

    // }EX

    pipeline_EX_MEM pipeline_EX_MEM( .clk(clk), .rst(rst), .i_memtoreg(EX_MemtoReg), .i_regwrite(EX_RegWrite), .i_memread(EX_MemRead), .i_memwrite(EX_MemWrite), .i_alu(alu_out), .i_data2(EX_rfile_rd2), .i_dst(WN),
                                                 .o_memtoreg(MEM_MemtoReg), .o_regwrite(MEM_RegWrite), .o_memread(MEM_MemRead), .o_memwrite(MEM_MemWrite), .o_alu(MEM_alu_out), .o_data2(MEM_rfile_rd2), .o_dst(MEM_WN) );

    // MEM{
    memory DatMem( .clk(clk), .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite), .wd(MEM_rfile_rd2), .addr(MEM_alu_out), .rd(MEM_rd) ); 
    // }MEM

    pipeline_MEM_WB pipeline_MEM_WB( .clk(clk), .rst(rst), .i_memtoreg(MEM_MemtoReg), .i_regwrite(MEM_RegWrite), .i_memdata(MEM_rd), .i_alu(MEM_alu_out), .i_dst(MEM_WN),
                                                 .o_memtoreg(WB_MemtoReg), .o_regwrite(RegWrite), .o_memdata(WB_rd), .o_alu(WB_alu_out), .o_dst(rfile_wn) );

    // WB{
    mux2 #(32) WRMUX( .sel(WB_MemtoReg), .a(WB_rd), .b(WB_alu_out), .y(rfile_wd) );
    // }WB
endmodule
