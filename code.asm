.MODEL SMALL
.STACK 100H
.DATA
    STRING DB 'abba$'   ; Променете го стрингот за различни тестови
    LED_PORT EQU 199    ; Портата за LED дисплејот

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    LEA SI, STRING      ; Поставување на покажувачот на почетокот на стрингот
    CALL IS_PALINDROME  ; Проверка дали стрингот е палиндром
    CMP AL, 1
    JE IS_PALINDROME_LABEL

    ; Ако не е палиндром, постави LED дисплејот на 00000
    MOV DX, LED_PORT
    MOV AL, 00000B
    OUT DX, AL
    JMP END_PROGRAM

IS_PALINDROME_LABEL:
    ; Ако е палиндром, постави LED дисплејот на 11111
    MOV DX, LED_PORT
    MOV AL, 11111B
    OUT DX, AL

END_PROGRAM:
    ; Завршување на програмата
    MOV AH, 4CH
    INT 21H

IS_PALINDROME PROC
    ; Функција за проверка дали стрингот е палиндром
    PUSH BP
    MOV BP, SP
    SUB SP, 2           ; Резервирање на меморија на стекот

    ; Наоѓање на должината на стрингот
    LEA DI, STRING
    MOV CX, 0
FIND_LENGTH:
    MOV AL, [DI]
    CMP AL, '$'
    JE LENGTH_FOUND
    INC CX
    INC DI
    JMP FIND_LENGTH

LENGTH_FOUND:
    DEC CX             ; Не го број амперсандот '$'
    MOV [BP-2], CX     ; Должината на стрингот

    ; Поставување на покажувачите на почетокот и крајот на стрингот
    MOV SI, 0
    MOV DI, CX
    DEC DI             ; Последниот валиден карактер

COMPARE_LOOP:
    CMP SI, DI
    JGE IS_PALINDROME_TRUE

    MOV AL, [SI + STRING]
    MOV BL, [DI + STRING]
    CMP AL, BL
    JNE IS_PALINDROME_FALSE

    INC SI
    DEC DI
    JMP COMPARE_LOOP

IS_PALINDROME_TRUE:
    MOV AL, 1
    JMP IS_PALINDROME_END

IS_PALINDROME_FALSE:
    MOV AL, 0

IS_PALINDROME_END:
    ADD SP, 2           ; Враќање на резервираната меморија
    POP BP
    RET
IS_PALINDROME ENDP

MAIN ENDP
END MAIN
