module rst
(
  input wire clk,
  output wire reset

);

reg [31:0] a=32'hf0000000;

always @(posedge clk)
begin

	a<=a>>1;

end

assign reset = a [0];

endmodule
