----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2023 19:50:43
-- Design Name: 
-- Module Name: HTDI_SIMU - Behavioral
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

ENTITY HTDI_SIMU IS
    
END HTDI_SIMU;

ARCHITECTURE Behavioral OF HTDI_SIMU IS
    COMPONENT HTDI20 
        PORT(
        --Locales
        LCB:        INOUT   STD_LOGIC_VECTOR(11 DOWNTO 0);
        LDB:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
        LAB:        INOUT   STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    
    SIGNAL LCBS_s: STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL LCBE_s: STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL LCB_s: STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL LDB_s:  STD_LOGIC_VECTOR(7 DOWNTO 0); 
    SIGNAL LAB_s:  STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN
    
    LCB_s <= LCBE_s(4 DOWNTO 3) & LCBS_s(6) & LCBE_s(2 DOWNTO 0) & LCBS_s(5 DOWNTO 0);
    
    HTDI: HTDI20 PORT MAP(LCB => LCB_s,
                          LDB => LDB_s,
                          LAB => LAB_s);
                          
    primero: PROCESS
    BEGIN
    
        LCBE_s <= "11011";
            wait for 10 ns;
        LCBE_s <= "10111";
            wait for 10 ns;
            
        LCBE_s <= "11111";
            wait for 10 ns;
        LCBE_s <= "10111";
            wait;        
    END PROCESS;
end Behavioral;
