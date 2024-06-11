----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2023 11:52:38
-- Design Name: 
-- Module Name: HTDI20 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY HTDI20 IS
    PORT(
        --Locales
        LCB_IN:     IN      STD_LOGIC_VECTOR(4 DOWNTO 0);
        CK_BASE:    IN      STD_LOGIC;
        RXD:        IN      STD_LOGIC;
        LCB_OUT:    OUT     STD_LOGIC_VECTOR(6 DOWNTO 0);
        LDB:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
        LAB:        OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);
        CK4MHz:     OUT     STD_LOGIC;
        CK8MHz:     OUT     STD_LOGIC;
        CK16MHz:    OUT     STD_LOGIC;
        CK32MHz:    OUT     STD_LOGIC;
        n_OE_INI:   OUT     STD_LOGIC;
        n_OE_BUSQ:  OUT     STD_LOGIC;
        n_OE_VECT:  OUT     STD_LOGIC;
        n_OE_AUT:   OUT     STD_LOGIC;
        n_OE_RI:    OUT     STD_LOGIC;
        RXD_OUT:    OUT     STD_LOGIC;
        WR_PC:      OUT     STD_LOGIC;
        CK_PC:      OUT     STD_LOGIC
    );
END HTDI20;

ARCHITECTURE Behavioral OF HTDI20 IS

    SIGNAL IDB:             STD_LOGIC_VECTOR(15 DOWNTO 0); 
    SIGNAL ICB:             STD_LOGIC_VECTOR(111 DOWNTO 0);
    
    SIGNAL sn_BREQ:         STD_LOGIC;
    SIGNAL sn_RST:          STD_LOGIC;
    SIGNAL s_LCB_OUT:       STD_LOGIC_VECTOR(6 DOWNTO 0);
    
    SIGNAL sn_BREQ_UART:    STD_LOGIC;
    SIGNAL sn_RST_UART:     STD_LOGIC;
    SIGNAL LDB_UART:        STD_LOGIC_VECTOR(7 DOWNTO 0); 
    SIGNAL LAB_UART:        STD_LOGIC_VECTOR(15 DOWNTO 0); 
    
    SIGNAL LDB_HTDI:        STD_LOGIC_VECTOR(7 DOWNTO 0); 
    SIGNAL LAB_HTDI:        STD_LOGIC_VECTOR(15 DOWNTO 0);
    --SIGNAL sn_WR_MEM_HTDI:  STD_LOGIC;
    
    SIGNAL sn_BACK:         STD_LOGIC;
    SIGNAL sn_WR:           STD_LOGIC;
    SIGNAL sn_RD:           STD_LOGIC;
    SIGNAL sn_BREQS:        STD_LOGIC;
    SIGNAL s_CK_SUC:        STD_LOGIC;
    SIGNAL s_CK_CZ:         STD_LOGIC;
    SIGNAL sn_RST_CZ:       STD_LOGIC;

BEGIN
    

    n_OE_INI  <= ICB(110);
    n_OE_BUSQ <= ICB(107);
    n_OE_VECT <= ICB(2);--CK_PC
    n_OE_AUT  <= ICB(91);--FIN_CM
    n_OE_RI   <= s_CK_SUC;--OE_AR
    RXD_OUT   <= sn_RST_CZ;
    WR_PC     <= ICB(92);--FIN_CI
    CK_PC     <= ICB(0);--WR_PC

    --
    ----WR_PC     <= ICB(94);
    ----CK_PC     <= ICB(91);
    --n_OE_VECT <= ICB(94);
    --n_OE_AUT  <= s_CK_CZ;

    
    --n_OE_INI  <= sn_BREQ;
    --n_OE_BUSQ <= sn_RST;
    --n_OE_VECT <= ;
    --n_OE_AUT  <= sn_WR_MEM_UART;
    --WR_PC     <= sn_BREQS;
    --CK_PC     <=
    --n_OE_RI   <=
    
    
    sn_BREQ_UART <= '1';
    sn_RST_UART  <= '1';
   
   
    CK4MHZ  <= CK_BASE;
    CK8MHZ  <= CK_BASE;
    CK16MHZ <= CK_BASE;
    CK32MHZ <= CK_BASE;
    
    --LCB_OUT(0) <= sn_WR;
    --LCB_OUT(1) <= sn_RD;
    --LCB_OUT(5) <= sn_BACK;
    --LCB_OUT   <= s_LCB_OUT;
    --RXD_OUT    <= RXD;
    
    sn_BREQ   <= sn_BREQ_UART AND LCB_IN(1);
    sn_RST    <= sn_RST_UART  AND LCB_IN(2);
    
    
    
    --Conexion de la Unidad de Control
    UC: ENTITY Unidad_Control
                       PORT MAP(IDB      => IDB,
                                ICB      => ICB,
                                s_CK_SUC => s_CK_SUC,
                                sn_RST_CZ => sn_RST_CZ,                               
                                LCB_IN(0)  => LCB_IN(0),
                                LCB_IN(1)  => LCB_IN(1),
                                LCB_IN(2)  => LCB_IN(2),
                                LCB_IN(3)  => CK_BASE,
                                LCB_IN(4)  => LCB_IN(4),
                                LCB_OUT_CONT(0) => LCB_OUT(4),
                                LCB_OUT_CONT(1) => LCB_OUT(5),
                                LCB_OUT_CONT(2) => LCB_OUT(6)
                                );
                                
    --Conexion de la arquitectura Física
    Arq_Fisica: ENTITY Arquitectura_Fisica
                       PORT MAP(IDB     => IDB,
                                ICB     => ICB,
                                LCB_OUT_ARQ(0) => LCB_OUT(0),
                                LCB_OUT_ARQ(1) => LCB_OUT(1),
                                LCB_OUT_ARQ(2) => LCB_OUT(2),
                                LCB_OUT_ARQ(3) => LCB_OUT(3),
                                LDB     => LDB,
                                LAB     => LAB);

    --Conexion del generador de señales de reloj             
    --CLOCK_GENERATOR: ENTITY Multiplicador_Frecuencia                      
    --                   PORT MAP(CK_IN => CK_BASE,    
    --                            CK4   => CK4MHz,    
    --                            CK8   => CK8MHz, 
    --                            CK16  => CK16MHz,
    --                            CK32  => CK32MHz);
                                
    --Conexion del controlador UART             
    --UART_CONTROLLER: ENTITY Controlador_UART                      
    --                   PORT MAP(RxD       => RxD,
    --                            CLK       => CK_BASE,
    --                            n_BACK    => sn_BACK,
    --                            RxD_OUT   => RXD_OUT,
    --                            n_BREQ    => sn_BREQ_UART,
    --                            n_RST     => sn_RST_UART,
    --                            n_WR_MEM  => sn_WR,
    --                            n_RD_MEM  => sn_RD,
    --                            D_OUT     => LDB,
    --                            DIR       => LAB);
                                
    --Proceso de seleccion de buses.
    --SELECTION: PROCESS(LAB_HTDI, LAB_UART, sn_OE_UART)
    --BEGIN
    --    --Se selecciona el bus DE direccion de la UART
    --    IF(sn_OE_UART = '0')THEN
    --        LAB   <= LAB_UART;
    --    --Se selecciona el bus DE direccion del HTDI20
    --    ELSIF(sn_OE_UART = '1')THEN
    --        LAB   <= LAB_HTDI;
    --    END IF;
    --    
    --END PROCESS SELECTION;
    
END Behavioral;
