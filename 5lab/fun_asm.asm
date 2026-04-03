/*---------------------------------------------------------------------
**
**  Fichero:
**    fun_asm.asm  01/05/2025
**
**    (c) J.M. Mendias
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 5_lab
**
**-------------------------------------------------------------------*/
.equ N,3
.data
	A: .word -2, -2, 1, -2, 1, -2, 1, -2, -2
	B: .word 15, 30, 27, -10, 8, -1, 2, 10, -13

.bss
	resul: .space 8

.text
	.extern matrixMul
	.extern matrixDiv

	.global matrix_copyT
	matrix_copyT:
	// a0=n, a1=x, a2=z
	li t0, 0 // t0=i
	li t1, 0 // t1=j
	for1copyT: bge t0, a0, fincopyT
		for2copyT: bge t1, a0, sumai
			mul t2, t0, a0
			add t2, t2, t1
			slli t2, t2 ,2
			add t2, t2, a2//t2=z[i][j
			mul t3, t1, a0
			add t3, t3, t0
			slli t3, t3 ,2
			add t3, t3, a1// t3=x[j][i]
			lw t3, 0(t3)
			sw t3, 0(t2)
			addi t1, t1, 1
			j for2copyT
		sumai:
			addi t0, t0, 1
			li t1, 0
		j for1copyT
	fincopyT:
		ret

	.global Matrixl
	Matrixl:
	//a0=n, a1=m
	li t0, 0 // t0=j
	li t1, 0 // t1=k
	li t5, 1 // t5=res
	for1matrixl: bge t0, a0, finmatrixl
		for2matrixl: bge t1, a0, sumaj
			mul t2, t0, a0
			add t2, t2, t1
			slli t2, t2, 2
			add t2, t2, a1//direccion m[j][k]
			lw t3, 0(t2)
			li t4, 1
			if:
				bne t0, t1, else
				beq t3, t4, then
				li t2, 0
				j then
			else:
				beq t3, x0, then
				li t5, 0
			then:
				addi t1, t1, 1
				j for2matrixl
		sumaj:
			addi t0, t0,1
			li t1, 0
			j for1matrixl
	finmatrixl:
		mv a0, t5
		ret

	.global main
	main:
	addi sp, sp, -N*N*4
	mv s0, sp // direccion de AuxT
	addi sp, sp, -N*N*4
	mv s1, sp // direccion de AuxM
	li a0, N
	la s2, A // direccion de A
	la s3, B // direccion de B
	mv a1, s2
	mv a2, s0
	call matrix_copyT // pasamos a0=N, a1=A, a2=AuxT
	li a0, N
	mv a1, s0
	mv a2, s2
	mv a3, s1
	call matrixMul // pasamos a0=N, a1=AuxT, a2=A, a3=AuxM
	li a0, N
	mv a1, s1
	li a2, 9
	call matrixDiv // pasamos a0=N, a1=AuxM, a2=9
	li a0, N
	mv a1, s1
	call Matrixl // pasamos a0=N, a1=AuxM
	la s4, resul
	sw a0, 0(s4)
	li a0, N
	mv a1, s3
	mv a2, s0
	call matrix_copyT
	li a0, N
	mv a1, s0
	mv a2, s3
	mv a3, s1
	call matrixMul
	li a0, N
	mv a1, s1
	call Matrixl
	sw a0, 4(s4)
	addi sp, sp, N*N*8
	end:
	j end
