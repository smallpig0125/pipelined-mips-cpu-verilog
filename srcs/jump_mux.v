module jump_mux( j, a, b, y );
    parameter bitwidth=32;
    input j;
    input  [bitwidth-1:0] a, b;
    output [bitwidth-1:0] y;

    assign y = j ? b : a;
endmodule
