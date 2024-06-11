----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2022 13:35:20
-- Design Name: 
-- Module Name: Unidad_Logica_Aritmetica - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Unidad_Logica_Aritmetica IS
    PORT(
        --Se declaran las entradas
        B :     IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        ULA:    IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        CF:     IN  STD_LOGIC;
        WR1:    IN  STD_LOGIC;
        WR2:    IN  STD_LOGIC;
        n_OE:   IN  STD_LOGIC;
        
        --Se declaran las salidas
        S:      OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        CB:     OUT STD_LOGIC;
        ZB:     OUT STD_LOGIC
    );
END Unidad_Logica_Aritmetica;

ARCHITECTURE Behavioral OF Unidad_Logica_Aritmetica IS
    SIGNAL  E1  :UNSIGNED(8 DOWNTO 0);
    SIGNAL  E2  :UNSIGNED(8 DOWNTO 0);
    SIGNAL  s_S :UNSIGNED(8 DOWNTO 0);
BEGIN

    --Proceso escritura registro de la ULA
    ESCRITURA:   PROCESS(WR1,WR2, B) BEGIN
        --Si flanco ascendente en WR1, E1=B.
        IF (RISING_EDGE(WR1))  THEN
            E1   <=  UNSIGNED("0"&B);
        END IF;
        --Si flanco ascendente en WR2, E2=B.
        IF (RISING_EDGE(WR2))  THEN
            E2   <=  UNSIGNED("0"&B);
        END IF;
    END PROCESS ESCRITURA;
    
    --Proceso principal
    MAIN:   PROCESS(CF, ULA, E1, E2) BEGIN
        --Operaciones en función de las entradas ULA0-3
        CASE ULA IS
            --FUNCIONES ARITMÉTICAS
            --Suma
            WHEN "0000" =>
                s_S <= E1 + E2;
            --Resta
            WHEN "0001" =>
                s_S <= E1 - E2;
            --Incremento
            WHEN "0010" =>
                s_S <= E1 + 1;
            --Decremento
            WHEN "0011" =>
                s_S     <= E1 - 1;
            
            --FUNCIONES LÓGICAS
            --OR
            WHEN "0100" =>
                s_S <= E1 OR E2;
            --AND
            WHEN "0101" =>
                s_S <= E1 AND E2;
            --XOR
            WHEN "0110" =>
                s_S <= E1 XOR E2;
            --NOT
            WHEN "0111" =>
                s_S <= "0" & NOT(E1(7 DOWNTO 0));
            
            --DESPLAZAMIENTO Y ROTACIONES
            --Desplazamiento lógico a la izquierda
            WHEN "1000" =>
                s_S <= CF & E1(6 DOWNTO 0) & "0";
            --Desplazamiento lógico a la derecha
            WHEN "1001" =>
                s_S <= CF & "0" & E1(7 DOWNTO 1);
            --Desplazamiento aritmético a la izquierda
            WHEN "1010" =>
                s_S <= E1(7 DOWNTO 0) & CF;
            --Desplazamiento aritmético a la derecha
            WHEN "1011" =>
                s_S <= E1(0) & CF & E1(7 DOWNTO 1);
            
            --Rotación lógica a la izquierda
            WHEN "1100" =>
                s_S <= CF & E1(6 DOWNTO 0) & E1(7);
            --Rotación lógica a la derecha
            WHEN "1101" =>
                s_S <= CF & E1(0) & E1(7 DOWNTO 1);
            --Rotación aritmética a la izquierda
            WHEN "1110" =>
                s_S <= E1(7 DOWNTO 0) & CF;
            --Rotación aritmética a la derecha
            WHEN "1111" =>
                s_S <= E1(0) & CF & E1(7 DOWNTO 1);
            WHEN OTHERS =>
        END CASE;
    END PROCESS MAIN;
    
    --Proceso para definir la salida triestado
    TRIESTADO:   PROCESS(n_OE, s_S) BEGIN
        --Si n_OE='0', la salidad Q = D
        IF (n_OE = '0')  THEN
            S   <=  STD_LOGIC_VECTOR(s_S (7 DOWNTO 0));
        --Si n_OE='1', la salidad Q = triestado.
        ELSIF (n_OE = '1')  THEN
            S   <=  (OTHERS => 'Z');
        END IF;
    END PROCESS TRIESTADO;
    
    --Proceso para definir el detector de cero
    ZERO:   PROCESS(s_S) BEGIN
        --Si s_S='x00000000', ZB = '1'
        IF (s_S(7 DOWNTO 0) = "00000000")  THEN
            ZB  <= '1';
        --Si NO, ZB = 0;
        ELSE
            ZB  <= '0';
        END IF;
    END PROCESS ZERO;
    
    CB  <= STD_LOGIC(s_S(8));
    
END Behavioral;
