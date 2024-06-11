----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2022 08:44:24
-- Design Name: 
-- Module Name: Registro_Contador_16bits_IP - Behavioral
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

ENTITY Registro_Contador_16bits_CargaSincrona IS
    PORT( 
        --Se declaran las entradas 
        D:      IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        CK:     IN  STD_LOGIC;
        n_OE:   IN  STD_LOGIC;
        WR:     IN  STD_LOGIC;
        n_INC:  IN  STD_LOGIC;
        --Se declaran las salidas
        Q:      OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Registro_Contador_16bits_CargaSincrona;


ARCHITECTURE Behavioral OF Registro_Contador_16bits_CargaSincrona IS
    SIGNAL CUENTA:  UNSIGNED (15 DOWNTO 0); --Valor del registro.
BEGIN
    PROCESS (CK)
        BEGIN
        --Si se produce un flanco en CK
        IF rising_edge(CK) THEN
            IF WR='1' THEN
               --Si WR esta a nivel alto, se carga el registro
               CUENTA <= UNSIGNED(D);
            ELSE
               --Si no...
               IF n_INC ='1' THEN
                  --Decrementa la cuenta si /INC=1
                  CUENTA <= CUENTA - 1;
               ELSE
                  --Incrementa la cuenta si /INC=0
                  CUENTA <= CUENTA + 1;
               END IF;
            END IF;
        END IF;
    END PROCESS;
    
    
    TRIESTADO: PROCESS(n_OE, CUENTA)
        BEGIN 
        IF(n_OE = '0') THEN
            --Si /OE = 0, salida=CUENTA
            Q <= STD_LOGIC_VECTOR(CUENTA);
        ELSE
            --Si /OE = 1, salida en alta impedancia
            Q <= (OTHERS => 'Z');
        END IF;
    END PROCESS TRIESTADO;

END Behavioral;
