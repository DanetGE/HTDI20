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

ENTITY Control_Buses IS
    PORT ( --Se decleran las seññlales de entrada
           n_OE_DR      : IN  STD_LOGIC;
           n_BREQS      : IN  STD_LOGIC;
           n_FIN_CM     : IN  STD_LOGIC;
           n_BACK2      : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           n_OE_AR              : OUT STD_LOGIC;
           n_OE_DataRegister    : OUT STD_LOGIC;
           n_OE_CR              : OUT STD_LOGIC
           );
END Control_Buses;


ARCHITECTURE Behavioral OF Control_Buses IS 
    SIGNAL n_OE_BUS: STD_LOGIC;
    
BEGIN
    
    --Se dlecara la señal /OE_BUS
    n_OE_BUS <= (n_FIN_CM OR n_BREQS) NAND n_BACK2;
    
    --Se declaran las salidas que controlan los buses locales
    n_OE_AR           <= n_OE_BUS;
    n_OE_CR           <= n_OE_BUS;
    n_OE_DataRegister <= n_OE_BUS OR n_OE_DR;
    
END Behavioral;
