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

ENTITY Selector_Interrupcion IS
    PORT ( --Se decleran las seññlales de entrada
           n_OE_INT     : IN  STD_LOGIC;
           n_MD_INT     : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           n_OE_VECT    : OUT STD_LOGIC;
           n_OE_AUTO    : OUT STD_LOGIC
           );
END Selector_Interrupcion;


ARCHITECTURE Behavioral OF Selector_Interrupcion IS 
    SIGNAL n_OE_BUS: STD_LOGIC;
    
BEGIN
    
    MAIN: PROCESS(n_MD_INT, n_OE_INT) BEGIN
        
        --Se inicia la interrupcion
        IF(n_OE_INT = '0')THEN
            --Interrupcion vectorizada
            IF(n_MD_INT = '0') THEN 
                n_OE_VECT <= '0';
                n_OE_AUTO <= '1';
            --Interrupcion autovectorizada
            ELSIF(n_MD_INT = '1') THEN 
                n_OE_VECT <= '1';
                n_OE_AUTO <= '0';
            END IF;
        --No se ejecuta el programa de interrupcion    
        ELSIF(n_OE_INT = '1')THEN
            n_OE_VECT <= '1';
            n_OE_AUTO <= '1';
        END IF;
    
    END PROCESS;
    
END Behavioral;
