----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2022 13:26:55
-- Design Name: 
-- Module Name: Selector_Zona - Behavioral
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
USE WORK.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Selector_Zona IS
    PORT(
        --Se declaran las entradas
        IDB:           IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        WR_IR:         IN  STD_LOGIC;
        n_OE_IR:       IN  STD_LOGIC;
        n_OE_BUSQ:     IN  STD_LOGIC;
        n_OE_VECT:     IN  STD_LOGIC;
        n_OE_INI:      IN  STD_LOGIC;
        n_OE_INI_INT:  IN  STD_LOGIC;
        n_OE_AUT:      IN  STD_LOGIC;
        
        --Se declaran las salidas
        Q :         OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END Selector_Zona;

ARCHITECTURE Behavioral OF Selector_Zona IS
    SIGNAL  CONTROL: STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN

    --Conexi�n del registro de instrucci�n
    Registro_IR: ENTITY Registro_Instruccion 
                       PORT MAP(D    => IDB,
                                CK   => WR_IR,
                                n_OE => n_OE_IR,
                                Q    => Q);
    
    CONTROL <= n_OE_AUT & n_OE_BUSQ & n_OE_INI & n_OE_VECT & n_OE_INI_INT;
    
    --Proceso Principal
    MAIN:   PROCESS(n_OE_AUT, n_OE_BUSQ, n_OE_INI, n_OE_VECT, CONTROL, n_OE_INI_INT) BEGIN
        
        --Se definen los casos posibles de combinacion de entradas
        CASE (CONTROL)IS
            WHEN "01111" => 
                Q <= x"FC";
            WHEN "10111" => 
                Q <= x"FE";
            WHEN "11011" => 
                Q <= x"FF";
            WHEN "11101" => 
                Q <= x"FD";
            WHEN "11110" => 
                Q <= x"FB";
            WHEN OTHERS => 
                Q <= (OTHERS => 'Z');
        END CASE;
        
    END PROCESS MAIN;
    
END Behavioral;