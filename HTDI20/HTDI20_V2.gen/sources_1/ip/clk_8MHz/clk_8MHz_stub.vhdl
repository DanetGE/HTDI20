-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Sun Mar 31 01:04:40 2024
-- Host        : MSI running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top clk_8MHz -prefix
--               clk_8MHz_ clk_8MHz_stub.vhdl
-- Design      : clk_8MHz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_8MHz is
  Port ( 
    clk_5MHz : out STD_LOGIC;
    clk_8MHz : out STD_LOGIC;
    clk_16MHz : out STD_LOGIC;
    clk_32MHz : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_8MHz;

architecture stub of clk_8MHz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_5MHz,clk_8MHz,clk_16MHz,clk_32MHz,clk_in1";
begin
end;
