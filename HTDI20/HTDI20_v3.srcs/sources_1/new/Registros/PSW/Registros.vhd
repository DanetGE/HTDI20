----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2022 12:12:48
-- Design Name: 
-- Module Name: ZERO_Y_CARRY - Behavioral
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

ENTITY Registros IS
PORT(
    n_SET:  IN  STD_LOGIC;
    n_CLR:  IN  STD_LOGIC;
    D:      IN  STD_LOGIC;
    WR:     IN  STD_LOGIC;
    
    Q:      OUT STD_LOGIC
);
END Registros;

ARCHITECTURE Behavioral OF Registros IS
BEGIN
    BIESTABLE:  PROCESS(WR, n_SET, n_CLR)
    BEGIN
        IF(RISING_EDGE(WR)) THEN
                Q <= D;
        END IF;
        
        IF(n_SET = '0') THEN
            Q <= '1';
        END IF;
        
        IF(n_CLR = '0') THEN
            Q <= '0';
        END IF;
        
    END PROCESS;

end Behavioral;