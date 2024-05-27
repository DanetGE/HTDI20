%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <windows.h>


char          s_auxiliar[20];
char          dir_destino[20];
char          dir_origen[20];
uint16_t      PC = 65520;
char          var_name [1024] [20];
char          var_data [1024] [20];
int           var_cantidad = 0;
int           nlinea=1;
bool          error_codigo=false;
bool          error_linea=false;

FILE *out;
FILE *errores;
FILE *in;



/*Funcion para localizar una variable almacenada, si existe la variable devuelve la posicion en el array
y si no existe devuelve -1*/
int Find_Var(char var_in[20]){
    int Find = 0;         /*Indica si se a localizado la variable*/
    int Pos  = 0;         /*Indica la posicion del array donde esta buscando la variable*/               
    int result = 1;       

    /*Bucle para localizar la variable*/
    while(Find == 0){
    
    /*Es la variable "var_in" igual que la variable que se encuentra en la posicion "Pos"*/
    if((strcmp(var_in, var_name[Pos]) == 0) && (Pos < var_cantidad)){
      Find = 1;
      return Pos;
    }
    /*Si "Pos" es igual a "var_cantidad" es que no se ha guardado antes la variable*/
    else if((Pos == var_cantidad)){
      Find = 1;
      return -1;
    }
    Pos ++;
  }
}


/*Funcion para guardar variables nuevas declaras con "EQU". En caso de ya existir, se actualizaria el valor*/
void Guardar_Variable(){
    char name[20];
    char data[20];
    char auxiliar[20];
    int Pos  = 0;

    
    sscanf(yytext, "%s\tEQU\t0x%s", name, data);    /*Se obtine el nombre y el valor de la variable*/

    Pos = Find_Var(name);                           /*Se busca si la variable ya se a definido antes*/

    /*NO se a declarado antes*/
    if(Pos == -1){
        strcpy(var_name[var_cantidad], name);        /*var_name[var_cantidad] = name*/
        strcpy(var_data[var_cantidad], data);        /*var_data[var_cantidad] = data*/
        var_cantidad++;
    }
    /*Se a declarado antes, se actualiza el valor*/
    else{
        strcpy(var_data[Pos], data);                 /*var_data[Pos] = data*/
    }

}


/*Funcion para imprimir int en valor Hexadecimal*/
void Int_to_HEX(uint16_t int_val, char s_out[20], int N_Bytes){

    if(N_Bytes == 2){
        if(int_val < 16){
            sprintf(s_out, "000%X", int_val);   /*Se guarda el valor hexa del int en s_out*/
        }
        else if(int_val < 256){
            sprintf(s_out, "00%X", int_val);    /*Se guarda el valor hexa del int en s_out*/
        }
        else if(int_val < 4096){
            sprintf(s_out, "0%X", int_val);     /*Se guarda el valor hexa del int en s_out*/
        }
        else{
            sprintf(s_out, "%X", int_val);      /*Se guarda el valor hexa del int en s_out*/
        }
    }
    else if(N_Bytes == 1){
        if(int_val < 16){
            sprintf(s_out, "0%X", int_val);     /*Se guarda el valor hexa del int en s_out*/
        }
        else if(int_val < 256){
            sprintf(s_out, "%X", int_val);      /*Se guarda el valor hexa del int en s_out*/
        }
    }
}


/*Funcion para imprimir el valor HEX de la instruccion juntos con la direccion de destino de la memoria*/
void Imprimir_HEX_Instruccion(char Codigo_Inst[2], int N_Bytes_destino, int N_Bytes_origen){
    char s_auxiliar[20];
    Int_to_HEX(PC, s_auxiliar, 2);  /*Se convierte la direccion de la memoria donde va el byte en HEX*/
    fprintf(out, "%s", s_auxiliar);       /*Se imprime la direccion de la memoria donde va el byte*/
    PC++;
    fprintf(out, "%s\n", Codigo_Inst);    /*Se imprime el valor hexa del codigo de instruccion*/
    
    /*Bucle para escribir los bytes de la direccion de destino*/
    int i=0;
    for(i=0; i<N_Bytes_destino; i++){
        Int_to_HEX(PC, s_auxiliar, 2);  /*Se convierte la direccion de la memoria donde va el byte en HEX*/
        fprintf(out, "%s", s_auxiliar);       /*Se imprime la direccion de la memoria donde va el byte*/
        PC++;
        fprintf(out, "%c%c\n", dir_destino[(N_Bytes_destino*2)-(i*2+2)], dir_destino[(N_Bytes_destino*2)-(i*2+1)]);   /*Se imprime el valor HEX de la direccion de destino*/
    }

    /*Bucle para escribir los bytes de la direccion de origen*/
    for(i=0; i<N_Bytes_origen; i++){
        Int_to_HEX(PC, s_auxiliar, 2);  /*Se convierte la direccion de la memoria donde va el byte en HEX*/
        fprintf(out, "%s", s_auxiliar);       /*Se imprime la direccion de la memoria donde va el byte*/
        PC++;
        fprintf(out, "%c%c\n", dir_origen[(N_Bytes_origen*2)-((i*2)+2)], dir_origen[(N_Bytes_origen*2)-((i*2)+1)]);   /*Se imprime el valor HEX de la direccion de origen*/
    }
}


/*Imprime el valor HEX de la instruccion*/
void Imprimir_Instruccion(char Codigo_Inst[2], int N_Bytes_destino, int N_Bytes_origen){
    int         Pos = 0;
    int         Suma = 0;
    int         Resta = 0;
    int         Tamaño = 0;
    uint16_t    Resultado = 0;
    bool        Error = false;

    /*Hay bytes de destino para imprimir*/
    if(N_Bytes_destino > 0){
        /*Esta en haxadecimal*/
        if((dir_destino[0] == '0') && (dir_destino[1] == 'x')){
            error_codigo = true;
            fprintf(errores, "Linea %d: No se admiten los valores numéricos en la direccion de destino.\n", nlinea);  /*Se imprime el error*/
            Error = true;   /*Se indica que ha habido un error*/
        }
        /*Es una variable*/
        else{
            Tamaño = strlen(dir_destino);
            /*Se combrueba si se va a sumar algun valor a la variable*/
            if(strchr(dir_destino, '+') != NULL){
                Suma = (int)(dir_destino[Tamaño-1]-'0');            /*Se obtiene el valor a sumar*/
                dir_destino[Tamaño - 1] = '\0';                     /*Se elimina el valor a sumar de dir_destino*/
                dir_destino[Tamaño - 2] = '\0';                     /*Se elimina el signo "+" de dir_destino*/
            }
            /*Se combrueba si se va a restar algun valor a la variable*/
            else if(strchr(dir_destino, '-') != NULL){
                Resta = (int)(dir_destino[Tamaño-1]-'0');           /*Se obtiene el valor a restar*/
                dir_destino[Tamaño - 1] = '\0';                     /*Se elimina el valor a restar de dir_destino*/
                dir_destino[Tamaño - 2] = '\0';                     /*Se elimina el signo "-" de dir_destino*/
            }
            else{}

            Pos = Find_Var(dir_destino);                            /*Se busca la variable*/

            /*NO existe ese nombre de variable*/
            if(Pos == -1){
                error_codigo = true;
                fprintf(errores, "Linea %d: No existe la variable %s.\n", nlinea, dir_destino);  /*Se imprime el error*/
                Error = true;   /*Se indica que ha habido un error*/
            }
            /*SI existe ese nombre de variable*/
            else{

                Tamaño = strlen(var_data[Pos]);                     /*Se obtiene el tamaño de la variable*/

                /*La variable tiene los bytes que necesita la instruccion*/
                if(Tamaño == (N_Bytes_destino*2)){
                    Resultado = strtol(var_data[Pos], NULL, 16) + Suma - Resta;     /*Se realiza la suma y resta*/
                    Int_to_HEX(Resultado, dir_destino, N_Bytes_destino);            /*Se imprime el valor HEX de la direccion*/
                }
                /*La variable es de menor tamaño que la que usa el nemonico*/
                else if(Tamaño < (N_Bytes_destino*2)){
                    error_codigo = true;
                    fprintf(errores, "Linea %d: La variable %s es de 1 byte y el nemonico usa una variable de 2 bytes.\n", nlinea, dir_destino);
                    Error = true;   /*Se indica que ha habido un error*/
                }
                /*La variable es de mayor tamaño que la que usa el nemonico*/
                else if(Tamaño > (N_Bytes_destino*2)){
                    error_codigo = true;
                    fprintf(errores, "Linea %d: La variable %s es de 2 bytes y el nemonico usa una variable de 1 byte.\n", nlinea, dir_destino);
                    Error = true;   /*Se indica que ha habido un error*/
                }  
            }
        }
    }
    else{}


    /*Hay bytes de origen para imprimir*/
    if(N_Bytes_origen > 0){
        /*Esta en haxadecimal*/
        if((dir_origen[0] == '0') && (dir_origen[1] == 'x')){
            error_codigo = true;
            fprintf(errores, "Linea %d: No se admiten los valores numéricos en la direccion de origen.\n", nlinea);  /*Se imprime el error*/
            Error = true;   /*Se indica que ha habido un error*/
        }
        /*Es una variable*/
        else{
            Tamaño = strlen(dir_origen);
            /*Se combrueba si se va a sumar algun valor a la variable*/
            if(strchr(dir_origen, '+') != NULL){
                Suma = (int)(dir_origen[Tamaño-1]-'0');            /*Se obtiene el valor a sumar*/
                dir_origen[Tamaño - 1] = '\0';                     /*Se elimina el valor a sumar de dir_destino*/
                dir_origen[Tamaño - 2] = '\0';                     /*Se elimina el signo "+" de dir_destino*/
            }
            /*Se combrueba si se va a restar algun valor a la variable*/
            else if(strchr(dir_origen, '-') != NULL){
                Resta = (int)(dir_origen[Tamaño-1]-'0');           /*Se obtiene el valor a restar*/
                dir_origen[Tamaño - 1] = '\0';                     /*Se elimina el valor a restar de dir_destino*/
                dir_origen[Tamaño - 2] = '\0';                     /*Se elimina el signo "-" de dir_destino*/
            }
            else{}

            Pos = Find_Var(dir_origen);                            /*Se busca la variable*/

            /*NO existe ese nombre de variable*/
            if(Pos == -1){
                error_codigo = true;
                fprintf(errores, "Linea %d: No existe la variable %s.\n", nlinea, dir_origen);  /*Se imprime el error*/
                Error = true;   /*Se indica que ha habido un error*/
            }
            /*SI existe ese nombre de variable*/
            else{
                
                Tamaño = strlen(var_data[Pos]);                     /*Se obtiene el tamaño de la variable*/

                /*La variable tiene los bytes que necesita la instruccion*/
                if(Tamaño == (N_Bytes_origen*2)){
                    Resultado = strtol(var_data[Pos], NULL, 16) + Suma - Resta;     /*Se realiza la suma y resta*/
                    Int_to_HEX(Resultado, dir_origen, N_Bytes_origen);              /*Se imprime el valor HEX de la direccion*/
                }
                /*La variable es de menor tamaño que la que usa el nemonico*/
                else if(Tamaño < (N_Bytes_origen*2)){
                    error_codigo = true;
                    fprintf(errores, "Linea %d: La variable %s es de 1 byte y el nemonico usa una variable de 2 bytes.\n", nlinea, dir_origen);
                    Error = true;   /*Se indica que ha habido un error*/
                }
                /*La variable es de mayor tamaño que la que usa el nemonico*/
                else if(Tamaño > (N_Bytes_origen*2)){
                    error_codigo = true;
                    fprintf(errores, "Linea %d: La variable %s es de 2 bytes y el nemonico usa una variable de 1 byte.\n", nlinea, dir_origen);
                    Error = true;   /*Se indica que ha habido un error*/
                }
            }
        }
    }
    else{}

    if(Error == false){
        Imprimir_HEX_Instruccion(Codigo_Inst, N_Bytes_destino, N_Bytes_origen); /*Se imprime la instruccion con la direccion de la memoria a la que va*/
    }
    else{}

}

/*Funcion para guardar las etiquetas*/
void Guardar_Etiqueta(){
    char name[20];
    char data[20];
    char s_auxiliar[200];
    int Pos  = 0;
    
    sscanf(yytext, "%s:\t", name);  /*Se obtine el nombre y el valor de la etiqueta*/
    name[strlen(name)-1] = '\0';

    Pos = Find_Var(name);           /*Se busca si la etiqueta ya se a definido antes*/

    /*NO se a declarado antes*/
    if(Pos == -1){
        sprintf(data, "%X", PC);                /*Se convierte "PC" en HEX y se guarda en "data"*/
        strcpy(var_name[var_cantidad], name);
        strcpy(var_data[var_cantidad], data);
        var_cantidad++;
    }
    /*Se a declarado antes, no puede haber dos etiquetas iguales*/
    else{
        error_codigo = true;
        fprintf(errores, "Linea %d: Ya existe la equieta %s", nlinea, name);  /*Se imprime el error*/
    }
}


/*Funcion para actializar el valor de PC, por el nuevo suministrado por "ORG"*/
void New_PC(){
    char        *s_subcadena;
    int         Tamaño = 0;
    int         Suma = 0;
    int         Resta = 0;
    int         Pos = 0;

    s_subcadena = strchr(yytext, '\t');
    strcpy(dir_destino, s_subcadena + 1);   /*Se elimina el '\t' de la cadena*/

    /*Esta en haxadecimal*/
    if((dir_destino[0] == '0') && (dir_destino[1] == 'x')){
        error_codigo = true;
        fprintf(errores, "Linea %d: No se admiten los valores numéricos en la direccion de destino.\n", nlinea);  /*Se imprime el error*/
    }
    else{

        Tamaño = strlen(dir_destino);           /*Se obtiene el tamaño de la cadena dir_destino*/

        /*Se combrueba si se va a sumar algun valor a la variable*/
        if(strchr(dir_destino, '+') != NULL){
            Suma = (int)(dir_destino[Tamaño-1]-'0');            /*Se obtiene el valor a sumar*/
            dir_destino[Tamaño - 1] = '\0';                     /*Se elimina el valor a sumar de dir_destino*/
            dir_destino[Tamaño - 2] = '\0';                     /*Se elimina el signo "+" de dir_destino*/
        }
        /*Se combrueba si se va a restar algun valor a la variable*/
        else if(strchr(dir_destino, '-') != NULL){
            Resta = (int)(dir_destino[Tamaño-1]-'0');           /*Se obtiene el valor a restar*/
            dir_destino[Tamaño - 1] = '\0';                     /*Se elimina el valor a restar de dir_destino*/
            dir_destino[Tamaño - 2] = '\0';                     /*Se elimina el signo "-" de dir_destino*/
        }
        else{}

        Pos = Find_Var(dir_destino);                            /*Se busca la variable*/

        /*NO existe ese nombre de variable*/
        if(Pos == -1){
            error_codigo = true;
            fprintf(errores, "Linea %d: No existe la variable %s.\n", nlinea, dir_destino);  /*Se imprime el error*/
        }
        /*SI existe ese nombre de variable*/
        else{
                
            Tamaño = strlen(var_data[Pos]);                     /*Se obtiene el tamaño de la variable*/

            /*La variable tiene los bytes que necesita la instruccion*/
            if(Tamaño == 4){
                PC = strtol(var_data[Pos], NULL, 16) + Suma - Resta;     /*Se realiza la suma y resta y se actualiza PC*/
            }
            /*La variable es de menor tamaño que la que usa el nemonico*/
            else if(Tamaño < 4){
                error_codigo = true;
                fprintf(errores, "Linea %d: La variable %s es de 1 byte y el nemonico usa una variable de 2 bytes.\n", nlinea, dir_origen);
            }
        }
    }
}


/*Funcion para interpretar los nemonicos y extraer los datos y direcciones e imprimir todo*/
void Interpretar_nemonico(char Codigo_Inst[2], char start_dir_destino, int N_Bytes_destino, char end_dir_destino, char start_dir_origen, int N_Bytes_origen, char end_dir_origen){
    char    *s_subcadena;
    int     Tamaño = 0;
    int     Pos = 1;
    int     Find = 0;

    if(N_Bytes_destino > 0){
        s_subcadena = strchr(yytext, start_dir_destino);
        strcpy(dir_destino, s_subcadena + 1);               /*Se elimina el start_dir_destino de la cadena*/

        Tamaño = strlen(dir_destino);
        while(((end_dir_destino == end_dir_origen) && (Find < 2)) || ((Find < 1) && (end_dir_destino != '\0'))){
            if(dir_destino[Tamaño-Pos] == end_dir_destino){
                Find++;
            }
            dir_destino[Tamaño-Pos] = '\0';
            Pos++;
        }
    }
    
    if(N_Bytes_origen > 0){
        s_subcadena = strrchr(yytext, start_dir_origen);
        strcpy(dir_origen, s_subcadena + 1);                /*Se elimina el start_dir_origen de la cadena*/

        Pos = 1;
        Find = 0;
        Tamaño = strlen(dir_origen);

        while((Find < 1) && (end_dir_origen != '\0')){
            if(dir_origen[Tamaño-Pos] == end_dir_origen){
                Find++;
            }
            dir_origen[Tamaño-Pos] = '\0';
            Pos++;
        }
    }

    Imprimir_Instruccion(Codigo_Inst, N_Bytes_destino, N_Bytes_origen);
}


/*Funcion para guardar datos en memoria*/
void DB(){
    char    *s_subcadena;
    char    dato[3];
    int     Tamaño = 0;
    int     Pos=0;

    s_subcadena = strchr(yytext,'\t');
    strcpy(s_subcadena, s_subcadena + 1);               /*Se elimina el \t de la cadena*/

    Tamaño = (strlen(s_subcadena));
    Tamaño = (Tamaño+1)/5;

    int i=0;
    for(i=0; i<Tamaño; i++){

        Pos = 2+(i*5);
        strncpy(dato, s_subcadena + Pos, 2);
        dato[2] = '\0';
        Imprimir_HEX_Instruccion(dato,0,0);

    }
}


/*Funcion para convertir caracteres a hexadecimal de un byte*/
int Char_to_Hex(char char1, char char2){

    /*Es un numero*/
    if((char1 >= '0') && (char1 <= '9')){
        char1 = char1 - '0';
    }
    /*Es una letra entre la A y la F*/
    else if((char1 >= 'A') && (char1 <= 'F')){
        char1 = char1 - 'A' + 10;
    }


    /*Es un numero*/
    if((char2 >= '0') && (char2 <= '9')){
        char2 = char2 - '0';
    }
    /*Es una letra entre la A y la F*/
    else if((char2 >= 'A') && (char2 <= 'F')){
        char2 = char2 - 'A' + 10;
    }

    return (char1*16) + char2;

}


/*Funcion para enviar el programa por puerto serie al uP*/
int Enviar_datos_Puerto_Serie(char N_Puerto[2]){

    /*Se definen las variables que va a usar la funcion*/
    char Nombre_COM[20];
    char bytes_to_send[3];
    char linea_archivo[20];
    float  n_bytes_programa = 0;

    HANDLE Puerto_COM;
    DCB dcbSerialParams = {0};
    COMMTIMEOUTS timeouts = {0};

    /*Se genera el string con el numero del puerto COM suministrado*/
    sprintf(Nombre_COM, "\\\\.\\COM%s", N_Puerto);
 

    /*Abriendo el puerto serie solicitado por el usuario*/
    printf("Abriendo puerto serie...");
    Puerto_COM = CreateFile(
                Nombre_COM, GENERIC_READ|GENERIC_WRITE, 0, NULL,
                OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );

    /*No se ha podido abrir el puerto, se imprime el error*/
    if (Puerto_COM == INVALID_HANDLE_VALUE)
    {       
            printf("Error abriendo\n");
            system("pause");
            exit(-1);
    }
    /*Se ha podido abrir el puerto serie*/
    else printf("OK\n");
     

    /*Sew configura el puerto con un baud rate de 9600, un bit de parada y sin bit de paridad*/
    dcbSerialParams.DCBlength = sizeof(dcbSerialParams);

    /*No se ha obtenido una respuesta del puerto, se imprime el error*/
    if (GetCommState(Puerto_COM, &dcbSerialParams) == 0)
    {
        printf("Error obteniendo el estado del puerto\n");
        CloseHandle(Puerto_COM);
        system("pause");
        exit(-1);
    }
     
    dcbSerialParams.BaudRate = CBR_9600;
    dcbSerialParams.ByteSize = 8;
    dcbSerialParams.StopBits = ONESTOPBIT;
    dcbSerialParams.Parity = NOPARITY;
    /*No se ha podido configurar el puerto, se imprime el error*/
    if(SetCommState(Puerto_COM, &dcbSerialParams) == 0)
    {
        printf("Error configurando el puerto serie\n");
        CloseHandle(Puerto_COM);
        system("pause");
        exit(-1);
    }
    
    /*Se configuran los tiempos muertos del puerto serie*/
    timeouts.ReadIntervalTimeout = 50;
    timeouts.ReadTotalTimeoutConstant = 50;
    timeouts.ReadTotalTimeoutMultiplier = 10;
    timeouts.WriteTotalTimeoutConstant = 50;
    timeouts.WriteTotalTimeoutMultiplier = 10;
    /*No se ha podido configurar los tiempos muertos del puerto y se imprime el error*/
    if(SetCommTimeouts(Puerto_COM, &timeouts) == 0)
    {
        printf("Error ajustando los parametros de tiempos muertos\n");
        CloseHandle(Puerto_COM);
        system("pause");
        exit(-1);
    }
    

    /*Se envia el programa por el puerto serie*/
    DWORD bytes_written, total_bytes_written = 0;
    printf("Enviando el programa...");

    /*Se lee linea a linea el archivo con el codigo de programa, el archivo_out.txt*/
    while(fgets(linea_archivo, 8, out) != NULL){

        /*Se convierte la fila leida del _out.txt a hexadecimal*/
        bytes_to_send[0] = Char_to_Hex(linea_archivo[0], linea_archivo[1]);
        bytes_to_send[1] = Char_to_Hex(linea_archivo[2], linea_archivo[3]);
        bytes_to_send[2] = Char_to_Hex(linea_archivo[4], linea_archivo[5]);

        /*No se ha podido enviar, se imprime el error y se cierra el programa */
        if(!WriteFile(Puerto_COM, bytes_to_send, 3, &bytes_written, NULL))
        {
            printf("Error escribiendo\n");
            CloseHandle(Puerto_COM);
            system("pause");
            exit(-1);
        }

        n_bytes_programa++;        /*Se incrimenta el numero de bytes enviados*/

    }

    /*Se imprime el numero de bytes que se han mandado, si es menor de 1024 se pone en Bytes si es mayor o igual se pone en kB*/
    if(n_bytes_programa < 1024){
        printf("Se ha escrito el programa. %.0f Bytes\n\n", n_bytes_programa);
    }
    else{
        n_bytes_programa = n_bytes_programa/(1024.0);
        printf("Se ha escrito el programa. %.2f kBytes\n\n", n_bytes_programa);
    }
    
     
    /*Se cierra el puerto serie*/
    fprintf(stderr, "Cerrando el puerto serie...");
    /*No se ha podido cerrar el puerto serie*/
    if (CloseHandle(Puerto_COM) == 0)
    {
        printf("Error Cerrando\n");
        system("pause");
        exit(-1);
    }
    /*Se ha podido cerrar el puerto serie*/
    printf("OK\n");
}



%}


NOMBRE_VARIABLES    [A-Za-z]([A-WY-Z0-9a-z]{1,19})

NUMERO              [0-9]
DATOS_VARIABLES     (0x([A-F0-9]{2}))|(0x([A-F0-9]{4}))
DATOS_1BYTE         (0x([A-F0-9]{2}))
SUMA_RESTA          [+-]

DATA	            (0x([A-F0-9]{2}))|{NOMBRE_VARIABLES}|{NOMBRE_VARIABLES}{SUMA_RESTA}{NUMERO}
DIRECTION           (0x([A-F0-9]{4}))|{NOMBRE_VARIABLES}|{NOMBRE_VARIABLES}{SUMA_RESTA}{NUMERO}


%%

{NOMBRE_VARIABLES}(\t+)EQU\t{DATOS_VARIABLES}    Guardar_Variable(); /*Se guarda una etiqueta en el array de variables*/

ORG\t{DIRECTION}        New_PC();                   /*Se actualiza el valor de PC(La direccion base donde se va a guardar el codigo)*/

{NOMBRE_VARIABLES}":"   Guardar_Etiqueta();         /*Se guarda una etiqueta*/

DB\t{DATOS_1BYTE}((,{DATOS_1BYTE})*)        DB();   /*Se guardan los datos de un byte en la memoria en direcciones consecutivas*/


JPC\t{DIRECTION}        Interpretar_nemonico("00",'\t',2,'\0','\0',0,'\n'); /* 1 */

JPNC\t{DIRECTION}       Interpretar_nemonico("01",'\t',2,'\0','\0',0,'\n'); /* 2 */

JPZ\t{DIRECTION}        Interpretar_nemonico("02",'\t',2,'\0','\0',0,'\n'); /* 3 */

JPNZ\t{DIRECTION}       Interpretar_nemonico("03",'\t',2,'\0','\0',0,'\n'); /* 4 */

JPF0\t{DIRECTION}       Interpretar_nemonico("04",'\t',2,'\0','\0',0,'\n'); /* 5 */

JPNF0\t{DIRECTION}      Interpretar_nemonico("05",'\t',2,'\0','\0',0,'\n'); /* 6 */

JPF1\t{DIRECTION}       Interpretar_nemonico("06",'\t',2,'\0','\0',0,'\n'); /* 7 */

JPNF1\t{DIRECTION}      Interpretar_nemonico("07",'\t',2,'\0','\0',0,'\n'); /* 8 */

JPF2\t{DIRECTION}       Interpretar_nemonico("08",'\t',2,'\0','\0',0,'\n'); /* 9 */

JPNF2\t{DIRECTION}      Interpretar_nemonico("09",'\t',2,'\0','\0',0,'\n'); /* 10 */

JPF3\t{DIRECTION}       Interpretar_nemonico("0A",'\t',2,'\0','\0',0,'\n'); /* 11 */

JPNF3\t{DIRECTION}      Interpretar_nemonico("0B",'\t',2,'\0','\0',0,'\n'); /* 12 */



CALLC\t{DIRECTION}      Interpretar_nemonico("0C",'\t',2,'\0','\0',0,'\n'); /* 13 */

CALLNC\t{DIRECTION}     Interpretar_nemonico("0D",'\t',2,'\0','\0',0,'\n'); /* 14 */

CALLZ\t{DIRECTION}      Interpretar_nemonico("0E",'\t',2,'\0','\0',0,'\n'); /* 15 */

CALLNZ\t{DIRECTION}     Interpretar_nemonico("0F",'\t',2,'\0','\0',0,'\n'); /* 16 */



COP\tB,A                Interpretar_nemonico("10",'\t',0,'\0','\0',0,'\n'); /* 17 */

COP\tC,A                Interpretar_nemonico("11",'\t',0,'\0','\0',0,'\n'); /* 18 */

COP\tA,B                Interpretar_nemonico("12",'\t',0,'\0','\0',0,'\n'); /* 19 */

COP\tC,B                Interpretar_nemonico("13",'\t',0,'\0','\0',0,'\n'); /* 20 */

COP\tA,C                Interpretar_nemonico("14",'\t',0,'\0','\0',0,'\n'); /* 21 */

COP\tB,C                Interpretar_nemonico("15",'\t',0,'\0','\0',0,'\n'); /* 22 */

COP16\tE,D              Interpretar_nemonico("16",'\t',0,'\0','\0',0,'\n'); /* 23 */

COP16\tIX,D             Interpretar_nemonico("17",'\t',0,'\0','\0',0,'\n'); /* 24 */

COP16\tD,E              Interpretar_nemonico("18",'\t',0,'\0','\0',0,'\n'); /* 25 */

COP16\tIX,E             Interpretar_nemonico("19",'\t',0,'\0','\0',0,'\n'); /* 26 */

COP16\tD,IX             Interpretar_nemonico("1A",'\t',0,'\0','\0',0,'\n'); /* 27 */

COP16\tE,IX             Interpretar_nemonico("1B",'\t',0,'\0','\0',0,'\n'); /* 28 */



COP\tA,{DATA}           Interpretar_nemonico("1C",'\t',0,'\0',',',1,'\0'); /* 29 */

COP\tB,{DATA}           Interpretar_nemonico("1D",'\t',0,'\0',',',1,'\0'); /* 30 */

COP\tC,{DATA}           Interpretar_nemonico("1E",'\t',0,'\0',',',1,'\0');  /* 31 */

COP16\tD,{DIRECTION}    Interpretar_nemonico("1F",'\t',0,'\0',',',2,'\0');  /* 32 */

COP16\tE,{DIRECTION}    Interpretar_nemonico("20",'\t',0,'\0',',',2,'\0');  /* 33 */

COP16\tIX,{DIRECTION}   Interpretar_nemonico("21",'\t',0,'\0',',',2,'\0');  /* 34 */

COP16\tSP,{DIRECTION}   Interpretar_nemonico("22",'\t',0,'\0',',',2,'\0');  /* 35 */



COP\tA,"("{DIRECTION}")"    Interpretar_nemonico("23",'\t',0,'\0','(',2,')');   /* 36 */

COP\tB,"("{DIRECTION}")"    Interpretar_nemonico("24",'\t',0,'\0','(',2,')');   /* 37 */

COP\tC,"("{DIRECTION}")"    Interpretar_nemonico("25",'\t',0,'\0','(',2,')');   /* 38 */



COP\t"("{DIRECTION}")",A    Interpretar_nemonico("26",'(',2,')', '\0',0,'\n');  /* 39 */

COP\t"("{DIRECTION}")",B    Interpretar_nemonico("27",'(',2,')', '\0',0,'\n');  /* 40 */

COP\t"("{DIRECTION}")",C    Interpretar_nemonico("28",'(',2,')', '\0',0,'\n');  /* 41 */



COP\t"("{DIRECTION}")",{DATA}   Interpretar_nemonico("29",'(',2,')',',',1,'\0');    /* 42 */



COP\tA,"("D")"      Interpretar_nemonico("2A",'\0',0,'\0','\0',0,'\n');     /* 43 */

COP\tB,"("D")"      Interpretar_nemonico("2B",'\0',0,'\0','\0',0,'\n');     /* 44 */

COP\tC,"("D")"      Interpretar_nemonico("2C",'\0',0,'\0','\0',0,'\n');     /* 45 */

COP\tA,"("E")"      Interpretar_nemonico("2D",'\0',0,'\0','\0',0,'\n');     /* 45 */

COP\tB,"("E")"      Interpretar_nemonico("2E",'\0',0,'\0','\0',0,'\n');     /* 47 */

COP\tC,"("E")"      Interpretar_nemonico("2F",'\0',0,'\0','\0',0,'\n');     /* 48 */

COP\tA,"("IX")"     Interpretar_nemonico("30",'\0',0,'\0','\0',0,'\n');     /* 49 */

COP\tB,"("IX")"     Interpretar_nemonico("31",'\0',0,'\0','\0',0,'\n');     /* 50 */

COP\tC,"("IX")"     Interpretar_nemonico("32",'\0',0,'\0','\0',0,'\n');     /* 51 */



COP\t"("D")",A      Interpretar_nemonico("33",'\0',0,'\0','\0',0,'\n');     /* 52 */

COP\t"("E")",A      Interpretar_nemonico("34",'\0',0,'\0','\0',0,'\n');     /* 53 */

COP\t"("IX")",A     Interpretar_nemonico("35",'\0',0,'\0','\0',0,'\n');     /* 54 */

COP\t"("D")",B      Interpretar_nemonico("36",'\0',0,'\0','\0',0,'\n');     /* 55 */

COP\t"("E")",B      Interpretar_nemonico("37",'\0',0,'\0','\0',0,'\n');     /* 56 */

COP\t"("IX")",B     Interpretar_nemonico("38",'\0',0,'\0','\0',0,'\n');     /* 57 */

COP\t"("D")",C      Interpretar_nemonico("39",'\0',0,'\0','\0',0,'\n');     /* 58 */

COP\t"("E")",C      Interpretar_nemonico("3A",'\0',0,'\0','\0',0,'\n');     /* 59 */

COP\t"("IX")",C     Interpretar_nemonico("3B",'\0',0,'\0','\0',0,'\n');     /* 60 */



IN\tA,"("{DATA}")"  Interpretar_nemonico("3C",'\0',0,'\0','(',1,')');       /* 61 */

IN\tB,"("{DATA}")"  Interpretar_nemonico("3D",'\0',0,'\0','(',1,')');       /* 62 */

IN\tC,"("{DATA}")"  Interpretar_nemonico("3E",'\0',0,'\0','(',1,')');       /* 63 */

IN\tA,"("B")"       Interpretar_nemonico("3F",'\0',0,'\0','\0',0,'\n');     /* 64 */

IN\tA,"("C")"       Interpretar_nemonico("40",'\0',0,'\0','\0',0,'\n');     /* 65 */

IN\t"("{DIRECTION}")","("{DATA}")"      Interpretar_nemonico("41",'(',2,')','(',1,')');     /* 66 */



OUT\t"("{DATA}")",A         Interpretar_nemonico("42",'(',1,')','\0',0,'\0');       /* 67 */

OUT\t"("{DATA}")",B         Interpretar_nemonico("43",'(',1,')','\0',0,'\0');       /* 68 */

OUT\t"("{DATA}")",C         Interpretar_nemonico("44",'(',1,')','\0',0,'\0');       /* 69 */

OUT\t"("{DATA}")",{DATA}    Interpretar_nemonico("45",'(',1,')',',',1,'\0');        /* 70 */

OUT\t"("B")",A              Interpretar_nemonico("46",'\0',0,'\0','\0',1,'\n');     /* 71 */

OUT\t"("C")",A              Interpretar_nemonico("47",'\0',0,'\0','\0',1,'\n');     /* 72 */

OUT\t"("{DATA}")","("{DIRECTION}")"     Interpretar_nemonico("48",'(',1,')','(',2,')');     /* 73 */



COP\t"("{DIRECTION}")","("{DIRECTION}")"    Interpretar_nemonico("49",'(',2,')','(',2,')');     /* 74 */

COP\t"("E")","("D")"        Interpretar_nemonico("4A",'\0',0,'\0','\0',0,'\n');     /* 75 */

COP\t"("IX")","("D")"       Interpretar_nemonico("4B",'\0',0,'\0','\0',0,'\n');     /* 76 */

COP\t"("D")","("E")"        Interpretar_nemonico("4C",'\0',0,'\0','\0',0,'\n');     /* 77 */

COP\t"("IX")","("E")"       Interpretar_nemonico("4D",'\0',0,'\0','\0',0,'\n');     /* 78 */

COP\t"("D")","("IX")"       Interpretar_nemonico("4E",'\0',0,'\0','\0',0,'\n');     /* 79 */

COP\t"("E")","("IX")"       Interpretar_nemonico("4F",'\0',0,'\0','\0',0,'\n');     /* 80 */



COP16\t"("{DIRECTION}")",D      Interpretar_nemonico("50",'(',2,')','\0',0,'\n');   /* 81 */

COP16\t"("{DIRECTION}")",E      Interpretar_nemonico("51",'(',2,')','\0',0,'\n');   /* 82 */

COP16\t"("{DIRECTION}")",IX     Interpretar_nemonico("52",'(',2,')','\0',0,'\n');   /* 83 */

COP16\t"("{DIRECTION}")",SP     Interpretar_nemonico("53",'(',2,')','\0',0,'\n');   /* 84 */

COP16\tD,"("{DIRECTION}")"      Interpretar_nemonico("54",'\0',0,'\0','(',2,')');   /* 85 */

COP16\tE,"("{DIRECTION}")"      Interpretar_nemonico("55",'\0',0,'\0','(',2,')');   /* 86 */

COP16\tIX,"("{DIRECTION}")"     Interpretar_nemonico("56",'\0',0,'\0','(',2,')');   /* 87 */

COP16\tSP,"("{DIRECTION}")"     Interpretar_nemonico("57",'\0',0,'\0','(',2,')');   /* 88 */

COP16\t"("{DIRECTION}")",{DIRECTION}        Interpretar_nemonico("58",'(',2,')',',',2,'\0');    /* 89 */

COP16\t"("{DIRECTION}")","("{DIRECTION}")"  Interpretar_nemonico("59",'(',2,')','(',2,')');     /* 90 */



PUSH\tA     Interpretar_nemonico("5A",'\0',0,'\0','\0',0,'\n');     /* 91 */

PUSH\tB     Interpretar_nemonico("5B",'\0',0,'\0','\0',0,'\n');     /* 92 */

PUSH\tC     Interpretar_nemonico("5C",'\0',0,'\0','\0',0,'\n');     /* 93 */

PUSH\tPSW   Interpretar_nemonico("5D",'\0',0,'\0','\0',0,'\n');     /* 94 */

PUSH\tD     Interpretar_nemonico("5E",'\0',0,'\0','\0',0,'\n');     /* 95 */

PUSH\tE     Interpretar_nemonico("5F",'\0',0,'\0','\0',0,'\n');     /* 96 */

PUSH\tIX    Interpretar_nemonico("60",'\0',0,'\0','\0',0,'\n');     /* 97 */

PUSH\tPC    Interpretar_nemonico("61",'\0',0,'\0','\0',0,'\n');     /* 98 */



POP\tA      Interpretar_nemonico("62",'\0',0,'\0','\0',0,'\n');     /* 99 */

POP\tB      Interpretar_nemonico("63",'\0',0,'\0','\0',0,'\n');     /* 100 */

POP\tC      Interpretar_nemonico("64",'\0',0,'\0','\0',0,'\n');     /* 101 */

POP\tPSW    Interpretar_nemonico("65",'\0',0,'\0','\0',0,'\n');     /* 102 */

POP\tD      Interpretar_nemonico("66",'\0',0,'\0','\0',0,'\n');     /* 103 */

POP\tE      Interpretar_nemonico("67",'\0',0,'\0','\0',0,'\n');     /* 104 */

POP\tIX     Interpretar_nemonico("68",'\0',0,'\0','\0',0,'\n');     /* 105 */

POP\tPC     Interpretar_nemonico("69",'\0',0,'\0','\0',0,'\n');     /* 106 */



AND\tA,A        Interpretar_nemonico("6A",'\0',0,'\0','\0',0,'\n');     /* 107 */

AND\tA,B        Interpretar_nemonico("6B",'\0',0,'\0','\0',0,'\n');     /* 108 */

AND\tA,C        Interpretar_nemonico("6C",'\0',0,'\0','\0',0,'\n');     /* 109 */

AND\tA,{DATA}   Interpretar_nemonico("6D",'\0',0,'\n',',',1,'\0');      /* 110 */



OR\tA,A         Interpretar_nemonico("6E",'\0',0,'\0','\0',0,'\n');     /* 111 */

OR\tA,B         Interpretar_nemonico("6F",'\0',0,'\0','\0',0,'\n');     /* 112 */

OR\tA,C         Interpretar_nemonico("70",'\0',0,'\0','\0',0,'\n');     /* 113 */

OR\tA,{DATA}    Interpretar_nemonico("71",'\0',0,'\n',',',1,'\0');      /* 114 */



XOR\tA,A        Interpretar_nemonico("72",'\0',0,'\0','\0',0,'\n');     /* 115 */

XOR\tA,B        Interpretar_nemonico("73",'\0',0,'\0','\0',0,'\n');     /* 116 */

XOR\tA,C        Interpretar_nemonico("74",'\0',0,'\0','\0',0,'\n');     /* 117 */

XOR\tA,{DATA}   Interpretar_nemonico("75",'\0',0,'\n',',',1,'\0');      /* 118 */



INV\tA          Interpretar_nemonico("76",'\0',0,'\0','\0',0,'\n');     /* 119 */

SL\tA           Interpretar_nemonico("77",'\0',0,'\0','\0',0,'\n');     /* 120 */

SR\tA           Interpretar_nemonico("78",'\0',0,'\0','\0',0,'\n');     /* 121 */

SLC\tA          Interpretar_nemonico("79",'\0',0,'\0','\0',0,'\n');     /* 122 */

SRC\tA          Interpretar_nemonico("7A",'\0',0,'\0','\0',0,'\n');     /* 123 */

RL\tA           Interpretar_nemonico("7B",'\0',0,'\0','\0',0,'\n');     /* 124 */

RR\tA           Interpretar_nemonico("7C",'\0',0,'\0','\0',0,'\n');     /* 125 */

RLC\tA          Interpretar_nemonico("7D",'\0',0,'\0','\0',0,'\n');     /* 126 */

RRC\tA          Interpretar_nemonico("7E",'\0',0,'\0','\0',0,'\n');     /* 127 */



ADD\tA,A        Interpretar_nemonico("7F",'\0',0,'\0','\0',0,'\n');     /* 128 */

ADD\tA,B        Interpretar_nemonico("80",'\0',0,'\0','\0',0,'\n');     /* 129 */

ADD\tA,C        Interpretar_nemonico("81",'\0',0,'\0','\0',0,'\n');     /* 130 */

ADD\tA,{DATA}   Interpretar_nemonico("82",'\0',0,'\n',',',1,'\0');      /* 131 */

ADD\tA,"("{DIRECTION}")"    Interpretar_nemonico("83",'\0',0,'\n','(',2,')');      /* 132 */

ADD\tA,"("D")"      Interpretar_nemonico("84",'\0',0,'\0','\0',0,'\n');      /* 133 */

ADD\tA,"("E")"      Interpretar_nemonico("85",'\0',0,'\0','\0',0,'\n');      /* 134 */

ADD\tA,"("IX")"     Interpretar_nemonico("86",'\0',0,'\0','\0',0,'\n');      /* 135 */



SUB\tA,A        Interpretar_nemonico("87",'\0',0,'\0','\0',0,'\n');     /* 136 */

SUB\tA,B        Interpretar_nemonico("88",'\0',0,'\0','\0',0,'\n');     /* 137 */

SUB\tA,C        Interpretar_nemonico("89",'\0',0,'\0','\0',0,'\n');     /* 138 */

SUB\tA,{DATA}   Interpretar_nemonico("8A",'\0',0,'\n',',',1,'\0');      /* 139 */

SUB\tA,"("{DIRECTION}")"    Interpretar_nemonico("8B",'\0',0,'\n','(',2,')');      /* 140 */

SUB\tA,"("D")"      Interpretar_nemonico("8C",'\0',0,'\0','\0',0,'\n');      /* 141 */

SUB\tA,"("E")"      Interpretar_nemonico("8D",'\0',0,'\0','\0',0,'\n');      /* 142 */

SUB\tA,"("IX")"     Interpretar_nemonico("8E",'\0',0,'\0','\0',0,'\n');      /* 143 */



INC\tA          Interpretar_nemonico("8F",'\0',0,'\0','\0',0,'\n');     /* 144 */

INC\tB          Interpretar_nemonico("90",'\0',0,'\0','\0',0,'\n');     /* 145 */

INC\tC          Interpretar_nemonico("91",'\0',0,'\0','\0',0,'\n');     /* 146 */

INC\t"("D")"    Interpretar_nemonico("92",'\0',0,'\0','\0',0,'\n');     /* 147 */

INC\t"("E")"    Interpretar_nemonico("93",'\0',0,'\0','\0',0,'\n');     /* 148 */

INC\t"("IX")"   Interpretar_nemonico("94",'\0',0,'\0','\0',0,'\n');     /* 149 */

INC\t"("{DIRECTION}")"    Interpretar_nemonico("95",'\0',0,'\n','(',2,')');      /* 150 */



INC16\tD        Interpretar_nemonico("96",'\0',0,'\0','\0',0,'\n');     /* 151 */

INC16\tE        Interpretar_nemonico("97",'\0',0,'\0','\0',0,'\n');     /* 152 */

INC16\tIX       Interpretar_nemonico("98",'\0',0,'\0','\0',0,'\n');     /* 153 */

INC16\t"("D")"  Interpretar_nemonico("99",'\0',0,'\0','\0',0,'\n');     /* 154 */

INC16\t"("E")"  Interpretar_nemonico("9A",'\0',0,'\0','\0',0,'\n');     /* 155 */

INC16\t"("IX")" Interpretar_nemonico("9B",'\0',0,'\0','\0',0,'\n');     /* 156 */

INC16\t"("{DIRECTION}")"    Interpretar_nemonico("9C",'\0',0,'\n','(',2,')');      /* 157 */



DEC\tA          Interpretar_nemonico("9D",'\0',0,'\0','\0',0,'\n');     /* 158 */

DEC\tB          Interpretar_nemonico("9E",'\0',0,'\0','\0',0,'\n');     /* 159 */

DEC\tC          Interpretar_nemonico("9F",'\0',0,'\0','\0',0,'\n');     /* 160 */

DEC\t"("D")"    Interpretar_nemonico("A0",'\0',0,'\0','\0',0,'\n');     /* 161 */

DEC\t"("E")"    Interpretar_nemonico("A1",'\0',0,'\0','\0',0,'\n');     /* 162 */

DEC\t"("IX")"   Interpretar_nemonico("A2",'\0',0,'\0','\0',0,'\n');     /* 163 */

DEC\t"("{DIRECTION}")"    Interpretar_nemonico("A3",'\0',0,'\n','(',2,')');      /* 164 */



DEC16\tD        Interpretar_nemonico("A4",'\0',0,'\0','\0',0,'\n');     /* 165 */

DEC16\tE        Interpretar_nemonico("A5",'\0',0,'\0','\0',0,'\n');     /* 166 */

DEC16\tIX       Interpretar_nemonico("A6",'\0',0,'\0','\0',0,'\n');     /* 167 */

DEC16\t"("D")"  Interpretar_nemonico("A7",'\0',0,'\0','\0',0,'\n');     /* 168 */

DEC16\t"("E")"  Interpretar_nemonico("A8",'\0',0,'\0','\0',0,'\n');     /* 169 */

DEC16\t"("IX")" Interpretar_nemonico("A9",'\0',0,'\0','\0',0,'\n');     /* 170 */

DEC16\t"("{DIRECTION}")"    Interpretar_nemonico("AA",'\0',0,'\n','(',2,')');      /* 171 */



JMP\t{DIRECTION}    Interpretar_nemonico("AB",'\t',2,'\0','\0',0,'\n');      /* 172 */

CALL\t{DIRECTION}   Interpretar_nemonico("AC",'\t',2,'\0','\0',0,'\n');      /* 173 */

RETURN      Interpretar_nemonico("AD",'\0',0,'\0','\0',0,'\n');      /* 174 */

RETINT      Interpretar_nemonico("AE",'\0',0,'\0','\0',0,'\n');      /* 175 */

EI          Interpretar_nemonico("AF",'\0',0,'\0','\0',0,'\n');      /* 176 */

DI          Interpretar_nemonico("B0",'\0',0,'\0','\0',0,'\n');      /* 177 */

SIM0        Interpretar_nemonico("B1",'\0',0,'\0','\0',0,'\n');      /* 178 */

SIM1        Interpretar_nemonico("B2",'\0',0,'\0','\0',0,'\n');      /* 179 */

NOP         Interpretar_nemonico("B3",'\0',0,'\0','\0',0,'\n');      /* 180 */

SCF         Interpretar_nemonico("B4",'\0',0,'\0','\0',0,'\n');      /* 181 */

CCF         Interpretar_nemonico("B5",'\0',0,'\0','\0',0,'\n');      /* 182 */

SF0         Interpretar_nemonico("B6",'\0',0,'\0','\0',0,'\n');      /* 183 */

CF0         Interpretar_nemonico("B7",'\0',0,'\0','\0',0,'\n');      /* 184 */

SF1         Interpretar_nemonico("B8",'\0',0,'\0','\0',0,'\n');      /* 185 */

CF1         Interpretar_nemonico("B9",'\0',0,'\0','\0',0,'\n');      /* 186 */

SF2         Interpretar_nemonico("BA",'\0',0,'\0','\0',0,'\n');      /* 187 */

CF2         Interpretar_nemonico("BB",'\0',0,'\0','\0',0,'\n');      /* 188 */

SF3         Interpretar_nemonico("BC",'\0',0,'\0','\0',0,'\n');      /* 189 */

CF3         Interpretar_nemonico("BD",'\0',0,'\0','\0',0,'\n');      /* 190 */

MINT0       Interpretar_nemonico("BE",'\0',0,'\0','\0',0,'\n');      /* 191 */

MINT1       Interpretar_nemonico("BF",'\0',0,'\0','\0',0,'\n');      /* 192 */



\n              {nlinea++;                      /*Se incrementa el numero de linea en cada salto de linea*/

                if(error_linea == true){        /*No existe nemónico*/
                    error_linea=false;
                    fprintf(errores, ".\n", yytext);      /*Se imprime el salto de linea*/
                }
                }


(";"+)(.+)      ;   /*Es un comentario, no se hace nada*/

\t              {if(error_linea == true){      /*No existe nemónico*/
                    fprintf(errores, "\t", yytext);     /*Se imprime el tab*/
                }
                }

.               {if(error_linea == false){
                    error_linea = true;
                    error_codigo = true;
                    fprintf(errores, "Linea %d: No existe la instruccion %s", nlinea, yytext);     /*Se imprime el error*/
                }
                else{
                    fprintf(errores, "%s", yytext);     /*Se imprime el siguiente caracter en el error*/
                }
                }


%%

int main(){
    /*Se declaran las variables necesarias*/
    int Tamaño = 0;
    char filename_in[255];
    char filename_error[255];
    char filename_out[255];
    char caracter_in[20];
    char N_Puerto[2];

    /*Mensaje solicitando el directorio del archivo*/
    printf("Introduce el directorio donde se encuantra el archivo(use / como separadores):\n");
    scanf("%s", filename_in);                       /*Se lee el directorio que introduce el usuario*/

    
    Tamaño = strlen(filename_in);                   /*Se calcula el tamaño del directorio introducido*/

    /*Se crean los nombres de los archivos de out y errores*/
    strcpy(filename_out, filename_in);
    strcpy(filename_error, filename_in);

    strcpy(filename_out + Tamaño - 4, "_out.txt");
    strcpy(filename_error + Tamaño - 4, "_errores.txt");

    /*Se abre el archivo dado por el directorio*/
    in  = fopen(filename_in, "r");

    /*Si no se ha podido abrir o no existe, se imprime el error y se espera a que se pulse cualquier tecla para cerrar la consola*/
    if (in == NULL)
    {
        printf("Error: no se puede abrir el archivo %s\n", filename_in);
        system("pause");
        return 0;
    }

    /*Se crean y abren los archvos de errores y out respectivamente*/
    errores = fopen(filename_error, "w");
    out = fopen(filename_out, "w+");

    /*Si no se a podido abrir o crear se imprime el error y se espera a que se pulse una tecla para cerrar la consola*/
    if (out == NULL)
    {
        printf("Error: no se puede crear el archivo %s\n", filename_out);
        system("pause");
        return 0;
    }

    /*Si no se a podido abrir o crear se imprime el error y se espera a que se pulse una tecla para cerrar la consola*/
    if (errores == NULL)
    {
        printf("Error: no se puede crear el archivo %s\n", filename_error);
        system("pause");
        return 0;
    }

    /*Se pone el contenido del archivo de entrada como entrada de texto para flex*/
    yyin = in;

    /*Se ejecuta Flex*/
    yylex();

    /*Se cierran los archivos abiertos y creados*/
    fclose(in);
    fclose(out);
    fclose(errores);
    
    /*Ha habido un error en el codigo y no se puede enviar el programa al microprocesador*/
    if(error_codigo == true){
        printf("\nEl codigo tiene errores y no se puede enviar al microprocesador. Comprueba el archivo de errores.\n");
        system("pause");
        return 0;
    }
    /*No ha habido errores y se puede mandar el programa al uP*/
    else{     
        printf("\nEl codigo no tiene errores. Deseas enviar el programa al microprocesador?[Y/N]. ");
        scanf("%s",caracter_in);

        /*Se a introducido 'Y' o 'y', se manda el programa por puerto serie al uP*/
        if((caracter_in[0] == 'Y') || (caracter_in[0] == 'y')){

            /*Se abre el archvo _out.txt para leer los bytes que se van a enviar*/
            out = fopen(filename_out, "r");

            /*No se ha podido abrir, se imprime el error y se cierra el programa*/
            if (out == NULL)
            {
                printf("Error: no se puede leer el archivo %s\n", filename_out);
                system("pause");
                return 0;
            }
            /*Se a podido abrir el archivo, por lo que se envian los datos por el puerto serie*/
            else{
                
                /*Se solicita el numero de puerto COM en el que esta conectado el uP*/
                printf("\nIntroduce el numero del puerto serie COM (solo el numero). Es el puerto COM");
                scanf("%s", N_Puerto);                          /*Se lee el numero de puerto*/

                /*Se envia los datos por el puerto serie*/
                Enviar_datos_Puerto_Serie(N_Puerto);

                /*Se cierra el archivo de salida*/
                fclose(out);                       
            }   
                                                /**/
        }
        /*Se a introducido otro caracter, no se mandan el programa por puerto serie al uP*/
        else{printf("\nTienes el codigo del programa en el archivo _out.txt\n");}
    }


    /*Se espera a que se pulse cualquier tecla para cerrar la consola*/
    system("pause");
    return 0;

}

int yywrap()
{
    return(1);
}