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

ENTITY Tiempos_Espera_6_10 IS
    PORT ( --Se decleran las seññlales de entrada
           n_RST        : IN  STD_LOGIC;
           CK           : IN  STD_LOGIC;
           n_EN_READY   : IN  STD_LOGIC;
           n_READY      : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           CKi          : OUT STD_LOGIC
           );
END Tiempos_Espera_6_10;


ARCHITECTURE Behavioral OF Tiempos_Espera_6_10 IS
    SIGNAL READYS: STD_LOGIC;
    SIGNAL n_B1Q:  STD_LOGIC;
BEGIN
    
    Registro: PROCESS(n_RST, CK, n_READY) BEGIN
        IF (FALLING_EDGE(CK)) THEN
            IF(n_RST = '0') THEN
                n_B1Q <= '0';
            ELSIF(n_RST = '1') THEN
                n_B1Q <= n_READY;
            END IF;
        END IF;
    END PROCESS Registro;
    
    
    Selector: PROCESS(CK, READYS) BEGIN
        IF(READYS = '0') THEN 
            CKi <= '0';
        ELSE 
            CKi <= CK;
        END IF;
    END PROCESS Selector;
    
    
    READYS <= NOT(n_RST) OR n_EN_READY OR n_B1Q;
    
END Behavioral;
