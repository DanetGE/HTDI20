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
USE WORK.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Sincronizacion_Senal_BREQ IS
    PORT ( --Se decleran las seññlales de entrada
           n_RST        : IN  STD_LOGIC;
           CK4          : IN  STD_LOGIC;
           n_BREQ       : IN  STD_LOGIC;
           n_FIN_CM     : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           CK_CZ        : OUT STD_LOGIC;
           n_BREQS      : OUT STD_LOGIC;
           BREQS        : OUT STD_LOGIC;
           n_BACK       : OUT STD_LOGIC;
           BACK         : OUT STD_LOGIC;
           n_BACK2      : OUT STD_LOGIC;
           BACK2        : OUT STD_LOGIC
           );
END Sincronizacion_Senal_BREQ;


ARCHITECTURE Behavioral OF Sincronizacion_Senal_BREQ IS
    SIGNAL RST: STD_LOGIC;
BEGIN
    RST <= NOT(n_RST);
    
    --Conexi n del Selector de Zona
    Secuencial: ENTITY Sincronizacion_BREQ 
                       PORT MAP(RST      => RST,
                                CK4      => CK4,
                                n_BREQ   => n_BREQ  ,
                                n_FIN_CM => n_FIN_CM,
                                CK_CZ    => CK_CZ,
                                n_BREQS  => n_BREQS,
                                BREQS    => BREQS,
                                n_BACK   => n_BACK,
                                BACK     => BACK,
                                n_BACK2  => n_BACK2,
                                BACK2    => BACK2
                                );
    
END Behavioral;