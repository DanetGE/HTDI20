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

ENTITY Condicionales_6_91 IS
    PORT ( --Se decleran las seññlales de entrada
           ROMB         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
           CF           : IN  STD_LOGIC;
           ZF           : IN  STD_LOGIC;
           BF0          : IN  STD_LOGIC;
           BF1          : IN  STD_LOGIC;
           BF2          : IN  STD_LOGIC;
           BF3          : IN  STD_LOGIC;
           n_FIN_CI1    : IN  STD_LOGIC;
           n_FIN_CI2    : IN  STD_LOGIC; 
           
           --Se declaran las señales de salida
           n_FIN_CI     : OUT STD_LOGIC
           );
END Condicionales_6_91;


ARCHITECTURE Behavioral OF Condicionales_6_91 IS

BEGIN
    
    MAIN:   PROCESS(ROMB, CF, ZF, BF0, BF1, BF2, BF3, n_FIN_CI1, n_FIN_CI2) BEGIN
        
        CASE ROMB(15 DOWNTO 8) IS 
            --Salta si hay acarreo
            WHEN x"00" =>
                IF(CF = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si no hay acarreo
            WHEN x"01" =>
                IF(CF = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si era cero
            WHEN x"02" =>
                IF(ZF = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si no es cero
            WHEN x"03" =>
                IF(ZF = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F0 = 1
            WHEN x"04" =>
                IF(BF0 = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F0 = 0
            WHEN x"05" =>
                IF(BF0 = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F1 = 1
            WHEN x"06" =>
                IF(BF1 = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F1 = 0
            WHEN x"07" =>
                IF(BF1 = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F2 = 1
            WHEN x"08" =>
                IF(BF2 = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F2 = 0
            WHEN x"09" =>
                IF(BF2 = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F3 = 1
            WHEN x"0A" =>
                IF(BF3 = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Salta si F3 = 0
            WHEN x"0B" =>
                IF(BF3 = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Llama si hay acarreo
            WHEN x"0C" =>
                IF(CF = '1') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Llama si NO hay acarreo
            WHEN x"0D" =>
                IF(CF = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            --Llama si NO es cero
            WHEN x"0F" =>
                IF(ZF = '0') THEN 
                    n_FIN_CI <= n_FIN_CI1;
                ELSE 
                    n_FIN_CI <= n_FIN_CI2;
                END IF;
            -- Si no es 0x0XXX la salida es /FIN_CI1
            WHEN OTHERS =>
                n_FIN_CI <= n_FIN_CI1;
            
        END CASE;
        
    END PROCESS MAIN;
    
    
END Behavioral;
