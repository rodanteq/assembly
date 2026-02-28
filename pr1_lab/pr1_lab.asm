/*---------------------------------------------------------------------
**
**  Fichero:
**    pr1_lab.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 1_lab
**
**  Notas de diseño:

2 variables unsigned a = 10 b = 5
1 variable c = -1
1 variable res = 0

si c < 0 cambiamos signo
si c > 0 bucle while para comparar a con b
si a > b a -= c
res++
guardar res en memoria (al acabar el bucle)


**
**-------------------------------------------------------------------*/

.bss
	res: .space 4
.data
	a: .word 10
	b: .word 5
	c: .word -1
.text
.global main
main:
	la t0, res // t0 guarda la direccion de res
	sw x0, 0(t0) // guardamos el valor inicial de res
	lw s2, 0(t0) // s2 almacena el valor de res. Seria mas eficiente cargando el 0 como inmediato

	la t1, a // t1 guarda la direccion de a
	lw s3, 0(t1) // s3 almacena el valor de a.

	la t2, b // t2 guarda la direccion de b
	lw s4, 0(t2) // s4 almacena el valor de b.

	la t3, c // t3 guarda la direccion de c
	lw s5, 0(t3) // s5 almacena el valor de c.

if1:
	bge s5, x0, if2
	sub s5, x0, s5

if2:
	ble s5, x0, save

while:
	ble s3, s4, save
	sub s3, s3, s5
	addi s2, s2, 1
	j while

save:
	sw s2,0(t0)
	sw s5,0(t3)
	sw s3,0(t1)

fin:
	j fin
.end
