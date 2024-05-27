----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2021 16:18:31
-- Design Name: 
-- Module Name: Registro_16_bits - Behavioral
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

ENTITY Registro_16_bits IS
    PORT 
    (
        D:      IN  std_logic_vector(15 DOWNTO 0);
        WR:     IN  std_logic;
        n_OE:   IN  std_logic;
        Q:      OUT std_logic_vector(15 DOWNTO 0)
    );
END Registro_16_bits;

ARCHITECTURE Behavioral OF Registro_16_bits IS
BEGIN
    --Proceso de escritura y triestado
    main_process: PROCESS(n_OE, WR, D)
        VARIABLE v_D:   STD_LOGIC_VECTOR(15 DOWNTO 0);
        BEGIN 
            --¿Escritura?
            IF (RISING_EDGE(WR)) THEN --SI
                v_D := D;
            END IF;
            
            --¿Salida Triestado?
            IF (n_OE = '0') THEN --NO
                Q <= v_D;            
            ELSE --SI
                Q <= (OTHERS => 'Z');
            END IF;
            
    END PROCESS main_process;
END Behavioral;
