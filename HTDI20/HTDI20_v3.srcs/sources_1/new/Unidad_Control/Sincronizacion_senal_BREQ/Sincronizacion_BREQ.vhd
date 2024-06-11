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

ENTITY Sincronizacion_BREQ IS
    PORT ( --Se decleran las seññlales de entrada
           RST          : IN  STD_LOGIC;
           CK4          : IN  STD_LOGIC;
           n_BREQ       : IN  STD_LOGIC;
           n_FIN_CM     : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           CK_CZ        : OUT STD_LOGIC;
           n_BREQS      : OUT STD_LOGIC;
           BREQS        : OUT STD_LOGIC;
           n_BACK       : OUT STD_LOGIC;
           BACK         : OUT STD_LOGIC;
           n_BACK2      : OUT STD_LOGIC;
           BACK2        : OUT STD_LOGIC
           );
END Sincronizacion_BREQ;


ARCHITECTURE Behavioral OF Sincronizacion_BREQ IS
    SIGNAL s_QB1:       STD_LOGIC := '1';
    SIGNAL s_QB2:       STD_LOGIC := '1';
    SIGNAL s_QB3:       STD_LOGIC := '1';
    SIGNAL s_QB4:       STD_LOGIC := '1';
    SIGNAL sn_FIN_CM:   STD_LOGIC := '1';
BEGIN
    
    SINCRONIZACION: PROCESS(CK4, n_BREQ, sn_FIN_CM, RST) BEGIN
        --Se produce en flanco ascendente de CK
        IF(RISING_EDGE(CK4)) THEN
            IF(RST = '1')THEN
                s_QB1 <= n_BREQ;
                s_QB2 <= s_QB1;
                s_QB3 <= (s_QB2 OR sn_FIN_CM);
                s_QB4 <= s_QB3;
            ELSIF(RST = '0')THEN
                s_QB1 <= '1';
                s_QB2 <= '1';
                s_QB3 <= '1';
                s_QB4 <= '1';
            END IF;
        END IF;
    END PROCESS SINCRONIZACION;
    
    
    SINCRONIZACION_FIN: PROCESS(CK4, n_FIN_CM, RST, s_QB2) BEGIN
        
        IF(s_QB2 = '0')THEN
            --Se produce en flanco ascendente de CK
            IF(RISING_EDGE(n_FIN_CM)) THEN
                sn_FIN_CM <= s_QB2;
            END IF;
        ELSIF(s_QB2 = '1')THEN
                sn_FIN_CM <= '1';
        END IF;
    END PROCESS SINCRONIZACION_FIN;
    

    --Se declaran las salidas en funcion de las señales de los registros
    CK_CZ   <= NOT(s_QB2 OR sn_FIN_CM) OR CK4 OR (NOT(s_QB3)) OR (NOT(s_QB4));
    n_BREQS <= s_QB2;
    BREQS   <= NOT(s_QB2);
    n_BACK  <= s_QB3;     
    BACK    <= NOT(s_QB3);
    n_BACK2 <= s_QB4;     
    BACK2   <= NOT(s_QB4);
    
    
END Behavioral;
