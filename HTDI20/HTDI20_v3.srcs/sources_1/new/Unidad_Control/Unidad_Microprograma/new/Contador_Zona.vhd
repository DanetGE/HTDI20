----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2022 13:26:55
-- Design Name: 
-- Module Name: Contador_Zona - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;
USE WORK.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Contador_Zona IS
    PORT(
        --Se declaran las entradas
        CK_CZ :     IN  STD_LOGIC;
        n_RST_CZ:   IN  STD_LOGIC;
        
        --Se declaran las salidas
        Q :         OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END Contador_Zona;

ARCHITECTURE Behavioral OF Contador_Zona IS
BEGIN
    
    --Proceso Principal
    MAIN:   PROCESS(CK_CZ, n_RST_CZ) 
        VARIABLE  S: UNSIGNED(7 DOWNTO 0) := "00000000";
    BEGIN
        
        --Incrimentar la cuenta
        IF (RISING_EDGE(CK_CZ))  THEN
            S := S + 1;
        END IF;
        
        --Reiniciar la cuenta
        IF (n_RST_CZ = '0')  THEN
            S := "00000000";
        END IF;
        Q <= STD_LOGIC_VECTOR(S);
    END PROCESS MAIN;
    
END Behavioral;