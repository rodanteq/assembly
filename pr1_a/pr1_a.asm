/*---------------------------------------------------------------------
**
**  Fichero:
**    pr1_a.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 1a
**
**  Notas de diseño:
**
**	# define N 10
**	int res = 0;
**	for (int i = 0; i < N ; i ++) {
**		res += i ;
**	}
**
**-------------------------------------------------------------------*/

//defino la constante N
.equ N, 10
//reservo espacio para el resultado
.bss
	res: .space 4
	i: .space 4
//programa
.text
.global main
main:
	la t0, res // t0 guarda la direccion de res
	sw x0, 0(t0) // guardamos el valor inicial de res
	lw s2, 0(t0) // s2 almacena el valor de res. Seria mas eficiente cargando el 0 como inmediato
	la t1, i // t1 guarda la direccion de i
	sw x0, 0(t1) // guardamos el valor inicial de i
	lw s3, 0(t1) // s3 almacena el valor de i. Seria mas eficiente cargando el 0 como inmediato
	li s1, N
for:
	bge s3, s1, efor
	add s2, s2, s3 // hacemos res += i
	sw s2, 0(t0) // lo optimo seria guardar solo al final para no acceder todo el rato a la memoria. Como no hemos modificado t0 la direccion de memoria sigue guardada ahi.
	addi s3, s3, 1 // hacemos i++
	sw s3, 0(t1) // lo optimo seria guardar solo al final para no acceder todo el rato a la memoria. Como no hemos modificado t1 la direccion de memoria sigue guardada ahi.
	j for
efor:
	j efor
.end
