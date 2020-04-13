module test_led(
    input wire clk,
    input wire nreset,
    output wire [7:0] led
);

reg [31:0] accum=0;
reg [7:0] led_reg=0;
reg [2:0]  flag_clk=0;

always @(posedge clk) flag_clk<={flag_clk[1:0],accum[22]};

always @(posedge clk)
if (nreset) 
begin
  accum<=0;
led_reg<=0;
end else
begin

accum<=accum+1;


if (flag_clk==3'b001)
	begin 
		if (led_reg==8'h00) led_reg<=8'b10000000; 
			else led_reg<=led_reg>>1;
	end
end

assign led=led_reg;

endmodule
