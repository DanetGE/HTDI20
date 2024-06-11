----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2024 02:22:37
-- Design Name: 
-- Module Name: Leer_Memoria - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Leer_Memoria IS
    PORT(  RxD:      IN  STD_LOGIC;
           CLK:      IN  STD_LOGIC;
           n_BACK:   IN  STD_LOGIC;
           BOTON:    IN  STD_LOGIC;
           BOTON1:   IN  STD_LOGIC;
           RxD_OUT:  OUT STD_LOGIC;
           n_BREQ:   OUT STD_LOGIC;
           n_RST:    OUT STD_LOGIC;
           n_WR_MEM: OUT STD_LOGIC;
           n_RD_MEM: OUT STD_LOGIC;
           D_OUT:  OUT STD_LOGIC_VECTOR (7  DOWNTO 0);
           DIR:    OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END Leer_Memoria;

ARCHITECTURE Behavioral OF Leer_Memoria IS
    SIGNAL DIN   : UNSIGNED(3 DOWNTO 0) := x"0"; 
    SIGNAL DIR_BASE  : STD_LOGIC_VECTOR(11 DOWNTO 0) := x"FF0"; 
BEGIN

    D_OUT <= (OTHERS => 'Z');
    
    INC: PROCESS(BOTON) BEGIN
        IF(rising_edge(BOTON))THEN
            DIN <= DIN+1;
        END IF;
    END PROCESS;
    
    BASE: PROCESS(BOTON1) BEGIN
        IF(rising_edge(BOTON1))THEN
            DIR_BASE <= NOT(DIR_BASE(11)) & DIR_BASE(10 DOWNTO 0);
        END IF;
    END PROCESS;
    
    DIR   <= DIR_BASE & STD_LOGIC_VECTOR(DIN);
    n_WR_MEM    <= '1';
    n_RD_MEM    <= '0';
    RxD_OUT     <= '1';
    n_BREQ      <= '1';
    n_RST       <= '1';
    
END Behavioral;
