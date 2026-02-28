/*---------------------------------------------------------------------
**
**  Fichero:
**    pr2_a.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 2a
**
**  Notas de diseño:
**
** 	# define N 8
** 	# define INT_MAX 65536
**	int V [ N ] = { -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3};
**	int min = INT_MAX ;
**	for ( i = 0; i < N ; i ++) {
**		if ( V [ i ] < min )
**			min = V [ i ];
**	}
**
**-------------------------------------------------------------------*/

.global main
.equ N, 8
.equ INT_MAX, 65536
.data
V:   .word -7,3,-9,8,15,-16,0,3

.bss
min: .space 4

.text
main:
    la s1, min
    li t0, INT_MAX  // en t0 se almacenara el minimo
    sw t0, 0(s1) // mum maximo con el que comparamos

    la s2, V// direccion base del vector
    li t1, 0 // la i del bucle
    li t4, N // N=8 stop del bucle

    for: bge t1, t4, save
    	slli t2,t1,2 // t2=t1*4
    	add t3, s2, t2 // t3= direccion base + offset
    	lw a0, 0(t3)  // a0= V[i]
    	addi t1, t1, 1
    	if: bge a0, t0, for
    		add t0, a0, x0
    		j for

    save:
    	sw t0, 0(s1)

    fin:
     j fin


