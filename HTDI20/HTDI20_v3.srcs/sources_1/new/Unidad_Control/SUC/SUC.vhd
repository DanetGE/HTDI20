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

ENTITY Secuencial_SUC IS
    PORT ( --Se decleran las seññlales de entrada
           n_RST        : IN  STD_LOGIC;
           CK_SUC       : IN  STD_LOGIC;
           n_FIN_CI     : IN  STD_LOGIC;
           IFlag        : IN  STD_LOGIC;
           n_INTS       : IN  STD_LOGIC;
           CK4          : IN  STD_LOGIC;
           
           --Se declaran las señales de salida
           n_OE_INI     : OUT STD_LOGIC;
           n_OE_BUSQ    : OUT STD_LOGIC;
           n_OE_RI      : OUT STD_LOGIC;
           n_OE_INT     : OUT STD_LOGIC;
           n_OE_INI_INT : OUT STD_LOGIC;
           n_RST_CZ     : OUT STD_LOGIC
           );
END Secuencial_SUC;


ARCHITECTURE Behavioral OF Secuencial_SUC IS 

    -- Se declaran los estados del secuencial
    type t_estados is (INICIO, BUSQUEDA, EJECUCION, INTERRUPCION, INI_INT);
    
    --Se declara la señal que indica los estados de la maquina
    SIGNAL s_estado:     t_estados := INICIO;
    SIGNAL sn_FIN_CIS:   STD_LOGIC := '0';
    
BEGIN

    
    MAIN: PROCESS(n_RST, CK_SUC, n_FIN_CI, IFlag, n_INTS) BEGIN
        
        --Se esta reiniciando
        IF(n_RST = '0')THEN
            s_estado <= INICIO;
            
        --No se ejecuta el programa de interrupcion    
        ELSIF(n_RST = '1')THEN
            IF(RISING_EDGE(CK_SUC)) THEN 
                CASE s_estado IS
                
                    --Se encuentra en INICIO cuando falling EDGE CK_SUC
                    WHEN INICIO =>
                        IF(n_FIN_CI = '0') THEN 
                            s_estado <= BUSQUEDA;
                        ELSIF(n_FIN_CI = '1') THEN 
                            s_estado <= INICIO;
                        END IF;
                        
                    --Se encuentra en BUSQUEDA cuando falling EDGE CK_SUC   
                    WHEN BUSQUEDA =>
                        IF(n_FIN_CI = '0') THEN 
                            s_estado <= EJECUCION;
                        ELSIF(n_FIN_CI = '1') THEN 
                            s_estado <= BUSQUEDA;
                        END IF;
                        
                    --Se encuentra en EJECUCION cuando falling EDGE CK_SUC
                    WHEN EJECUCION =>
                        IF(n_FIN_CI = '0') THEN
                            IF(IFlag = '1') THEN
                                s_estado <= BUSQUEDA;
                            ELSIF(IFlag = '0') THEN
                                IF(n_INTS = '1') THEN 
                                    s_estado <= BUSQUEDA;
                                ELSIF(n_INTS = '0') THEN 
                                    s_estado <= INI_INT;
                                END IF;
                            END IF;
                        ELSIF(n_FIN_CI = '1') THEN
                            s_estado <= EJECUCION;
                        END IF;
                    
                    --Se encuentra en el inicio de la interrupción
                    WHEN INI_INT =>
                        IF(n_FIN_CI = '0') THEN 
                            s_estado <= INTERRUPCION;
                        ELSIF(n_FIN_CI = '1') THEN 
                            s_estado <= INI_INT;
                        END IF;
                        
                    --Se encuentra en INTERRUPCION cuando falling EDGE CK_SUC
                    WHEN INTERRUPCION =>
                        IF(n_FIN_CI = '0') THEN 
                            s_estado <= BUSQUEDA;
                        ELSIF(n_FIN_CI = '1') THEN 
                            s_estado <= INTERRUPCION;
                        END IF;
                END CASE;
            END IF;
        END IF;
    END PROCESS MAIN;
    
    
    SALIDAS: PROCESS(s_estado) BEGIN 
        CASE s_estado IS 
            WHEN INICIO =>
                n_OE_INI     <= '0';
                n_OE_BUSQ    <= '1';
                n_OE_RI      <= '1';
                n_OE_INT     <= '1';
                n_OE_INI_INT <= '1';
                
            WHEN BUSQUEDA =>
                n_OE_INI     <= '1';
                n_OE_BUSQ    <= '0';
                n_OE_RI      <= '1';
                n_OE_INT     <= '1';
                n_OE_INI_INT <= '1';
                
            WHEN EJECUCION =>
                n_OE_INI     <= '1';
                n_OE_BUSQ    <= '1';
                n_OE_RI      <= '0';
                n_OE_INT     <= '1';
                n_OE_INI_INT <= '1';
                
            WHEN INTERRUPCION =>
                n_OE_INI     <= '1';
                n_OE_BUSQ    <= '1';
                n_OE_RI      <= '1';
                n_OE_INT     <= '0';
                n_OE_INI_INT <= '1';
                
            WHEN INI_INT =>
                n_OE_INI     <= '1';
                n_OE_BUSQ    <= '1';
                n_OE_RI      <= '1';
                n_OE_INT     <= '1';
                n_OE_INI_INT <= '0';
                
        END CASE;
    END PROCESS SALIDAS;
    
    
    --RST_CZ: PROCESS(n_FIN_CI, CK4) BEGIN 
    --    IF (FALLING_EDGE(CK4))THEN
    --        sn_FIN_CIS <= n_FIN_CI;
    --    END IF;
    --END PROCESS RST_CZ;
    
    n_RST_CZ <= (CK4 OR n_FIN_CI) AND n_RST;
    
END Behavioral;
