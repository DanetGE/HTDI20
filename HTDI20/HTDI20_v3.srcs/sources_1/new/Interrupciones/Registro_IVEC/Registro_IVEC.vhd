----------------------------------------------------------------------------------
-- Company: Trabajo de Fin de grado
-- Engineer: Daniel Garcia Escobar
-- 
-- Create Date: 11.09.2023 11:49:47
-- Design Name: 
-- Module Name: Sincronizacion_senal_INT - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Registro_IVEC IS
    PORT ( --Se decleran las seññlales de entrada
           n_OE_IVEC    : IN    STD_LOGIC;
           WR_IVEC      : IN    STD_LOGIC;
           
           --Se declaran las señales de BUS
           IDB          : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
           );
END Registro_IVEC;


ARCHITECTURE Behavioral OF Registro_IVEC IS
    SIGNAL VECTOR:      STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN
    
    ESCRITURA: PROCESS(WR_IVEC, IDB) BEGIN
        IF (RISING_EDGE(WR_IVEC)) THEN
            VECTOR(15 DOWNTO 8) <= x"00";             
            VECTOR(7 DOWNTO 1)  <= IDB(6 DOWNTO 0);
            VECTOR(0) <= '0';                         
            
        END IF;
    END PROCESS ESCRITURA;
    
    
    TRIESTADO: PROCESS(n_OE_IVEC, VECTOR) BEGIN
        --La salida no esta en triestado
        IF(n_OE_IVEC = '0') THEN 
            IDB <= VECTOR;
            
        --Triestado en la salida
        ELSIF(n_OE_IVEC = '1') THEN 
            IDB <= (OTHERS=>'Z');
        END IF;
    END PROCESS TRIESTADO;
    
END Behavioral;
