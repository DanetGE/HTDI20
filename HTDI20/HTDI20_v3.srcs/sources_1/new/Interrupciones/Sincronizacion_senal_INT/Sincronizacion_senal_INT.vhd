----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2023 11:45:20
-- Design Name: 
-- Module Name: Sincronizacion_senal_INT - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sincronizacion_senal_INT is
    Port ( n_RST : in STD_LOGIC;
           n_INT : in STD_LOGIC;
           CK4 : in STD_LOGIC;
           n_FIN_CI : in STD_LOGIC;
           n_INTS : out STD_LOGIC;
           OUT : out STD_LOGIC);
end Sincronizacion_senal_INT;

architecture Behavioral of Sincronizacion_senal_INT is

begin


end Behavioral;
