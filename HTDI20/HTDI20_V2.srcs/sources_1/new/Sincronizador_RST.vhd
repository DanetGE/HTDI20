----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2024 00:23:45
-- Design Name: 
-- Module Name: Sincronizador_RST - Behavioral
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

entity Sincronizador_RST is
    Port( CK:           IN  STD_LOGIC;
          n_RST:        IN  STD_LOGIC;
          n_RST_SINC:   OUT STD_LOGIC
         );
end Sincronizador_RST;

architecture Behavioral of Sincronizador_RST is
begin

    SINCRONIZACION: PROCESS(CK, n_RST) BEGIN
        
        IF(Rising_edge(CK))THEN
            n_RST_SINC <= n_RST;
        END IF;
        
    END PROCESS SINCRONIZACION;

end Behavioral;
