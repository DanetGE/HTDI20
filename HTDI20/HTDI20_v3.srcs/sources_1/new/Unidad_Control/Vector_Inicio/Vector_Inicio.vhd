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

ENTITY Vector_Inicio IS
    PORT ( --Se decleran las seññlales de entrada
           n_OE_INI    : IN    STD_LOGIC;
           
           --Se declaran las señales de BUS
           IDB          : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
           );
END Vector_Inicio;


ARCHITECTURE Behavioral OF Vector_Inicio IS
    
BEGIN   
    
    TRIESTADO: PROCESS(n_OE_INI) BEGIN
        --La salida no esta en triestado
        IF(n_OE_INI = '0') THEN 
            IDB <= x"FFF0";
            
        --Triestado en la salida
        ELSE
            IDB <= (OTHERS=>'Z');
        END IF;
        
    END PROCESS TRIESTADO;
    
END Behavioral;
