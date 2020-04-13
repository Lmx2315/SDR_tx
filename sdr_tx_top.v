module sdr_tx_top
(

input wire clk_50MHZ,

input wire push_btn1,
input wire push_btn2,
input wire push_btn3,

input  wire uart_rx,
output wire uart_tx,


output wire FPGA_LED0,
output wire FPGA_LED1,
output wire FPGA_LED2,
output wire FPGA_LED3,
output wire FPGA_LED4,
output wire FPGA_LED5,
output wire FPGA_LED6,
output wire FPGA_LED7,

output wire SDR_tx,
output wire T_TEST1,
output wire T_TEST2

);
	
wire xpush_btn1;
wire xpush_btn2;
wire xpush_btn3;

wire xuart_rx;	

wire xuart_tx;
wire xFPGA_LED0;
wire xFPGA_LED1;
wire xFPGA_LED2;
wire xFPGA_LED3;
wire xFPGA_LED4;
wire xFPGA_LED5;
wire xFPGA_LED6;
wire xFPGA_LED7;

wire xSDR_tx;
wire xT_TEST1;
wire xT_TEST2;

wire reset_pll1; 
wire reset_all;
wire reset_dds;

wire pll1_locked;

wire clk100;
wire clk300;

rst rst1(clk100,reset_all);
rst rst2(clk300,reset_dds);

pll3
pll3_inst1 (
	.areset (0),
	.inclk0 ( clk_50MHZ ),
	.c0 ( clk100 ),
	.c1 ( clk300 ),
	.locked ( pll1_locked )
	);
	
test_led
tst1(
    .clk(clk100),
    .nreset(reset_all),
    .led({xFPGA_LED0,
			 xFPGA_LED1,
			 xFPGA_LED2,
			 xFPGA_LED3,
			 xFPGA_LED4,
			 xFPGA_LED5,
			 xFPGA_LED6,
			 xFPGA_LED7
			 })
);
	

buf_in4
buf_in4_1 
(
	.datain ( 
	{push_btn1,
	 push_btn2,
	 push_btn3,
	 uart_rx
	} ),
	.dataout (
{
xpush_btn1,
xpush_btn2,
xpush_btn3,
xuart_rx
})
);

buf_out11	
buf_out11_1 (
.datain ( 
{
xuart_tx,
xFPGA_LED0,
xFPGA_LED1,
xFPGA_LED2,
xFPGA_LED3,
xFPGA_LED4,
xFPGA_LED5,
xFPGA_LED6,
xFPGA_LED7,
xSDR_tx,
xT_TEST1,
xT_TEST2
} ),
.dataout ( 
{
uart_tx,
FPGA_LED0,
FPGA_LED1,
FPGA_LED2,
FPGA_LED3,
FPGA_LED4,
FPGA_LED5,
FPGA_LED6,
FPGA_LED7,
SDR_tx,
T_TEST1,
T_TEST2
} )
);	

//--------------resive data from komp------------

wire [7:0] adress;

serial
serial1(
	.reset(0),
	.clk100(clk100),	//100MHz
	.rx(xuart_rx),
	.sbyte(0),
	.send(0),
	.rx_byte(),
	.rbyte_ready(),
	.tx(),
	.busy(), 
	.rb(adress)
	);

//--------------- DDS----------------------
//(32'd1431655765), //100 Мгц
//(32'd1520418423), //106.2 Мгц
//(32'd1275605287), //89.1 Мгц
//(32'd1274173631), //89.0 Мгц
//(32'd1261288729), //88.1 Мгц
//(32'd1145324612), //80.0 Мгц
//(32'd1002159036), //70.0 Мгц
//(32'd1073741824), //75.0 Мгц

dds_fm
dds1(
	.fout(xSDR_tx),
	.clk(clk300),
	.faza_m(data_dds),
	.faza_f0(32'd1431655765), //100 Мгц
	.rst(reset_dds)
);

//---------------ROM--------------------------------
wire [15:0] xadr_rom;
wire [15:0] xdata_rom;
wire [31:0] data_dds;

wire x_btn_debounce;

debounce_better_version
db1(
     .clk(clk100),
     .PB(xpush_btn3),  // "PB" is the glitchy, asynchronous to clk, active low push-button signal

    // from which we make three outputs, all synchronous to the clock
    .PB_state(x_btn_debounce),  // 1 as long as the push-button is active (down)
    .PB_down(),  // 1 for one clock cycle when the push-button goes down (i.e. just pushed)
    .PB_up()   // 1 for one clock cycle when the push-button goes up (i.e. just released)
);


upr1 
u1(
	.adr_rom(xadr_rom),	 
	.data_out(data_dds),
	.tst(),
	.clk(clk100),		
	.rst(0),
	.btn(x_btn_debounce),
	.uart_in(0),
	.uart_rcv(0),
	.rom_in(xdata_rom)
);

rom5	
rom_inst (
	.address ( xadr_rom ),
	.clock ( clk100 ),
	.q ( xdata_rom )
	);

//---------------------------------------------

endmodule