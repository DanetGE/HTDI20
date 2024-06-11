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

ENTITY Detener_SUC IS
    PORT ( --Se decleran las seññlales de entrada
           CK4          : IN  STD_LOGIC;
           BREQS        : IN  STD_LOGIC;
           n_FIN_CM     : IN  STD_LOGIC;
           BACK2        : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           CK_SUC        : OUT STD_LOGIC
           );
END Detener_SUC;


ARCHITECTURE Behavioral OF Detener_SUC IS 
    SIGNAL n_CK4: STD_LOGIC;
BEGIN
    
    n_CK4    <= NOT(CK4);
    CK_SUC   <=  NOT(BREQS) AND n_CK4 AND  NOT(n_FIN_CM) AND  NOT(BACK2);
    
END Behavioral;
