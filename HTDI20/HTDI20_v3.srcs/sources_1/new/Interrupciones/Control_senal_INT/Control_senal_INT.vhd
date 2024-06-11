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

ENTITY Control_senal_INT IS
    PORT ( --Se decleran las seññlales de entrada
           n_FIN_CI : IN  STD_LOGIC;
           n_INT    : IN  STD_LOGIC;
           CK4      : IN  STD_LOGIC;
           n_RST    : IN  STD_LOGIC;
           n_SETFF  : IN  STD_LOGIC;
           n_MINT0  : IN  STD_LOGIC;
           n_MINT1  : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           n_INTS   : OUT STD_LOGIC;
           Salida   : OUT STD_LOGIC
           );
END Control_senal_INT;


ARCHITECTURE Behavioral OF Control_senal_INT IS
    SIGNAL  s_QB1   :STD_LOGIC;
    SIGNAL  s_QB2   :STD_LOGIC;
    SIGNAL  s_QB3   :STD_LOGIC;
    SIGNAL  s_QB4   :STD_LOGIC;
    SIGNAL  sn_NINT :STD_LOGIC;
BEGIN
    
    Modo_Interrupcion:   PROCESS(n_MINT0, n_MINT1, CK4) 
    BEGIN
        IF (RISING_EDGE(CK4)) THEN
            --Si /MINT0 = '0' las interrupciones se activan por flanco descende de /INT.
            IF ((n_MINT0 = '0') AND (n_MINT1 = '1')) THEN
                sn_NINT <= '0';
            
            --Si /MINT1 = '0' las interrupciones se activan por nivel bajo de /INT.
            ELSIF ((n_MINT0 = '1') AND (n_MINT1 = '0')) THEN 
                sn_NINT <= '1';
            END IF;

        END IF;
   
    END PROCESS Modo_Interrupcion;
    
    MAIN:   PROCESS(CK4, n_INT, n_FIN_CI, n_RST, sn_NINT) BEGIN
        --Si flanco ascendente en CK4.
        IF (n_RST = '1')  THEN
            IF (RISING_EDGE(CK4)) THEN
                --Se activan por flanco descendente
                IF (sn_NINT = '0') THEN
                    s_QB2 <= s_QB1;
                --Se activan por nivel bajo
                ELSIF (sn_NINT = '1') THEN
                    s_QB2 <= n_INT;
                END IF;
                s_QB3 <= s_QB2;
                s_QB4 <= s_QB3 OR n_FIN_CI;
            END IF;
            
        ELSIF (n_RST = '0') THEN 
            s_QB2   <= '1';
            s_QB3   <= '1';
            s_QB4   <= '1';
        END IF;
    END PROCESS MAIN;
    
    Primer_registro:   PROCESS(n_SETFF, n_INT, n_RST) BEGIN
        --Si flanco descendente en /INT.
        IF ((n_RST = '1') AND (n_SETFF = '1'))  THEN
            IF (FALLING_EDGE(n_INT)) THEN
                s_QB1  <= '0';  
            END IF;
        
        --Se reinicia el registro
        ELSIF ((n_RST = '0') OR (n_SETFF = '0')) THEN 
            s_QB1  <= '1';
            
        END IF;
        
    END PROCESS Primer_registro;
    
    n_INTS <= s_QB3;
    Salida  <= s_QB4 OR s_QB3;
    
END Behavioral;
