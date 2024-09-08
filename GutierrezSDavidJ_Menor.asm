.data
    prompt1:     .asciiz "�Cu�ntos n�meros desea comparar? (M�nimo 3, M�ximo 5): "
    invalid_msg: .asciiz "N�mero inv�lido. Debe ser entre 3 y 5.\n"
    prompt2:     .asciiz "Ingrese un n�mero: "
    result_msg:  .asciiz "El n�mero menor es: "
    newline:     .asciiz "\n"

.text
    .globl main

main:

valid_count_loop:
    # Muestra el mensaje para pedir la cantidad de n�meros
    li $v0, 4             
    la $a0, prompt1        # cargar la direcci�n de prompt1
    syscall

    # Lee la cantidad de n�meros
    li $v0, 5            
    syscall
    move $t0, $v0          # guardar el n�mero de entradas en $t0

    # Verifica si la cantidad de n�meros est� entre 3 y 5
    li $t3, 3              
    li $t4, 5              
    blt $t0, $t3, invalid  
    bgt $t0, $t4, invalid  
    j valid_count          # si est� en el rango, continuar

invalid:
    # Muestra mensaje de n�mero inv�lido
    li $v0, 4
    la $a0, invalid_msg
    syscall
    j valid_count_loop     # repetir el bucle

valid_count:
    # Inicializa el n�mero menor a un valor muy alto (2^31-1)
    li $t1, 2147483647     # $t1 almacenar� el n�mero menor

compare_loop:
    # Verifica si hemos terminado de leer todos los n�meros
    beqz $t0, end_compare  # si $t0 es 0, salir del bucle

    # Muestra el mensaje para ingresar un n�mero
    li $v0, 4             
    la $a0, prompt2        # cargar la direcci�n de prompt2
    syscall

    # Lee el n�mero del usuario
    li $v0, 5           
    syscall
    move $t2, $v0          # guardar el n�mero ingresado en $t2

    # Compara el n�mero actual con el n�mero menor
    bgt $t2, $t1, skip_update  # si $t2 > $t1, saltar actualizaci�n

    # Actualizar el n�mero menor
    move $t1, $t2

skip_update:
    # Decrementa el contador de n�meros
    subu $t0, $t0, 1       # $t0 = $t0 - 1
    j compare_loop         # repetir el bucle

end_compare:
    # Muestra el resultado
    li $v0, 4              
    la $a0, result_msg     # cargar la direcci�n de result_msg
    syscall

    # Imprime el n�mero menor
    move $a0, $t1          # cargar el n�mero menor en $a0
    li $v0, 1             
    syscall

    # Imprime nueva l�nea
    li $v0, 4             
    la $a0, newline      
    syscall

    # Terminar el programa
    li $v0, 10         
    syscall