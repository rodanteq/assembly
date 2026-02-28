/*---------------------------------------------------------------------
**
**  Fichero:
**    pr2_b.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 2b
**
**  Notas de diseño:
**
**	# define N 8
**	# define INT_MAX 65536
**	int V [ N ] = { -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3};
**	int W [ N ];
**	int min , index ;
**	for ( j = 0; j < N ; j ++) {
**		min = INT_MAX ;
**		for ( i = 0; i < N ; i ++) {
**			if ( V [ i ] < min ) {
**				min = V [ i ];
**				index = i ;
**			}
**		}
**		W [ j ] = V [ index ];
**		V [ index ] = INT_MAX ;
**	}
**
**-------------------------------------------------------------------*/

.global main
.equ N , 8
.equ INT_MAX , 65536

.data
V: 	 .word -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3
.bss
W: 	 .space N *4
min: .space 4
ind: .space 4

.text
main:
// codificar
la s0, min // direccion del minimo en memoria
la s1, W // direccion base W
la s2, V // direccion base V
// t1 y t0  son reservados para index y min
li t0, INT_MAX  //en t0 almacenaremos el minimo  min = int max
li t3, 0 // t3 == j
li t5, N // t5 == N = 8

for1: bge t3, t5, fin
	li t4, 0 // t4 == i
for2: bge t4, t5, save
    slli t6,t4,2 // t6=t4*4=i*4
    add t6, s2, t6 // t6= direccion base + offset
    lw a0, 0(t6)  // a0= V[i]

    if: bge a0, t0, sumai
    	add t0, a0, x0 //t0=nuevo min
    	mv t1, t4 //index=i
     	sumai:
     		addi t4, t4, 1 // i++
    	j for2

	save:
		slli t6,t3,2 // t6=t5*4=j*4
    	add t6, s1, t6 // t6= direccion base + offset
    	sw t0, 0(t6) // W [ j ] = V [ index ]= min;
    	li t0, INT_MAX  //en t0 almacenaremos el minimo  min = int max
    	slli t6,t1,2 // t6=index*4
    	add t1,s2, t6//podemos sobreescirbir t1 porque el if en donde t1 vuelve a tomar un valor siempre se ejecuta, si no podriamos pasarlo a t2
    	sw t0, 0(t1)
		addi t3, t3, 1 // j++
		j for1
fin:
	j fin

 .end



