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

ENTITY Arquitectura_Fisica IS
    PORT(
        --Se declaran los buses
        --Internos
        IDB:        INOUT   STD_LOGIC_VECTOR(15 DOWNTO 0);
        ICB:        INOUT   STD_LOGIC_VECTOR(111 DOWNTO 0);
        
        --Locales
        LCB_OUT_ARQ:OUT     STD_LOGIC_VECTOR(3 DOWNTO 0);
        LDB:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
        LAB:        OUT     STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Arquitectura_Fisica;

ARCHITECTURE Behavioral OF Arquitectura_Fisica IS
    SIGNAL ZB:     STD_LOGIC;
    SIGNAL ZB1:     STD_LOGIC;
    SIGNAL CB:     STD_LOGIC;
    SIGNAL n_CF:   STD_LOGIC;
BEGIN
--Conexion Registros de uso general
    --Conexion del registro A
    Registro_A: ENTITY Registro_8_bits 
                       PORT MAP(D    => IDB(7 DOWNTO 0),
                                WR   => ICB(18),
                                n_OE => ICB(19),
                                Q    => IDB(7 DOWNTO 0));
                                
    --Conexion del registro B
    Registro_B: ENTITY Registro_8_bits 
                       PORT MAP(D    => IDB(7 DOWNTO 0),
                                WR   => ICB(20),
                                n_OE => ICB(21),
                                Q    => IDB(7 DOWNTO 0));
                                
    --Conexion del registro C
    Registro_C: ENTITY Registro_8_bits 
                       PORT MAP(D    => IDB(7 DOWNTO 0),
                                WR   => ICB(22),
                                n_OE => ICB(23),
                                Q    => IDB(7 DOWNTO 0));
                                
    --Conexion del registro D
    Registro_D: ENTITY Registro_16_bits 
                       PORT MAP(D    => IDB(15 DOWNTO 0),
                                WR   => ICB(24),
                                n_OE => ICB(25),
                                Q    => IDB(15 DOWNTO 0));
   
   --Conexion del registro E
    Registro_E: ENTITY Registro_16_bits 
                       PORT MAP(D    => IDB(15 DOWNTO 0),
                                WR   => ICB(26),
                                n_OE => ICB(27),
                                Q    => IDB(15 DOWNTO 0));
    
    
--Conexion Registros de uso especifico
    --Conexion del registro Program Counter
    PC: ENTITY Registro_Contador_16bits_CargaSincrona
                       PORT MAP(D     => IDB(15 DOWNTO 0),
                                CK    => ICB(2),
                                n_OE  => ICB(1),
                                WR    => ICB(0),
                                n_INC => '0',
                                Q     => IDB(15 DOWNTO 0));
                                
    --Conexion del registro IX
    IX: ENTITY Registro_Contador_16bits_CargaSincrona
                       PORT MAP(D     => IDB(15 DOWNTO 0),
                                CK    => ICB(17),
                                n_OE  => ICB(15),
                                WR    => ICB(14),
                                n_INC => ICB(16),
                                Q     => IDB(15 DOWNTO 0));
                                
    --Conexion del registro Stack Pointer
    SP: ENTITY Registro_Contador_16bits_CargaSincrona
                       PORT MAP(D     => IDB(15 DOWNTO 0),
                                CK    => ICB(6),
                                n_OE  => ICB(4),
                                WR    => ICB(3),
                                n_INC => ICB(5),
                                Q     => IDB(15 DOWNTO 0));

    
    --Conexion del registro PSW
    PSW_FINAL: ENTITY PSW
                       PORT MAP(n_SET_ZF => ICB(62),
                                ZB       => ZB,
                                WR_ZF    => ICB(65),
                                n_CLR_ZF => ICB(63),
                                
                                n_SET_F0 => ICB(66),
                                n_CLR_F0 => ICB(67),
                                
                                n_SET_F1 => ICB(69),
                                n_CLR_F1 => ICB(70),
                                
                                n_SET_F2 => ICB(72),
                                n_CLR_F2 => ICB(73),

                                n_SET_F3 => ICB(75),
                                n_CLR_F3 => ICB(76),

                                n_SET_CF => ICB(58),
                                CB       => CB,
                                WR_CF    => ICB(61),
                                n_CLR_CF => ICB(59),

                                n_SET_IF => ICB(81),
                                n_CLR_IF => ICB(82),

                                n_SET_IM => ICB(78),
                                n_CLR_IM => ICB(79),

                                n_CTL    => ICB(57),
                                WR       => ICB(55),
                                n_OE     => ICB(56),


                                ZF       => ICB(64),
                                F0       => ICB(68),
                                F1       => ICB(71),
                                F2       => ICB(74),
                                F3       => ICB(77),
                                CF       => ICB(60),
                                IF1      => ICB(83),
                                IM       => ICB(80),
                                D        => IDB(7 DOWNTO 0));
    

--Conexion Registros Auxiliares
    --Conexion del registro AUX0
    AUX0: ENTITY Registro_Auxiliar_8bits
                       PORT MAP(WR    => ICB(29),
                                n_OE  => ICB(30),
                                n_MSB => ICB(31),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX1
    AUX1: ENTITY Registro_Auxiliar_8bits
                       PORT MAP(WR    => ICB(32),
                                n_OE  => ICB(33),
                                n_MSB => ICB(34),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX2
    AUX2: ENTITY Registro_Auxiliar_8bits
                       PORT MAP(WR    => ICB(35),
                                n_OE  => ICB(36),
                                n_MSB => ICB(37),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX3
    AUX3: ENTITY Registro_Auxiliar_8bits
                       PORT MAP(WR    => ICB(38),
                                n_OE  => ICB(39),
                                n_MSB => ICB(40),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX4
    AUX4: ENTITY Registro_Auxiliar_8bits
                       PORT MAP(WR    => ICB(41),
                                n_OE  => ICB(42),
                                n_MSB => ICB(43),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX5
    AUX5: ENTITY Registro_Auxiliar_8bits
                       PORT MAP(WR    => ICB(44),
                                n_OE  => ICB(45),
                                n_MSB => ICB(46),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX6
    AUX6: ENTITY Registro_Contador_16bits_CargaSincrona
                       PORT MAP(WR    => ICB(47),
                                n_OE  => ICB(48),
                                n_INC => ICB(49),
                                CK    => ICB(50),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    
    --Conexion del registro AUX7
    AUX7: ENTITY Registro_Contador_16bits_CargaSincrona
                       PORT MAP(WR    => ICB(51),
                                n_OE  => ICB(52),
                                n_INC => ICB(53),
                                CK    => ICB(54),
                                D     => IDB(15 DOWNTO 0),
                                Q     => IDB(15 DOWNTO 0));
    

--Conexion Registro De Direcciones
    --Conexion del registro AR
    AR: ENTITY Registro_Direcciones_AR
                       PORT MAP(WR    => ICB(7),
                                n_OE  => ICB(8),
                                B     => IDB(15 DOWNTO 0),
                                Q     => LAB(15 DOWNTO 0));
    
    
--Conexion Registro De DR
    DR: ENTITY Registro_de_Datos
                       PORT MAP(WR    => ICB(9),
                                DIR   => ICB(10),
                                n_OE  => ICB(111),
                                A     => IDB(7 DOWNTO 0),
                                B     => LDB(7 DOWNTO 0));
    
 
 --Conexion Registro De Control CR
    CR: ENTITY Registro_Control_CR
                       PORT MAP(n_OE  => ICB(28),
                                D(0)  => ICB(85),
                                D(1)  => ICB(84),
                                D(2)  => ICB(87),
                                D(3)  => ICB(86),
                                Q(0)  => LCB_OUT_ARQ(0),
                                Q(1)  => LCB_OUT_ARQ(2),
                                Q(2)  => LCB_OUT_ARQ(1),
                                Q(3)  => LCB_OUT_ARQ(3));
    

--Conexion Unidad L gico Aritm tica
    --Conexion de la ULA
    ULA: ENTITY Unidad_Logica_Aritmetica
                       PORT MAP(ULA(3) => ICB(99),
                                ULA(2) => ICB(100),
                                ULA(1) => ICB(101),
                                ULA(0) => ICB(102),
                                WR1    => ICB(103),
                                WR2    => ICB(104),
                                n_OE   => ICB(105),
                                CF     => ICB(60),
                                CB     => CB,
                                ZB     => ZB,
                                B      => IDB(7 DOWNTO 0),
                                S      => IDB(7 DOWNTO 0));
    
END Behavioral;