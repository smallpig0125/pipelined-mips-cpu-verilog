`timescale 1ns/1ns
module Divider (
    input  clk,
    input  reset,
    input  [31:0] dataA, // Dividend
    input  [31:0] dataB, // Divisor
    input  [5:0]  Signal,
    output [63:0] dataOut
);

parameter DIVU = 6'b011011; // 27
parameter OUT  = 6'b111111; // the 32 cycle

reg [63:0] rq;        // {R[31:0], Q[31:0]}  high=Remainder, low=Quotient
reg [63:0] rq_next;   // working for the current cycle
reg [31:0] divisor;
reg  [5:0] count;     // step counter
reg        cycle;     // while 32 restoring steps are running
reg [63:0] temp;

always @(posedge clk) begin
    if (reset) begin
        rq      <= 64'b0;
        rq_next <= 64'b0;
        divisor <= 32'b0;
        count   <= 6'b0;
        cycle   <= 1'b0;
        temp    <= 64'b0;
    end
    else begin
        // enter cycle mode
        if (!cycle && Signal == DIVU) begin
            rq      <= {32'b0, dataA};   // R = 0, Q = dividend
            divisor <= dataB;
            count   <= 6'b0;
            cycle   <= 1'b1;
        end
        else if (cycle) begin
            if (count < 6'd32) begin
                // left‑shift {R,Q}
                rq_next = {rq[62:0], 1'b0};

                // set Q0
                if (rq_next[63:32] >= divisor) begin
                    rq_next[63:32] = rq_next[63:32] - divisor; // R = R − M
                    rq_next[0]     = 1'b1;                     // set Q0 = 1
                end
                rq <= rq_next;   // updated {R,Q}
            end
            // step counter
            count <= count + 6'd1;
            if (count == 6'd32)
                cycle <= 1'b0;  // 32 steps done
        end
        if (Signal == OUT) begin
            // swap: Hi = Quotient , Lo = Remainder
            temp <= {rq_next[31:0], rq_next[63:32]};
        end
    end
end

// output to HiLo
assign dataOut = temp;

endmodule