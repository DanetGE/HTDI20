----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 14:02:04
-- Design Name: 
-- Module Name: 74xx244 - Behavioral
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

ENTITY BUFFER_244 IS
    PORT 
    (
        A:      IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        G:      IN  STD_LOGIC;
        Y:      OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BUFFER_244;

ARCHITECTURE Behavioral OF BUFFER_244 IS
BEGIN

    TRIESTADO:  PROCESS(A, G) BEGIN
        IF(G = '0') THEN 
            Y <= A;
        ELSIF(G = '1') THEN
            Y <= (OTHERS => 'Z');
        END IF;
    END PROCESS TRIESTADO;
    
END Behavioral;

