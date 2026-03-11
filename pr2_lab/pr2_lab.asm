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
.extern _stack
.global main
.equ N, 4
.data
V: .word 4, -2, 3, 7
W: .word 2, 5, -3, 0
.bss
res : .space 4
.text
main :
la sp , _stack // inicializa sp
la a0 , V //1er arg : dir de V
la a1 , W //2o arg : dir de W
li a2 , N //3er arg : N
call maxDist // llamada a maxDist
la t0 , res
sw a0 , 0( t0) // guardado de res
fin :
j fin
maxDist :
addi sp , sp , -24 // ///
sw ra , 20( sp) //
sw s0 , 16( sp) //
sw s1 , 12( sp) // PRÓ LOGO
sw s2 , 8( sp) //
sw s3 , 4( sp) //
sw s4 , 0( sp) // ///
li s0 , 0 // s0 guarda max
li s1 , 0 // s1 guarda i
mv s2 , a0 // s2 guarda X
mv s3 , a1 // s3 guarda Y
mv s4 , a2 // s4 guarda n
bucle :
bge s1 , s4 , return_md
lw a0 , 0( s2) //1er arg : X[i]
lw a1 , 0( s3) //2o arg: Y[i]
call subabs // llamada a subabs
ble a0 , s0 , nextiter
mv s0 , a0
nextiter :
addi s1 , s1 , 1 // actualizo iterador
addi s2 , s2 , 4 //X++
addi s3 , s3 , 4 //Y++
j bucle // repito bucle
return_md :
mv a0 , s0 // coloco valor de retorno
lw ra , 20( sp) // ///
lw s0 , 16( sp) //
lw s1 , 12( sp) //
lw s2 , 8( sp) // EPÍ LOGO
lw s3 , 4( sp) //
lw s4 , 0( sp) //
addi sp , sp , 24 // ///
ret // devuelvo control
subabs :
sub a0 , a0 , a1 // calculo distancia
bge a0 , zero , return_sa
neg a0 , a0 // cambio a positivo
return_sa:
ret // devuelvo valor en a0
.end

/*
---------------------------------------------------------------------
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
**-------------------------------------------------------------------

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

 */
