----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2023 23:34:16
-- Design Name: 
-- Module Name: Memory - Behavioral
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

entity Memory is
PORT(
        --Se declaran las entradas
        A:     IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
        CK:    IN  STD_LOGIC;
        
        --Se declaran las salidas
        SPO :  OUT STD_LOGIC_VECTOR (95 DOWNTO 0)
    );
end Memory;

architecture Behavioral of Memory is

    COMPONENT UCROM
        PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(95 DOWNTO 0) 
        );
    END COMPONENT;
    
    
begin

UC_ROM : UCROM
    PORT MAP (
        clka  => CK,
        addra => A,
        douta => SPO
    );

end Behavioral;
