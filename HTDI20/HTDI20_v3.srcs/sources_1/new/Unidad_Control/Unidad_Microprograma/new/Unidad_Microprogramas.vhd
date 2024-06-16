----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2022 10:00:08
-- Design Name: 
-- Module Name: Unidad_Microprogramas - Behavioral
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

ENTITY Unidad_Microprogramas IS
    PORT(
        --Se declaran las entradas
        --Contador de zona
        CK_CZ:         IN  STD_LOGIC;
        n_RST_CZ:      IN  STD_LOGIC;
        
        --Selector de zona
        CK:            IN  STD_LOGIC;
        IDB:           IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        WR_RI:         IN  STD_LOGIC;
        n_OE_RI:       IN  STD_LOGIC;
        n_OE_BUSQ:     IN  STD_LOGIC;
        n_OE_VECT:     IN  STD_LOGIC;
        n_OE_INI:      IN  STD_LOGIC;
        n_OE_AUT:      IN  STD_LOGIC;
        n_OE_INI_INT:  IN  STD_LOGIC;
        
        --Se declaran las salidas
        C_BUS:        OUT   STD_LOGIC_VECTOR (95 DOWNTO 0);
        ROMB:         OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Unidad_Microprogramas;

ARCHITECTURE Behavioral OF Unidad_Microprogramas is
    SIGNAL s_ROMB:  STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL A:       STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
    
    --Conexión del Contador de Zona
    CONTADOR: ENTITY Contador_Zona 
                       PORT MAP(CK_CZ      => CK_CZ,
                                n_RST_CZ   => n_RST_CZ,
                                Q          => s_ROMB(7 DOWNTO 0));
                                
                  
    --Conexión del Selector de Zona
    SELECTOR: ENTITY Selector_Zona 
                       PORT MAP(IDB        => IDB,
                                WR_IR      => WR_RI,
                                n_OE_IR    => n_OE_RI,
                                n_OE_BUSQ  => n_OE_BUSQ,
                                n_OE_VECT  => n_OE_VECT,
                                n_OE_INI   => n_OE_INI,
                                n_OE_AUT   => n_OE_AUT,
                                Q          => s_ROMB(15 DOWNTO 8),
                                n_OE_INI_INT   => n_OE_INI_INT);
    
    
    A <= s_ROMB(15 DOWNTO 8)& s_ROMB(5 DOWNTO 0);
                                
    --Conexión de la UCROM
    UCROM: ENTITY Memory 
                       PORT MAP(A       => A,
                                CK      => CK,
                                SPO     => C_BUS);                   
    
    ROMB <= s_ROMB;
    
END Behavioral;
