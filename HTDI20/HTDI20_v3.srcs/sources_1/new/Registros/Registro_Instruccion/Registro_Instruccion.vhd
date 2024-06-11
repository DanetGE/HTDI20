----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2022 13:26:55
-- Design Name: 
-- Module Name: Registro_Instruccion - Behavioral
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

ENTITY Registro_Instruccion IS
    PORT(
        --Se declaran las entradas
        D :     IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        CK:     IN  STD_LOGIC;
        n_OE:   IN  STD_LOGIC;
        
        --Se declaran las salidas
        Q :     OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END Registro_Instruccion;

ARCHITECTURE Behavioral OF Registro_Instruccion IS
    SIGNAL  S: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    --Proceso de escritura
    ESCRITURA:   PROCESS(CK, D) BEGIN
        --Si n_OE='0', la salidad Q = D
        IF (RISING_EDGE(CK)) THEN
            S   <=  D;
        END IF;
    END PROCESS ESCRITURA;

    --Proceso para definir la salida triestado
    TRIESTADO:   PROCESS(n_OE, D, S) BEGIN
        --Si n_OE='0', la salidad Q = D
        IF (n_OE = '0')  THEN
            Q   <=  S;
        --Si n_OE='1', la salidad Q = triestado.
        ELSIF (n_OE = '1')  THEN
            Q   <=  (OTHERS => 'Z');
        END IF;
    END PROCESS TRIESTADO;

END Behavioral;