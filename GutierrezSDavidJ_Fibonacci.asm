.data
    prompt1:     .asciiz "¿Cuántos números de la serie Fibonacci desea generar? "
    result_msg:  .asciiz "La serie Fibonacci es: "
    sum_msg:     .asciiz "La suma de los números de la serie es: "
    newline:     .asciiz "\n"

.text
    .globl main

main:
    # Muestra el mensaje para pedir la cantidad de números
    li $v0, 4           
    la $a0, prompt1        # cargar la dirección de prompt1
    syscall

    # Lee la cantidad de números
    li $v0, 5            
    syscall
    move $t0, $v0          # guardar la cantidad en $t0

    # Inicializa los dos primeros números de Fibonacci
    li $t1, 0              # F(0) = 0
    li $t2, 1              # F(1) = 1

    # Inicializa la suma
    move $t3, $t1          
    add $t3, $t3, $t2      

    # Muestra el mensaje para la serie de Fibonacci
    li $v0, 4             
    la $a0, result_msg     # cargar la dirección de result_msg
    syscall

    # Imprime F(0)
    move $a0, $t1          # cargar F(0) en $a0
    li $v0, 1              
    syscall

    # Imprime una coma y un espacio
    li $v0, 4
    la $a0, newline
    syscall

    # Imprime F(1)
    move $a0, $t2          # cargar F(1) en $a0
    li $v0, 1       
    syscall

    # Resta 2 de $t0 porque ya imprimimos los dos primeros números
    subu $t0, $t0, 2

fibonacci_loop:

    beqz $t0, end_fibonacci  # si $t0 es 0, salir del bucle

    # Calcula F(n) = F(n-1) + F(n-2)
    add $t4, $t1, $t2        # $t4 = F(n)

    # Suma F(n) a la suma total
    add $t3, $t3, $t4

    # Imprime F(n)
    li $v0, 4
    la $a0, newline
    syscall

    move $a0, $t4           # cargar F(n) en $a0
    li $v0, 1              
    syscall

    # Prepara para el siguiente ciclo
    move $t1, $t2           # $t1 = F(n-1)
    move $t2, $t4           # $t2 = F(n)

    # Decrementa el contador
    subu $t0, $t0, 1
    j fibonacci_loop        # repite el bucle

end_fibonacci:

    # Imprime F(n)
    li $v0, 4
    la $a0, newline
    syscall
    
    # Muestra el mensaje para la suma total
    li $v0, 4            
    la $a0, sum_msg        # cargar la dirección de sum_msg
    syscall

    # Imprime la suma total
    move $a0, $t3          # cargar la suma en $a0
    li $v0, 1              # syscall para imprimir entero
    syscall

    # Imprime nueva línea
    li $v0, 4
    la $a0, newline
    syscall

    # Termina el programa
    li $v0, 10             
    syscall