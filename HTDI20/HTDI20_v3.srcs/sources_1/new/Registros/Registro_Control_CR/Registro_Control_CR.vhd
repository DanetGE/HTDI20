----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2022 13:08:57
-- Design Name: 
-- Module Name: Registro_Control_CR - Behavioral
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

ENTITY Registro_Control_CR IS
    PORT(
        --Se declaran las entradas
        D :     IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        n_OE:   IN  STD_LOGIC;
        
        --Se declaran las salidas
        Q :     OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END Registro_Control_CR;

ARCHITECTURE Behavioral OF Registro_Control_CR IS
BEGIN
    --Proceso para definir la salida triestado
    TRIESTADO:   PROCESS(n_OE, D) BEGIN
        --Si n_OE='0', la salidad Q = D
        IF (n_OE = '0')  THEN
            Q   <=  D;
        --Si n_OE='1', la salidad Q = triestado.
        ELSIF (n_OE = '1')  THEN
            Q   <=  (OTHERS => 'Z');
        END IF;
    END PROCESS TRIESTADO;

END Behavioral;