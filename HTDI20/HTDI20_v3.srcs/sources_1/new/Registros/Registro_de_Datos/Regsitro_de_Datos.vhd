----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 14:02:04
-- Design Name: 
-- Module Name: Registro_de_Datos - Behavioral
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

ENTITY Registro_de_Datos IS
    PORT 
    (   
        --Se definen las entradas
        n_OE:   IN  STD_LOGIC;
        WR:     IN  STD_LOGIC;
        DIR:    IN  STD_LOGIC;
        
        --Se definen las salidas/entradas de datos
        A:      INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
        B:      INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END Registro_de_Datos;

ARCHITECTURE Behavioral OF Registro_de_Datos IS
    SIGNAL  s_Q:         STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL  n_OE_BUFFER: STD_LOGIC;
    SIGNAL  n_OE_REG:    STD_LOGIC;
BEGIN
    
    n_OE_BUFFER <= n_OE OR (not DIR);
    n_OE_REG    <= n_OE OR DIR;
    
    
    --Conexión del BUFFER
    HC244:   entity BUFFER_244 PORT MAP(A => B,
                                        G => n_OE_BUFFER,
                                        Y => A);
                                        
    --Conexión del registro
    HC374:   entity Registro_8_bits PORT MAP(D    => A,
                                             WR   => WR,
                                             n_OE => n_OE_REG,
                                             Q    => B);
    
END Behavioral;

