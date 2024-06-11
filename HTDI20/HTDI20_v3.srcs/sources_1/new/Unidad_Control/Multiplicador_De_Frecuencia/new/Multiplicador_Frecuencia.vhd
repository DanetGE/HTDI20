----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2022 08:44:37
-- Design Name: 
-- Module Name: Multiplicador_Frecuencia - Behavioral
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


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Multiplicador_Frecuencia IS
    PORT(
        --Se declaran las entradas
        CK_IN:     IN STD_LOGIC;
        --Se declaran las salidas
        CK4:    OUT STD_LOGIC;
        CK8:    OUT STD_LOGIC;
        CK16:   OUT STD_LOGIC;
        CK32:   OUT STD_LOGIC
        );
END Multiplicador_Frecuencia;

ARCHITECTURE Behavioral OF Multiplicador_Frecuencia IS

    component clk_8MHz                      
    port                                    
     (-- Clock in ports                     
      -- Clock out ports                    
      clk_5MHz          : out    std_logic; 
      clk_8MHz          : out    std_logic; 
      clk_16MHz          : out    std_logic;
      clk_32MHz          : out    std_logic;
      clk_in1           : in     std_logic  
     );                                     
    end component;                          

BEGIN
    
    --Conexión del PLL
    Multiplicador_Frec: clk_8MHz  PORT MAP(                  
        -- Clock out ports           
        clk_5MHz => CK4,       
        clk_8MHz => CK8,       
        clk_16MHz => CK16,     
        clk_32MHz => CK32,     
        -- Clock in ports           
        clk_in1 => CK_IN);                            

END Behavioral;
