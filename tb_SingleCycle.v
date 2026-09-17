`timescale 1ns/1ns
module tb_SingleCycle();
  reg clk, rst;
  parameter cycle_count = 65;

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin 
    rst = 1'b1;
    // 載入程式記憶體與資料記憶體
    $readmemh("instr_mem.txt", CPU.InstrMem.mem_array);
    $readmemh("data_mem.txt", CPU.DatMem.mem_array);
    // 載入初始暫存器值
    $readmemh("reg.txt", CPU.RegFile.file_array);

    #10;
    rst = 1'b0;
  end

  initial begin
    #(cycle_count * 10)
    $display("%d, End of Simulation\n", $time / 10 - 1);
    $finish;
  end

  always @(posedge clk) begin
    if (CPU.instr !== 32'bx) begin
      $display("%d, PC: %d", $time / 10 - 1, CPU.pc);
      
      if (CPU.opcode == 6'b000000) begin
        $display("%d, wd: %d", $time / 10 - 1, CPU.final_wd);
        // R-type
        case (CPU.funct)
          6'd32: $display("%d, ADD", $time / 10 - 1);
          6'd34: $display("%d, SUB", $time / 10 - 1);
          6'd36: $display("%d, AND", $time / 10 - 1);
          6'd37: $display("%d, OR",  $time / 10 - 1);
          6'd42: $display("%d, SLT", $time / 10 - 1);
          6'd0: begin
            if (CPU.rs == 5'd0 && CPU.rt == 5'd0 && CPU.rd == 5'd0 && CPU.shamt == 5'd0)
              $display("%d, NOP", $time / 10 - 1);
            else
              $display("%d, SLL", $time / 10 - 1);
          end
        endcase
      end
      else begin
        case (CPU.opcode)
          6'd8:   $display("%d, ADDI",  $time / 10 - 1);
          6'd35:  $display("%d, LW",    $time / 10 - 1);
          6'd43:  $display("%d, SW",    $time / 10 - 1);
          6'd4:   $display("%d, BEQ",   $time / 10 - 1);
          6'd2:   $display("%d, J",     $time / 10 - 1);
          6'd3:   $display("%d, JAL",   $time / 10 - 1);
          default: $display("%d, Unknown instruction", $time / 10 - 1);
        endcase
      end

      // 顯示寫入暫存器的值
      if (CPU.RegWrite && CPU.final_wn != 0)
        $display("%d, Write Reg[%0d] = %h", $time / 10 - 1, CPU.final_wn, CPU.final_wd);
    end
  end

  mips_single CPU(clk, rst);
endmodule
