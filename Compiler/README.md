# **Instrucciones de uso del compilador**
Estas son las instrucciones y normas de uso del compilador
## Sintaxis de los programas
1. Solo puede contener caracteres alfanuméricos.
2. Las instrucciones admitidas se encuentran en el archivo "Instrucciones.pdf"
3. Los operandos se separan por una coma sin espacios. *Por ejemplo: COP  A,B*
4. El fomato numerico admitido es el hexadecimal. *No se admite el binario, decimal, etc.*
5. Existen instrucciones especificas para el compilador, estas son:
   + **EQU:** Asocia un valor a una etiqueta, esta no puede ser de mas de 20 caracteres. Por ejemplo:  
     ```
     INI  EQU  0xFFF0
     ```
     Asigna el valor 0xFFF0 a la etiqueta llamada INI.
   + **ORG:** Indica la direccion donde se empezaran a guardar las siguientes instrucciones. Por ejemplo:
     ```
     INI  EQU  0xFFF0
          ORG  INI
     ```
     Guarda las siguientes instrucciones del programa apartir de la dirección almacenada en la etiqueta INI.
   + **DB:**  Almacena valores numéricos especificados por el usuario en la memoria. Estos tiene que ser de como maximo un byte y se separan por ",". Por ejemplo:
     ```
     TABLA  EQU  0x00F0
            ORG  TABLA
            DB   0x00,0xFF,0xAA,0xAF,0x12,0x23,0xBC
     ```
     Almacena los datos 0x00, 0xFF, 0xAA, 0xAF, 0x12, 0x23 y 0xBC en direcciones de memoria sucesivas, a partir de la establecida por la etiqueta "TABLA".
     
6. Los valores númericos no se admiten en los operandos de las instrucciones, se deben declaran antes con etiquetas y usarse las etiquetas en las instrucciones.
7. Las etiquetas solo se pueden declarar una vez.
8. Las etiquetas solo pueden ser de 20 caracteres y siempre deben comenzar por una letra.
9. Hay dos tipos distintos de etiquetas:
   + **Etiqueta estática.** Se declaran por medio de EQU y son de 1 o 2 bytes.
   + **Etiqueta dinámica.** Se coloca en una línea del programa, antes de la instruccion, y en la etiqueta se almacena el valor de la direccion de memoria donde se encuentra esa línea de código. Son siempre etiquetas de dos bytes porque se refieren a direcciones de memoria. Por ejemplo:
     ```
     INI    EQU  0xFFF0
            ORG  INI
     MAIN:  COP  A,B
            AND  A,C
     ```
     En este caso la etiqueta "MAIN" contendria la direccion de memoria donde se almacena la instruccion "COP A,B", que es la direccion 0xFFF0.
10. El compilador distingue entre mayúsculas y minúsculas.
11. Las etiquetas estáticas deben colocarse siempre al incio del programa, en las primeras lineas del código.
12. Se pueden modificar los valores de las etiquetas en un rango de 0 a 9, pero solo en los operandos de los codigos de instrucción. Por ejemplo:
     ```
     VAR1   EQU  0x04
            COP  A,VAR1+1
     ```
     En este caso se guarda en el registro A el valor de la etiqueta VAR1 más uno, es dicir 0x05. También se pueden restar en un rango del 0 al 9.
13. Si una linea comienza con ";", esta sería una linea solamente de comentarios.
14. No se pueden usar los espacios, deben usarse los tabs.
15. La estructura de cada una lineas de código debe ser la siguiente:
    + La primera columa de la izquierda debe ser mayor de 2 tabs. Esta se usa para declarar las etiquetas.
    + La segunda columna se usa para el codigo de instrucción. Ocupa los espacios que sea necesario y termina siempre en un tab.
    + En la tercera columna se colocan los operandos.
    + En la cuarta columna se escriben los comentarios, empezando siempre con un ";".
16. El compilador genera un fichero("Nombre de fichero de origen"_errores.txt) de errores en el directorio del archivo de programa.
17. El compilador genera un fichero("Nombre de fichero de origen"_out.txt) con los datos que va a guaradr en la memoria. Los dos primeros bytes de cada línea indican la dirección de la meoria del programa donde se guarada el tercer byte de la línea.  
  




