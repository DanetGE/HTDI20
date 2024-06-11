----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2023 21:12:37
-- Design Name: 
-- Module Name: Arquitectura_Fisica - Behavioral
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

ENTITY Unidad_Control IS
    PORT(
        --Se declaran los buses
        --Internos
        IDB:          INOUT   STD_LOGIC_VECTOR(15 DOWNTO 0);
        ICB:          INOUT   STD_LOGIC_VECTOR(111 DOWNTO 0);
        
        --Locales
        LCB_IN:       IN      STD_LOGIC_VECTOR(4 DOWNTO 0);
        LCB_OUT_CONT: OUT     STD_LOGIC_VECTOR(2 DOWNTO 0);
        --sn_BREQS:     OUT     STD_LOGIC;
        s_CK_SUC:     OUT     STD_LOGIC;
        --s_CK_CZ:      OUT     STD_LOGIC;
        sn_RST_CZ:    OUT     STD_LOGIC
    );
END Unidad_Control;

ARCHITECTURE Behavioral OF Unidad_Control IS
    SIGNAL n_OE_INT:     STD_LOGIC;
    SIGNAL CK4:          STD_LOGIC;
    SIGNAL Salida:       STD_LOGIC;
    SIGNAL ROMB:         STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL CBUS:         STD_LOGIC_VECTOR (95 DOWNTO 0);
    SIGNAL CK_CZ:        STD_LOGIC;
    SIGNAL n_RST_CZ:     STD_LOGIC;
    SIGNAL n_BREQS:      STD_LOGIC;
    SIGNAL BREQS:        STD_LOGIC;
    SIGNAL BACK:         STD_LOGIC;
    SIGNAL n_BACK2:      STD_LOGIC;
    SIGNAL BACK2:        STD_LOGIC;
    SIGNAL CK_SUC:       STD_LOGIC;
    SIGNAL n_RST_SINC:   STD_LOGIC;

BEGIN
    
    s_CK_SUC  <= CK_SUC;
    --s_CK_CZ   <= CK_CZ;
    --sn_BREQS  <= n_BREQS;
    sn_RST_CZ <= n_RST_CZ; 
    
    CK4 <= LCB_IN(3);
    
    --Conexion del circuito de coontrol de la se al /INT
    Control_INT: ENTITY Control_senal_INT
                       PORT MAP(n_FIN_CI => ICB(94),
                                n_INT    => LCB_IN(0),
                                CK4      => CK4,
                                n_RST    => n_RST_SINC,
                                n_SETFF  => n_OE_INT,
                                n_MINT0  => ICB(88),
                                n_MINT1  => ICB(89),
                                n_INTS   => ICB(106),
                                Salida   => Salida);
                                
    --Conexion del SINCRONIZADOR DE RST
    RST_SINC: ENTITY Sincronizador_RST
                       PORT MAP(n_RST_SINC => n_RST_SINC,
                                n_RST      => LCB_IN(2),
                                CK         => CK4
                                );
                                
    --Conexion del registro IVEC
    Registro_IVECT: ENTITY Registro_IVEC 
                       PORT MAP(n_OE_IVEC => ICB(96),
                                WR_IVEC   => ICB(95),
                                IDB       => IDB);
                                
    --Conexion del registro AUTO
    Registro_IAUTO: ENTITY Registro_AUTO 
                       PORT MAP(n_OE_IAUT => ICB(98),
                                IDB       => IDB);
                                
    --Conexion del Multiplicador de Frecuencia
    --Multiplicador_CK: ENTITY Multiplicador_Frecuencia 
    --                   PORT MAP(CK  => CKi,
    --                            CK4 => CK4);
   
   --Conexion de la Unidad de Microprogramas
    Uni_Micropro: ENTITY Unidad_Microprogramas 
                       PORT MAP(CK_CZ     => CK_CZ,
                                n_RST_CZ  => n_RST_CZ,
                                CK        => CK4,
                                IDB       => IDB(7 DOWNTO 0),
                                WR_RI     => ICB(12),
                                n_OE_RI   => ICB(13),
                                n_OE_BUSQ => ICB(107),
                                n_OE_VECT => ICB(108),
                                n_OE_INI  => ICB(110),
                                n_OE_AUT  => ICB(109),
                                C_BUS     => CBUS,
                                ROMB      => ROMB);   
    
    --Conexion del circuito de tiempos de espera
    --Tiempos_Espera: ENTITY Tiempos_Espera_6_10
    --                   PORT MAP(n_RST      => n_RST_SINC,
    --                            CK         => LCB_IN(3),
    --                            n_EN_READY => ICB(90),
    --                            n_READY    => LCB_IN(4),
    --                            CKi        => CK4);
                                
    --Conexion del Circuito para las instrucciones condicionales
    Condicionales: ENTITY Condicionales_6_91
                       PORT MAP(ROMB      => ROMB,
                                CF        => ICB(60),
                                ZF        => ICB(64),
                                BF0       => ICB(68),
                                BF1       => ICB(71),
                                BF2       => ICB(74),
                                BF3       => ICB(77),
                                n_FIN_CI1 => ICB(92),
                                n_FIN_CI2 => ICB(93),
                                n_FIN_CI  => ICB(94));
                                
    --Conexion del circuito generador del vector inicio
    Circuito_Vect_Ini: ENTITY Vector_Inicio
                       PORT MAP(n_OE_INI => ICB(97),
                                IDB      => IDB);
    
    --Conexion del Circuito para sincronizar /BREQ
    Sinc_BREQ: ENTITY Sincronizacion_BREQ
                       PORT MAP(RST      => n_RST_SINC,
                                CK4      => CK4,
                                n_BREQ   => LCB_IN(1),
                                n_FIN_CM => ICB(91),
                                CK_CZ    => CK_CZ,
                                n_BREQS  => n_BREQS,
                                BREQS    => BREQS,
                                n_BACK   => LCB_OUT_CONT(1),
                                BACK     => BACK,
                                n_BACK2  => n_BACK2,
                                BACK2    => BACK2);
    
    --Conexion para detener el SUC
    DETEN_SUC: ENTITY Detener_SUC
                       PORT MAP(CK4      => CK4,
                                BREQS    => BREQS,
                                n_FIN_CM => ICB(91),
                                BACK2    => BACK2,
                                CK_SUC   => CK_SUC);
    
    --Conexion Circuito Control Buses
    CONT_BUSES: ENTITY Control_Buses
                       PORT MAP(n_OE_DR           => ICB(11),
                                n_BREQS           => n_BREQS,
                                n_FIN_CM          => ICB(91),
                                n_BACK2           => n_BACK2,
                                n_OE_AR           => ICB(8),
                                n_OE_DataRegister => ICB(111),
                                n_OE_CR           => ICB(28));
    
    --Conexion del selector del tipo interrupcion
    Selector_Int: ENTITY Selector_Interrupcion
                       PORT MAP(n_OE_INT  => n_OE_INT,
                                n_MD_INT  => ICB(80),
                                n_OE_VECT => ICB(108),
                                n_OE_AUTO => ICB(109));
    
    --Conexion de la SUC
    SUC: ENTITY Secuencial_SUC
                       PORT MAP(n_RST     => n_RST_SINC,
                                CK_SUC    => CK_SUC,
                                n_FIN_CI  => ICB(94),
                                IFlag     => ICB(83),
                                n_INTS    => ICB(106),
                                CK4       => CK4,
                                n_OE_INI  => ICB(110),
                                n_OE_BUSQ => ICB(107),
                                n_OE_RI   => ICB(13),
                                n_OE_INT  => n_OE_INT,
                                n_RST_CZ  => n_RST_CZ);

    LCB_OUT_CONT(2)  <=  CBUS(0);
    ICB(7)      <=  CBUS(1);
    ICB(12)     <=  CBUS(2);
    ICB(90)     <=  CBUS(3);
    ICB(91)     <=  CBUS(4);
    ICB(92)     <=  CBUS(5);
    ICB(93)     <=  CBUS(6);
    ICB(11)     <=  CBUS(7);
    ICB(9)      <=  CBUS(8);
    ICB(10)     <=  CBUS(9);
    ICB(84)     <=  CBUS(10);
    ICB(85)     <=  CBUS(11);
    ICB(86)     <=  CBUS(12);
    ICB(87)     <=  CBUS(13);
    ICB(2)      <=  CBUS(14);
    ICB(1)      <=  CBUS(15);
    ICB(0)      <=  CBUS(16);
    ICB(6)      <=  CBUS(17);
    ICB(4)      <=  CBUS(18);
    ICB(3)      <=  CBUS(19);
    ICB(5)      <=  CBUS(20);
    ICB(17)     <=  CBUS(21);
    ICB(15)     <=  CBUS(22);
    ICB(14)     <=  CBUS(23);
    ICB(16)     <=  CBUS(24);
    ICB(29)     <=  CBUS(25);
    ICB(30)     <=  CBUS(26);
    ICB(31)     <=  CBUS(27);
    ICB(32)     <=  CBUS(28);
    ICB(33)     <=  CBUS(29);
    ICB(34)     <=  CBUS(30);
    ICB(35)     <=  CBUS(31);
    ICB(36)     <=  CBUS(32);
    ICB(37)     <=  CBUS(33);
    ICB(38)     <=  CBUS(34);
    ICB(39)     <=  CBUS(35);
    ICB(40)     <=  CBUS(36);
    ICB(41)     <=  CBUS(37);
    ICB(42)     <=  CBUS(38);
    ICB(43)     <=  CBUS(39);
    ICB(44)     <=  CBUS(40);
    ICB(45)     <=  CBUS(41);
    ICB(46)     <=  CBUS(42);
    ICB(47)     <=  CBUS(43);
    ICB(48)     <=  CBUS(44);
    ICB(50)     <=  CBUS(45);
    ICB(49)     <=  CBUS(46);
    ICB(51)     <=  CBUS(47);
    ICB(52)     <=  CBUS(48);
    ICB(54)     <=  CBUS(49);
    ICB(53)     <=  CBUS(50);
    ICB(19)     <=  CBUS(51);
    ICB(18)     <=  CBUS(52);
    ICB(21)     <=  CBUS(53);
    ICB(20)     <=  CBUS(54);
    ICB(23)     <=  CBUS(55);
    ICB(22)     <=  CBUS(56);
    ICB(25)     <=  CBUS(57);
    ICB(24)     <=  CBUS(58);
    ICB(27)     <=  CBUS(59);
    ICB(26)     <=  CBUS(60);
    ICB(56)     <=  CBUS(61);
    ICB(55)     <=  CBUS(62);
    ICB(61)     <=  CBUS(63);
    ICB(58)     <=  CBUS(64);
    ICB(59)     <=  CBUS(65);
    ICB(65)     <=  CBUS(66);
    ICB(62)     <=  CBUS(67);
    ICB(63)     <=  CBUS(68);
    ICB(66)     <=  CBUS(69);
    ICB(67)     <=  CBUS(70);
    ICB(69)     <=  CBUS(71);
    ICB(70)     <=  CBUS(72);
    ICB(72)     <=  CBUS(73);
    ICB(73)     <=  CBUS(74);
    ICB(75)     <=  CBUS(75);
    ICB(76)     <=  CBUS(76);
    ICB(78)     <=  CBUS(77);
    ICB(79)     <=  CBUS(78);
    ICB(88)     <=  CBUS(79);
    ICB(89)     <=  CBUS(80);
    ICB(57)     <=  CBUS(81);
    ICB(81)     <=  CBUS(82);
    ICB(82)     <=  CBUS(83);
    ICB(99)     <=  CBUS(84);
    ICB(100)    <=  CBUS(85);
    ICB(101)    <=  CBUS(86);
    ICB(102)    <=  CBUS(87);
    ICB(103)    <=  CBUS(88);
    ICB(104)    <=  CBUS(89);
    ICB(105)    <=  CBUS(90);
    ICB(95)     <=  CBUS(91);
    ICB(96)     <=  CBUS(92);
    ICB(97)     <=  CBUS(93);
    LCB_OUT_CONT(0)  <=  CBUS(94);
    ICB(98)     <=  CBUS(95);
    
END Behavioral;