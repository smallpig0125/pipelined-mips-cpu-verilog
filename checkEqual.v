module checkEqual( inputa, inputb, iseq, rst );
  input [31:0] inputa, inputb;
  input rst;
  output reg iseq;

  always @ (inputa or inputb or rst) begin
    if (rst)
      iseq <= 1'b0;
    else
      iseq <= (inputa == inputb) ? 1'b1 : 1'b0;
  end
endmodule
