----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2022 12:59:35
-- Design Name: 
-- Module Name: Registro_Direcciones_AR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Registro_Direcciones_AR IS
    PORT(
        --Se declaran las entradas
        B:      IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        WR:     IN  STD_LOGIC;
        n_OE:   IN  STD_LOGIC;
        
        --Se declaran las salidas
        Q:      OUT STD_LOGIC_VECTOR(15 DOWNTO 0)        
    );
END Registro_Direcciones_AR;


ARCHITECTURE Behavioral OF Registro_Direcciones_AR IS
    SIGNAL  D:  STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    --Proceso de escritura en el registro
    ESCRITURA:  PROCESS(WR) BEGIN
        IF (RISING_EDGE(WR)) THEN
            D   <=  B;
        END IF;
    END PROCESS ESCRITURA;
    
    --Proceso de salida triestado
    TRIESTADO: PROCESS(n_OE, D) BEGIN
        IF (n_OE = '0') THEN
            Q   <=  D; 
        ELSE
            Q   <=  (OTHERS=>'Z');
        END IF;
    END PROCESS TRIESTADO;
    
END Behavioral;
