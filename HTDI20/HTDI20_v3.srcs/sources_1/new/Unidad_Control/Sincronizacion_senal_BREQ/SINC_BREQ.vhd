----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2024 12:35:10
-- Design Name: 
-- Module Name: SINC_BREQ - Behavioral
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
USE WORK.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SINC_BREQ is
    PORT(
           n_RST        : IN  STD_LOGIC;
           CLK          : IN  STD_LOGIC;
           n_BREQ       : IN  STD_LOGIC;
           n_FIN_CM     : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           CK_CZ        : OUT STD_LOGIC;
           n_BREQS      : OUT STD_LOGIC;
           n_BACK       : OUT STD_LOGIC
           );
end SINC_BREQ;

ARCHITECTURE Behavioral OF SINC_BREQ IS
    SIGNAL  RST:        STD_LOGIC;

    SIGNAL  BREQS:      STD_LOGIC;
    SIGNAL  BACK:       STD_LOGIC;
    SIGNAL  n_BACK2:    STD_LOGIC;
    SIGNAL  BACK2:      STD_LOGIC;
BEGIN

    RST <= n_RST;
    
    SIN: ENTITY Sincronizacion_BREQ PORT MAP(
                RST        => RST,
                CK4        => CLK,
                n_BREQ     => n_BREQ,
                n_FIN_CM   => n_FIN_CM,
                CK_CZ      => CK_CZ,
                n_BREQS    => n_BREQS,
                BREQS      => BREQS,
                n_BACK     => n_BACK,
                BACK       => BACK,
                n_BACK2    => n_BACK2,
                BACK2      => BACK2);
    
end Behavioral;
