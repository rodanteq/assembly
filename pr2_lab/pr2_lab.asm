/*---------------------------------------------------------------------
**
**  Fichero:
**    pr2_lab.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 2_lab
**
**  Notas de diseño:
**
**-------------------------------------------------------------------*/

.global main
.equ N , 8
.equ INT_MAX , 65536

.data
V: 	.half -7 ,2 , -1 ,0 ,15 , 16 ,20 ,30
nu: .half 8

.bss
ind: .space 4

.text
main:
  	li t0, N  // t0=i
  	addi t0,t0, -1
  	la t1, V // direccion de V
  	li t3, N // t3=index (inicializado para que no de error y no entre en for2)
  	la t5, nu
	lh t5, 0(t5) // t5=nu

for1:
	blt t0, x0, inij
	slli t4, t0, 1
	add t4, t4, t1
	lh t4, 0(t4) // t4=v[i]
	if:
		ble t4, t5, sumai
		mv t3, t0
	sumai:
		addi t0, t0, -1
		j for1

inij:
	mv t0, t3 // t1=j
	li t6, N  // t6=N

for2:
	bge t0, t6, save
    slli t4, t0, 1
    add t4, t4, t1
	lh t2, 0(t4) //t2=temp=v[j]
    sh t5, 0(t4)
    mv t5,t2
    addi t0, t0, 1
    j for2

save:
	la t1, ind
	sw t3, 0(t1)

fin:
	j fin

 .end
