
imprimirCad MACRO Cadena
    MOV DX,OFFSET Cadena
    MOV AH,09H
    INT 21H 
ENDM

.MODEL SMALL ;Modelo de memoria del programa
.STACK 100h  ;Segmento de Pila     
.DATA        ;Segmento de Datos
    msj1   DB 'Leyendo Archivo: $' 
    msjE   DB 'Error leyendo el archivo$'
    msjEOF DB 'Fin de archivo$'  
    
    nombreF DB 'texto.txt',0        
    handler DW 0   ;Manejador del archivo
    Buffer db ?   ;Buffer guarda los caracteres leidos
    cadLN DB 0AH,0Dh,'$'
.CODE        ;Segmento de Codigo 
PROGRAMA:    ;Etiqueta principAL del programa 
    MOV AX,@DATA ;Se asigna la direccion del segmento de datos AL registro AX 
    MOV DS,AX    ;MOVer el vALor de AX AL Registro DS        
    XOR AX,AX    ;Limpia el registro AX
    XOR BX,BX    ;Limpia el registro BX
    XOR CX,CX    ;Limpia el registro CX
    XOR DX,DX    ;Limpia el registro DX
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
    imprimirCad msj1
        
    MOV DX, offset nombreF ; address of file to DX
    MOV AL,0      ;Abrir como solo lectura
    MOV AH,3Dh    ;Serivicio de apertura de archivos de DOS
    INT 21h 
    JC @ErrorIO  ;Si hay acarreo terminar (error de I/O)
    MOV BX,AX     ;El handler del archivo esta en BX
    MOV handler,BX;Se guarda el handler
    
    MOV CX,1 ;Leer un caracter a la vez
    
    @LecturaF:
        LEA DX, Buffer ;DX apunta al buffer
        MOV AH,3Fh ;Se lee el archivo abierto, cuyo handler esta en bx
        int 21h
            
        CMP AX, 0 ;Se tuvo leer 1 caracter
        JZ @EOF ;Si se leyeron 0 caracteres es fin de archivo (no hay mas Bytes a leer).
        MOV AL, Buffer ;El caracter leido se encuentra en Buffer
                       
        ;Imprimir caracter
        
        
    JMP @LecturaF ;Repetir Lectura hasta fin de archivo
    
    
    @EOF:
        imprimirCad cadLN
        imprimirCad msjEOF
        jmp @FinP
    @ErrorIO:
        imprimirCad cadLN
        imprimirCad msjE
        jmp @FinP 
    
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   
    @FINP: ;Rutina de Cierre de Programa, devuelve el control a DOS
        MOV AH,4Ch
        INT 21h
        
ENDP
