----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2021 22:59:56
-- Design Name: 
-- Module Name: PSW - Behavioral
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

ENTITY PSW IS
PORT(
    n_SET_ZF:   IN  STD_LOGIC;
    ZB:         IN  STD_LOGIC;
    WR_ZF:      IN  STD_LOGIC;
    n_CLR_ZF:   IN  STD_LOGIC;
    
    n_SET_F0:   IN  STD_LOGIC;
    n_CLR_F0:   IN  STD_LOGIC;
    
    n_SET_F1:   IN  STD_LOGIC;
    n_CLR_F1:   IN  STD_LOGIC;

    n_SET_F2:   IN  STD_LOGIC;
    n_CLR_F2:   IN  STD_LOGIC;
    
    n_SET_F3:   IN  STD_LOGIC;
    n_CLR_F3:   IN  STD_LOGIC;
    
    n_SET_CF:   IN  STD_LOGIC;
    CB:         IN  STD_LOGIC;
    WR_CF:      IN  STD_LOGIC;
    n_CLR_CF:   IN  STD_LOGIC;
    
    n_SET_IF:   IN  STD_LOGIC;
    n_CLR_IF:   IN  STD_LOGIC;
    
    n_SET_IM:   IN  STD_LOGIC;
    n_CLR_IM:   IN  STD_LOGIC;
    

    WR:         IN  STD_LOGIC;
    n_CTL:      IN  STD_LOGIC;
    n_OE:       IN  STD_LOGIC;
    D:          INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    ZF:         OUT STD_LOGIC;
    F0:         OUT STD_LOGIC;
    F1:         OUT STD_LOGIC;
    F2:         OUT STD_LOGIC;
    F3:         OUT STD_LOGIC;
    CF:         OUT STD_LOGIC;
    IF1:        OUT STD_LOGIC;
    IM:         OUT STD_LOGIC
);
END PSW;


ARCHITECTURE Behavioral OF PSW IS

    signal s_ZF:    STD_LOGIC;
    signal s_F0:    STD_LOGIC;
    signal s_F1:    STD_LOGIC;
    signal s_F2:    STD_LOGIC;
    signal s_F3:    STD_LOGIC;
    signal s_CF:    STD_LOGIC;
    signal s_IF1:   STD_LOGIC;
    signal s_IM:    STD_LOGIC;
    SIGNAL WR_ZERO: STD_LOGIC;
    SIGNAL WR_CARRY:STD_LOGIC;
    
BEGIN
    WR_ZERO  <= WR_ZF AND WR;
    WR_CARRY <= WR_CF AND WR;
    
    
    ZERO_FLAG: ENTITY WORK.ZERO_Y_CARRY PORT MAP(
        n_SET   => n_SET_ZF,
        n_CLR   => n_CLR_ZF,
        B       => ZB,
        D       => D(0),
        n_CTL   => n_CTL,
        WR      => WR_ZERO,
        Q       => s_ZF
    );
    
    CARRY_FLAG: ENTITY WORK.ZERO_Y_CARRY PORT MAP(
        n_SET   => n_SET_CF,
        n_CLR   => n_CLR_CF,
        B       => CB,
        D       => D(5),
        n_CTL   => n_CTL,
        WR      => WR_CARRY,
        Q       => s_CF
    );
    
    F0_FLAG: ENTITY WORK.Registros PORT MAP(
        n_SET   => n_SET_F0,
        n_CLR   => n_CLR_F0,
        D       => D(1),
        WR      => WR,
        Q       => s_F0
    );
    
    F1_FLAG: ENTITY WORK.Registros PORT MAP(
        n_SET   => n_SET_F1,
        n_CLR   => n_CLR_F1,
        D       => D(2),
        WR      => WR,
        Q       => s_F1
    );
    
    F2_FLAG: ENTITY WORK.Registros PORT MAP(
        n_SET   => n_SET_F2,
        n_CLR   => n_CLR_F2,
        D       => D(3),
        WR      => WR,
        Q       => s_F2
    );
   
    F3_FLAG: ENTITY WORK.Registros PORT MAP(
        n_SET   => n_SET_F3,
        n_CLR   => n_CLR_F3,
        D       => D(4),
        WR      => WR,
        Q       => s_F3
    );
    
    IF_FLAG: ENTITY WORK.Registros PORT MAP(
        n_SET   => n_SET_IF,
        n_CLR   => n_CLR_IF,
        D       => D(6),
        WR      => WR,
        Q       => s_IF1
    );
    
    IM_FLAG: ENTITY WORK.Registros PORT MAP(
        n_SET   => n_SET_IM,
        n_CLR   => n_CLR_IM,
        D       => D(7),
        WR      => WR,
        Q       => s_IM
    );
    
    --TRIESTADO DE SALIDA
    TRIESTADO: PROCESS(n_OE, s_ZF, s_F0, s_F1, s_F2, s_F3, s_CF, s_IF1, s_IM)
    BEGIN
        IF (n_OE = '0') THEN
            D(0) <= s_ZF;
            D(1) <= s_F0;
            D(2) <= s_F1;
            D(3) <= s_F2;
            D(4) <= s_F3;
            D(5) <= s_CF;
            D(6) <= s_IF1;
            D(7) <= s_IM;
        ELSIF (n_OE = '1') THEN
            D(0) <=  'Z';
            D(1) <=  'Z';
            D(2) <=  'Z';
            D(3) <=  'Z';
            D(4) <=  'Z';
            D(5) <=  'Z';
            D(6) <=  'Z';
            D(7) <=  'Z';
            D(7) <=  'Z'; 
        END IF;
    END PROCESS TRIESTADO;
    
    ZF   <=  s_ZF;
    F0   <=  s_F0;
    F1   <=  s_F1;
    F2   <=  s_F2;
    F3   <=  s_F3;
    CF   <=  s_CF;
    IF1  <=  s_IF1;
    IM   <=  s_IM; 

END Behavioral;
