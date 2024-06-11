----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2021 03:08:07
-- Design Name: 
-- Module Name: Registro_Auxiliar_8bits - Behavioral
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

ENTITY Registro_Auxiliar_8bits IS
PORT(
    --Se declaran las entradas
    n_MSB:  IN      STD_LOGIC;
    WR:     IN      STD_LOGIC;
    n_OE:   IN      STD_LOGIC;
    
    --Se declaran las salidas
    D:      IN      STD_LOGIC_VECTOR(15 DOWNTO 0);
    Q:      OUT     STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END Registro_Auxiliar_8bits;


ARCHITECTURE Behavioral OF Registro_Auxiliar_8bits IS
    SIGNAL  S:  STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    
    MAIN_PROCESS:   PROCESS(WR, n_MSB)
    BEGIN
        --Si hay un flanco en WR
        IF(RISING_EDGE(WR)) THEN 
            IF(n_MSB = '0') THEN
                --Si /MSB=0 => S = MSB del dato de entrada
                S   <=  D(15 DOWNTO 8);
            ELSIF(n_MSB = '1') THEN
                --Si /MSB=1 => S = LSB del dato de entrada
                S   <=  D(7 DOWNTO 0);
            END IF;
        END IF;
    
    END PROCESS MAIN_PROCESS;
    
    TRIESTADO:  PROCESS(n_OE, n_MSB, S)
    BEGIN 
        --Si /OE=0...
        IF  (n_OE = '0') THEN 
            IF(n_MSB = '0') THEN
                --Si /MSB = 0 => Q(MSB)= S y Q(LSB)=alta impedancia
                Q(15 DOWNTO 8)  <=  S;
                Q(7 DOWNTO 0)   <=  (OTHERS => 'Z');
                
            ELSIF(n_MSB = '1') THEN
                --Si /MSB = 0 => Q(MSB)= alta impedanciaS y Q(LSB)=S
                Q(7 DOWNTO 0) <=    S;
                Q(15 DOWNTO 8)<=    (OTHERS => 'Z');
                
            END IF;
            
        ELSIF (n_OE = '1') THEN 
            --Si /OE = 1 => Q(MSB y LSB)= alta impedancia
            Q <= (OTHERS => 'Z');
        
        END IF;
    END PROCESS TRIESTADO;

END Behavioral;
