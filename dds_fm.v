//-----------------------------------------------------------------------------
//
// Title       : dds_fm
// Design      : list1
// Author      : imk
// Company     : nasa
//
//-----------------------------------------------------------------------------
//
// File        : c:\My_Designs\Z1\list1\src\dds_fm.v
// Generated   : Mon Oct 15 08:56:52 2018
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {dds_fm}}
module dds_fm (
	output wire fout,
	input wire clk,
	input wire [31:0] faza_m,
	input wire [31:0] faza_f0,
	input wire rst
);

reg [31:0] Accum=0;

always @(posedge clk)
	if (rst)
		Accum<=0;
	else
		begin
			Accum<=Accum+faza_f0+faza_m;	
		end
		
	assign 	fout=Accum[31];

endmodule
