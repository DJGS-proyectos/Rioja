.data
    prompt1:     .asciiz "¿Cuántos números desea comparar? (Mínimo 3, Máximo 5): "
    invalid_msg: .asciiz "Número inválido. Debe ser entre 3 y 5.\n"
    prompt2:     .asciiz "Ingrese un número: "
    result_msg:  .asciiz "El número menor es: "
    newline:     .asciiz "\n"

.text
    .globl main

main:

valid_count_loop:
    # Muestra el mensaje para pedir la cantidad de números
    li $v0, 4             
    la $a0, prompt1        # cargar la dirección de prompt1
    syscall

    # Lee la cantidad de números
    li $v0, 5            
    syscall
    move $t0, $v0          # guardar el número de entradas en $t0

    # Verifica si la cantidad de números está entre 3 y 5
    li $t3, 3              
    li $t4, 5              
    blt $t0, $t3, invalid  
    bgt $t0, $t4, invalid  
    j valid_count          # si está en el rango, continuar

invalid:
    # Muestra mensaje de número inválido
    li $v0, 4
    la $a0, invalid_msg
    syscall
    j valid_count_loop     # repetir el bucle

valid_count:
    # Inicializa el número menor a un valor muy alto (2^31-1)
    li $t1, 2147483647     # $t1 almacenará el número menor

compare_loop:
    # Verifica si hemos terminado de leer todos los números
    beqz $t0, end_compare  # si $t0 es 0, salir del bucle

    # Muestra el mensaje para ingresar un número
    li $v0, 4             
    la $a0, prompt2        # cargar la dirección de prompt2
    syscall

    # Lee el número del usuario
    li $v0, 5           
    syscall
    move $t2, $v0          # guardar el número ingresado en $t2

    # Compara el número actual con el número menor
    bgt $t2, $t1, skip_update  # si $t2 > $t1, saltar actualización

    # Actualizar el número menor
    move $t1, $t2

skip_update:
    # Decrementa el contador de números
    subu $t0, $t0, 1       # $t0 = $t0 - 1
    j compare_loop         # repetir el bucle

end_compare:
    # Muestra el resultado
    li $v0, 4              
    la $a0, result_msg     # cargar la dirección de result_msg
    syscall

    # Imprime el número menor
    move $a0, $t1          # cargar el número menor en $a0
    li $v0, 1             
    syscall

    # Imprime nueva línea
    li $v0, 4             
    la $a0, newline      
    syscall

    # Terminar el programa
    li $v0, 10         
    syscall