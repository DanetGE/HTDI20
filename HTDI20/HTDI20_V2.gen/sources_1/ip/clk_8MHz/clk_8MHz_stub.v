// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Sun Mar 31 01:04:40 2024
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clk_8MHz -prefix
//               clk_8MHz_ clk_8MHz_stub.v
// Design      : clk_8MHz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_8MHz(clk_5MHz, clk_8MHz, clk_16MHz, clk_32MHz, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_in1" */
/* synthesis syn_force_seq_prim="clk_5MHz" */
/* synthesis syn_force_seq_prim="clk_8MHz" */
/* synthesis syn_force_seq_prim="clk_16MHz" */
/* synthesis syn_force_seq_prim="clk_32MHz" */;
  output clk_5MHz /* synthesis syn_isclock = 1 */;
  output clk_8MHz /* synthesis syn_isclock = 1 */;
  output clk_16MHz /* synthesis syn_isclock = 1 */;
  output clk_32MHz /* synthesis syn_isclock = 1 */;
  input clk_in1;
endmodule
