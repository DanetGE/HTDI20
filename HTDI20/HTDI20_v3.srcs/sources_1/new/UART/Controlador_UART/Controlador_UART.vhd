----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2024 00:29:13
-- Design Name: 
-- Module Name: Controlador_UART - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Controlador_UART IS
    PORT(  RxD:      IN  STD_LOGIC;
           CLK:      IN  STD_LOGIC;
           n_BACK:   IN  STD_LOGIC;
           n_BREQ:   OUT STD_LOGIC;
           n_RST:    OUT STD_LOGIC;
           n_WR_MEM: OUT STD_LOGIC;
           n_RD_MEM: OUT STD_LOGIC;
           led:      OUT STD_LOGIC;
           D_OUT:    INOUT STD_LOGIC_VECTOR (7  DOWNTO 0);
           DIR:      OUT   STD_LOGIC_VECTOR (15 DOWNTO 0));
END Controlador_UART;


ARCHITECTURE Behavioral OF Controlador_UART IS
    
    TYPE   t_DIR  is ARRAY (19 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE   t_DATA is ARRAY (19 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL sn_OE: STD_LOGIC;
    SIGNAL sn_WR: STD_LOGIC := '1';
    SIGNAL sn_RD: STD_LOGIC := '1';
    SIGNAL S_LED: STD_LOGIC := '1';
    
    SIGNAL s_DIR:   STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s_D_OUT: STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN

    
    --Se produce un flanco de subida
    MAIN: PROCESS(CLK, RxD, n_BACK, sn_OE, sn_WR, sn_RD, S_LED)
        VARIABLE    N_CLOCKS  : INTEGER := 0;
        VARIABLE    N_CK_SAVE : INTEGER   := 0;
        VARIABLE    N_CK_RESET: INTEGER   := 0;
        VARIABLE    POS       : INTEGER   := 8;
        VARIABLE    N_BITS    : INTEGER   := 0;
        VARIABLE    N_BYTES   : INTEGER   := 0;
        VARIABLE    DIRECCION : STD_LOGIC_VECTOR (15 DOWNTO 0);
        VARIABLE    DATA      : STD_LOGIC_VECTOR (7  DOWNTO 0);
        VARIABLE    num_DATOS : INTEGER := 0;
        VARIABLE    LEYENDO   : STD_LOGIC := '0';
        VARIABLE    GUARDAR   : STD_LOGIC := '0';
        VARIABLE    RESET     : STD_LOGIC := '0';
        VARIABLE    DATA_REG  : t_DATA := (OTHERS =>x"00");
        VARIABLE    DIR_REG   : t_DIR  := (OTHERS =>x"0000");
        VARIABLE    sn_RST    : STD_LOGIC := '1';
        VARIABLE    sn_BREQ   : STD_LOGIC := '1';
        
        VARIABLE    DIR_AUX1  : STD_LOGIC_VECTOR (15 DOWNTO 0);
        VARIABLE    DIR_AUX2  : STD_LOGIC_VECTOR (15 DOWNTO 0);

    BEGIN
        
        IF(RISING_EDGE(CLK))THEN
            --Se incrementan los periodos de reloj que lleva 
            N_CLOCKS := N_CLOCKS + 1;
            
            --Se detecta el bit el inicio
            IF((RxD = '0')AND(LEYENDO = '0')) THEN
                LEYENDO  := '1';
                N_CLOCKS :=  0;
                sn_BREQ  := '0';
                RESET    := '0'; 
                
            --Se comienza a leer el mensaje que se manda
            ELSIF((LEYENDO = '1')AND(N_CLOCKS = 625)) THEN
                --Se incrementa los bits recibidos
                N_BITS := N_BITS + 1;
                
                --Se estan recinbiendo los datos, ya ha pasado el bit de inicio
                IF((N_BITS > 1) AND (N_BITS < 10)) THEN
                    --Se esta leyendo la direccion
                    IF(N_BYTES <= 1) THEN
                        DIRECCION(POS) := RxD;
                    --Se esta leyendo el dato a guardar en la memoria
                    ELSIF(N_BYTES = 2) THEN
                        DATA(POS) := RxD;
                    END IF;
                    
                    POS := POS  + 1;
                
                --Se esta recibiendo el bit de parada
                ELSIF(N_BITS = 10) THEN
                    --Se incremntan los bytes recibidos, se reinician los bits recibidos y se cambia a "No Leyendo"
                    N_BYTES  := N_BYTES + 1;
                    N_BITS   := 0;
                    LEYENDO  := '0';
                    
                    --Se ha leido ya la direccion y se reinicia Pos para guardar ahora en el array DATA
                    IF(N_BYTES <= 2) THEN 
                        POS := 0;
                    --Se ha leido la direccion y el dato, se reinicia posicion y bytes recibidos, y se cambia a "Guardando"
                    ELSIF(N_BYTES = 3) THEN 
                        POS := 8;
                        N_BYTES := 0;
                        
                        DATA_REG(num_DATOS) := DATA;
                        DIR_REG(num_DATOS)  := DIRECCION;
                        
                        num_DATOS := num_DATOS + 1;
                    END IF;
                END IF;
            
            --Reinicia el reloj, porque se ha llegado al cambio de bit.
            ELSIF(N_CLOCKS = 1250) THEN
                
                N_CLOCKS := 0;
                
                --Ha acabdo la recepcion de datos, y se espera a que guarde para reiniciar el uP
                IF((num_DATOS = 0) AND (LEYENDO = '0') AND (GUARDAR = '0') AND (sn_RST = '1') AND (sn_BREQ = '0') AND (RESET = '0'))THEN
                    RESET   := '1'; 
                END IF;    
                    
                IF (RESET = '1') THEN
                    N_CK_RESET := N_CK_RESET + 1;
                    
                    IF(N_CK_RESET = 121) THEN
                        sn_RST  := '0';
                        sn_BREQ := '1';
                        s_led   <= NOT(s_LED);
                    ELSIF(N_CK_RESET = 123) THEN
                        sn_RST  := '1';
                        RESET   := '0';
                        N_CK_RESET := 0;
                    END IF;
                END IF;
            END IF;
            
            
            --Se comienza a guaradar el dato
            IF((num_DATOS > 0) AND (n_BACK = '0')) THEN 
                --Se incrementan los periodos de reloj que lleva
                N_CK_SAVE:= N_CK_SAVE + 1;
                
                --No se guarad hasta que haya pasado el tiempo suficiente para recibir 4 datos
                IF(GUARDAR = '1')THEN

                    --SEGUNDO periodo, se pone WR a nivel bajo
                    IF(N_CK_SAVE = 2) THEN
                        sn_WR <= '0';
                    --Tres periodos depues(250 ns), se pone WR a nivel alto.
                    ELSIF(N_CK_SAVE = 5) THEN
                        sn_WR <= '1';
                        DIR_AUX1 := DIR_REG(0);
                        DIR_AUX2 := DIR_REG(1);
                    --Un periodo depues(83,33 ns), se acaba la escritura.
                    ELSIF(N_CK_SAVE = 6) THEN
                        
                        IF(DIR_AUX1(15 DOWNTO 6) /= DIR_AUX2(15 DOWNTO 6))THEN
                            GUARDAR := '0';
                        END IF;
                        
                        
                        N_CK_SAVE   := 0;
                        DATA_REG    := x"00" & DATA_REG(19 DOWNTO 1);
                        DIR_REG     := x"0000" & DIR_REG(19 DOWNTO 1);
                        num_DATOS   := num_DATOS - 1;
                        
                        --Se han mandando todos los datos
                        IF(num_DATOS = 0)THEN 
                            GUARDAR := '0';
                        END IF;
                    END IF;
                    
                --Ha pasado el tiempo necesario para empezar a guardar
                ELSIF((GUARDAR = '0') AND (N_CK_SAVE = 150000))THEN 
                    GUARDAR   := '1';
                    N_CK_SAVE := 0;
                END IF;
            END IF;
        END IF;
        
        sn_OE    <= (NOT(n_BACK)) AND (NOT(sn_BREQ)) ;
        s_D_OUT  <= DATA_REG(0);
        s_DIR    <= DIR_REG(0);
        n_BREQ   <= sn_BREQ;
        n_RST    <= sn_RST;
        led      <= s_led;
        
        
    END PROCESS MAIN;
    
    
    TRIESTADO: PROCESS(sn_OE, s_D_OUT, s_DIR, sn_WR, sn_RD) BEGIN
        
        --No se activa la salida
        IF(sn_OE = '0')THEN
            D_OUT <= (OTHERS => 'Z');
            DIR   <= (OTHERS => 'Z');
            n_WR_MEM <= 'Z';
            n_RD_MEM <= 'Z';
        --Se activa la salida
        ELSIF(sn_OE = '1')THEN
            D_OUT <= s_D_OUT;
            DIR   <= s_DIR;
            n_WR_MEM <= sn_WR;
            n_RD_MEM <= sn_RD;
        END IF;
    
    END PROCESS TRIESTADO;


END Behavioral;
