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
**    Fichero de código para la práctica 5
**
**-------------------------------------------------------------------*/

// NOTA: cuando usamos mul omitimos la parte alta mulh

.equ N, 2 // es tipo word, multiplicar por 4 = slli ... 2 o mul ... 4

// .extern _stack
// la sp, _stack

/*
void matrixCopy(int n, int x[n][n], int z[n][n]) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            z[i][j] = x[i][j];
}*/

// .global matrixCopy no es necesario
matrixCopy:
// recibimos en a0: n, a1: x[n][n], a2 z[n][n] (son punteros) y copiamos x en z
// i = t0, j = t1
	li t0, 0
	li t1, 0
	for1: bge t0, a0, fin1
		for2: bge t1, a0, fin2
			mv t2, t0
			mul t2, t2, a0
			add t2, t2, t1
			slli t2, t2, N // multiplicamos por 4
			add t3, a2, t2 // guardamos en t3 la direccion de z[i][j]
			add t2, a1, t2 // guardamos en t2 la direccion de x[i][j]
			lw t4, 0(t2)
			sw t4, 0(t3)
			addi t1, t1, 1
			j for2
		fin2:
			li t1, 0
			addi t0, t0, 1
			j for1
	fin1:
		ret

    /*
    void matrixMul(int n, int x[n][n], int y[n][n], int z[n][n]) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            z[i][j] = 0;
            for (int k = 0; k < n; k++)
                z[i][j] = z[i][j] + x[i][k] * y[k][j];
        }
	}*/

// .global matrixMul no es necesario
matrixMul:
// recibimos por parametros n: a0, x: a1, y: a2, z:a3
// i en t0, j en t1, k en t6
	li t0, 0
	li t1, 0
	li t6, 0
	mulfor1: bge t0, a0, mulfin1
		mulfor2: bge t1, a0, mulfin2
			mv t2, t0
			mul t2, t2, a0
			add t2, t2, t1
			slli t2, t2, N // multiplicamos por 4
			add t2, a3, t2 // guardamos en t2 la direccion de z[i][j]
			sw x0, 0(t2) // guardamos un 0
			mulfor3: bge t6, a0, mulfin3
				lw t3, 0(t2)
				// tenemos que guardar las direcciones Zij (t2) Xik (a4) Ykj (a5), aun nos quedan los registros t4 y t5
				mv t4, t0
				mul t4, t4, a0
				add t4, t4, t6
				slli t4, t4, N
				add a4, a1, t4 // guardamos en a4 la direccion de x[i][k]
				mv t4, t6
				mul t4, t4, a0
				add t4, t4, t1
				slli t4, t4, N
				add a5, a2, t4 // guardamos en a5 la direccion de y[k][j]
				lw t4, 0(a4)
				lw t5, 0(a5)
				mul t4, t4, t5
				add t4, t4, t3 // ya teniamos t3
				sw t4, 0(t2)
				addi t6, t6, 1
				j mulfor3
			mulfin3:
				li t6, 0
				addi t1, t1, 1
				j mulfor2
		mulfin2:
			li t1, 0
			addi t0, t0, 1
			j mulfor1
	mulfin1:
		ret

/*
void matrixPow(int n, int x[n][n], int e, int z[n][n]) {
    int aux[n][n];
    for (int j=0; j<n; j++)
      for (int k=0; k<n; k++)
          if (j==k)
              z[j][k] = 1;
          else
              z[j][k] = 0;
    for (int i = 1; i <= e; i++) {
        matrixMul(n, x, z, aux);
        matrixCopy(n, aux, z);
} */

.global matrixPow
// recibimos n: a0, x: a1, e: a2, z: a3
// i = t0, j = t1, k = t2
matrixPow:
	prol:
 	// los 6 registros s0-s5 por 4 bytes
	addi sp, sp, -24
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	mul t3, a0, a0
	slli t3, t3, N
	// reservamos marco de pila para aux
	sub sp, sp, t3
	// guardamos en pila ra por ser no hoja
	addi sp, sp, -4
	sw ra, 0(sp)
	// cargamos en registro
	li t0, 0
	li t1, 0
	li t2, 0
	// cargamos en registro seguro
	mv s0, a0 // n
	mv s1, a1 // x
	mv s2, a2 // e
	mv s3, a3 // z
	addi t3, sp, 4
	mv s4, t3 // aux
	powfor1: bge t1, s0, powfin1
		powfor2: bge t2, s0, powfin2
				mv t3, t1
				mul t3, t3, s0
				add t3, t3, t2
				slli t3, t3, N
				add t3, s3, t3 // guardamos en t3 la direccion de z[j][k]
			if: bne t1, t2, else
				li t4, 1
				sw t4, 0(t3)
				j then
			else:
				li t4, 0
				sw t4, 0(t3)
			then:
				addi t2, t2, 1
				j powfor2
		powfin2:
			li t2, 0
			addi t1, t1, 1
			j powfor1
	powfin1:
		li s5, 1 // ahora cargamos aqui i
	powfor3:
		blt s2, s5, prologo
		// pasamos: n, x, z, aux
		mv a0, s0
		mv a1, s1
		mv a2, s3
		mv a3, s4
		call matrixMul
		// pasamos: n, aux, z
		mv a0, s0
		mv a1, s4
		mv a2, s3
		call matrixCopy
		addi s5, s5, 1
		j powfor3
	prologo:
		// volvemos a cargar ra
		lw ra, 0(sp)
		addi sp, sp, 4
		// liberamos la memoria de aux
		mul t3, s0, s0
		slli t3, t3, N
		add sp, sp, t3
		// los 6 registros s0-s5 por 4 bytes
		lw s0, 0(sp)
		lw s1, 4(sp)
		lw s2, 8(sp)
		lw s3, 12(sp)
		lw s4, 16(sp)
		lw s5, 20(sp)
		addi sp, sp, 24
		ret
