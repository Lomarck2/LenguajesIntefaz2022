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
    mensaje1 DB 'Introduce un numero: $'
    mensajeError DB 'No es numero base 10$'
    cadena DB 6 DUP('$')      
    inversa DB 6 DUP('$')
.CODE        ;Segmento de Codigo 
PROGRAMA:    ;Etiqueta principal del programa    
    ;Rutina de arranque
    MOV AX,@DATA ;Se asigna la direccion del segmento de datos al registro AX 
    MOV DS,AX    ;Mover el valor de AX al Registro DS        
    XOR AX,AX    ;Limpia el registro AX
    XOR BX,BX    ;Limpia el registro BX
    XOR CX,CX    ;Limpia el registro CX
    XOR DX,DX    ;Limpia el registro DX
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
    imprimirCad mensaje1
    ;Rutina de captura  
    @cicloCaptura:
        MOV AH,01H  
        INT 21H        
        CMP AL,0Dh
        JE @finCicloC ; Se introdujo ENTER y se acabo la captura        
        MOV Cadena[SI],AL   ; se introduce el numero capturado en Cadena
        INC SI
        JMP @cicloCaptura ; se retorna para seguir capturando
    @finCicloC:
    MOV Cadena[SI],'$' ;Se agrega $ para finalizar la cadena
    imprimirLN
    PUSH SI
    MOV CX,SI
    XOR DI,DI
    @cicloInversa:
        MOV BX, CX
        DEC BX
        MOV DL,Cadena[BX]
        MOV inversa[DI],DL
        INC DI
    LOOP  @cicloInversa
    
    
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   
    @FINP: ;Rutina de Cierre de Programa, devuelve el control a DOS
        MOV AH,4Ch
        INT 21h
            
    ;FUNCIONES o PROCEDIMIENTOS **************************************************
    @BCD PROC ;Recibe en AL el ASCII decimal y regresa en AL el valor decimal
        CMP AL,39h        ;Se Compara AL con 39h
        JLE @EsMenorA_9   ;Si es menor o igual brinca a EsMenorA_9 (Jump if Less or Equal)
        JG  @Error        ;Si es mayor No es un Numero base 10  (Jump if Greater)
        @EsMenorA_9:
            CMP AL,30h
            JGE @EsMayorA_0 ;Si es mayor o igual brinca a EsMayorA_0 (Jump if Greater or Equal)
            JL @Error       ;Si es menor No es un Numero base 10  (Jump if Greater)  
            @EsMayorA_0:
                SUB AL,30h  ;Se resta 30h para obtener el valor del ASCII
                RET
        @Error:
           imprimirCad mensajeError 
           JMP @FINP
    ENDP
ENDP  
