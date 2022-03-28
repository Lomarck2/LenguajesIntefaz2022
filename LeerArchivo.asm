 imprimirLN MACRO
    MOV DL, 0Ah       ;ASCII para \n
    MOV AH, 02H       ;Se coloca 02h en AH 
    INT 21H           ;para llamar al servicio de terminal en modo imprimir caracteres
    MOV DL, 0Dh       ;ASCII para \r
    MOV AH, 02H       ;Se coloca 02h en AH                                            
    INT 21H           ;para llamar al servicio de terminal en modo imprimir caracteres     
ENDM
imprimirCad MACRO mensaje
    MOV DX,OFFSET mensaje
    MOV AH,09H
    INT 21H 
ENDM

.MODEL SMALL ;Modelo de memoria del programa
.STACK 100h  ;Segmento de Pila     
.DATA        ;Segmento de Datos
    mensaje1 DB 'Leyendo Archivo: $'  
    cadLN DB 0Ah,0Dh,'$'
    nombre DB 'texto.txt',0        
    handle DW 0   ;Manejador del archivo
    caracterA DB 0    
.CODE        ;Segmento de Codigo 
PROGRAMA:    ;Etiqueta principal del programa 
    MOV AX,@DATA ;Se asigna la direccion del segmento de datos al registro AX 
    MOV DS,AX    ;Mover el valor de AX al Registro DS        
    XOR AX,AX    ;Limpia el registro AX
    XOR BX,BX    ;Limpia el registro BX
    XOR CX,CX    ;Limpia el registro CX
    XOR DX,DX    ;Limpia el registro DX
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
    MOV AH,3Dh ;Instrucción para abrir el archivo
    MOV AL,00h  ;00h solo lectura, 01h solo escritura, 02h lectura y escritura
    MOV DX,offset nombre ;abre el archivo llamado archivo2.txt indicado en .data
    INT 21h
    MOV handle,AX
    
    ;leer archivo
    LeerF:
        MOV AH,42h ;Mueve el apuntador de lectura/escritura al archivo
        MOV AL,SI
        MOV BX,AX  ;BX Estan la cantidad de caracteres leidos     
        mov CX,5 ;Decimos que queremos leer 50 bytes del archivo
        int 21h
        
        CMP AX,5
        JNE @EOF
        
        MOV CX,5
        @LeerC:
            MOV DX,handle[SI]
            MOV caracterA,DX     
            ;Imprimir caracter en consola
            INC SI
        LOOP @LeerC
    JMP LeerF
    
    @EOF:
        MOV AH,3Eh  ;Cierre de archivo
        INT 21h   
    
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   
    @FINP: ;Rutina de Cierre de Programa, devuelve el control a DOS
        MOV AH,4Ch
        INT 21h
        
ENDP
