----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2021 02:22:23
-- Design Name: 
-- Module Name: PSW_FINAL - Behavioral
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

ENTITY PSW_FINAL IS
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
    
    n_CTL:      IN  STD_LOGIC;
    WR:         IN  STD_LOGIC;
    n_OE:       IN  STD_LOGIC;


    ZF:         OUT     STD_LOGIC;
    F0:         OUT     STD_LOGIC;
    F1:         OUT     STD_LOGIC;
    F2:         OUT     STD_LOGIC;
    F3:         OUT     STD_LOGIC;
    CF:         OUT     STD_LOGIC;
    n_CF:       OUT     STD_LOGIC;
    IF1:        OUT     STD_LOGIC;
    IM:         OUT     STD_LOGIC;
    IDB:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0) 
);
END PSW_FINAL;

ARCHITECTURE Behavioral OF PSW_FINAL IS
BEGIN

PSW_FINAL:    entity PSW PORT MAP  (n_SET_ZF => n_SET_ZF,
                                    ZB       => ZB,      
                                    WR_ZF    => WR_ZF,   
                                    n_CLR_ZF => n_CLR_ZF,
        
                                    n_SET_F0 => n_SET_F0,
                                    n_CLR_F0 => n_CLR_F0,
        
                                    n_SET_F1 => n_SET_F1,
                                    n_CLR_F1 => n_CLR_F1,
        
                                    n_SET_F2 => n_SET_F2,
                                    n_CLR_F2 => n_CLR_F2,
        
                                    n_SET_F3 => n_SET_F3,
                                    n_CLR_F3 => n_CLR_F3,
        
                                    n_SET_CF => n_SET_CF,
                                    CB       => CB,      
                                    WR_CF    => WR_CF,   
                                    n_CLR_CF => n_CLR_CF,
        
                                    n_SET_IF => n_SET_IF,
                                    n_CLR_IF => n_CLR_IF,
        
                                    n_SET_IM => n_SET_IM,
                                    n_CLR_IM => n_CLR_IM,
        
                                    n_CTL   => n_CTL,     
                                    WR      => WR,      
                                    n_OE    => n_OE,
                                    D       => IDB(7 DOWNTO 0),
                                    
                                    ZF      => ZF,  
                                    F0      => F0,  
                                    F1      => F1,  
                                    F2      => F2,  
                                    F3      => F3,  
                                    CF      => CF,
                                    IF1     => IF1, 
                                    IM      => IM 
                                    );   
             
END Behavioral;
