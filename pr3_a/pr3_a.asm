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
**	int mul(int a, int b) {
**	    int res = 0;
**	    while (b > 0) {
**	        res += a;
**	        b--;
**	    }
**	    return res;
**	}
**
**	int dotprod(int V[], int W[], int n) {
**	    int acc = 0;
**	    for (int i = 0; i < n; i++) {
**	        acc += mul(V[i], W[i]);
**	    }
**	    return acc;
**	}
**
**	#define N 4
**	int A[] = {3, 5, 1, 9}
**	int B[] = {1, 6, 2, 3}
**
**	int res;
**
**	void main() {
**	    int normA = dotprod(A, A, N);
**	    int normB = dotprod(B, B, N);
**	    if (normA > normB)
**	        res = 0xa;
**	    else
**	        res = 0xb;
**	}
**
**-------------------------------------------------------------------*/

.equ N, 4

.data
	A: .word 3, 5, 1, 9
	B: .word 1, 6, 2, 3

.bss
	res: .space 4

.text

.global main

main:

// variables normA, normB, A, B y res (s0, s1, s2, s3 y s4)
// iniciamos sp (la memoria empieza en 10000) con ponerlo en 15000 sera suficiente
	li sp, 0x15000
// depurar el llamar de una funcion a otra (ra)
// devolver parametros por a0??
// cuidado alineamiento pila...
// reservar espacio de pila previamente
	la t0, A
	la t1, B
	mv s2, t0
	mv s3, t1
	mv a0, s2
	mv a1, s2
	li a2, N
	call dotprod
	mv s0, a3
	mv a0, s3
	mv a1, s3
	li a2, N
	call dotprod
	mv s1, a3
	cond:
		ble s0, s1, ent
		li s4, 0xa
		j save
	ent:
		li s4, 0xb
	save:
		la t2, res
		sw s4, 0(t2)
	fin:
		j fin


mul:

// variables: a, b, res
// pasamos a y b por a0 y a1 (los dejamos ahi)

	li a2, 0 // res va a guardarse en a2 (se devuelve por parametro) y en memoria NO
	while:
		ble a1, x0, end
		add a2, a2, a0
		addi a1, a1, -1
		j while
	end:
		ret


dotprod:

// pasamos V, W y n por a0, a1, a2
// variables: V, W, n, acc, i

	li a3, 0 // acc se guarda en a3 para luego devolverlo (por parametro)
	li t0, 0 // i se guarda en t0
	for:
		bge t0, a2, then
		// usamos t1 para cargar las direcciones, t2 y t3 para el valor del array, t4 para desplazar i
		slli t4, t0, 2 // = multiplicar por 4
		add t1, a0, t4 // sumamos el valor de i*4 a la direccion t1
		lw t2, 0(t1) // cargamos
		add t1, a1, t4 // repetimos
		lw t3, 0(t1)
		// guardamos todo en pila (i, n, acc, V y W)
		addi sp, sp, -24
		sw t0, 20(sp)
		sw a2, 16(sp)
		sw a3, 12(sp)
		sw a0, 8(sp)
		sw a1, 4(sp)
		sw ra, 0(sp)
		// ahora tenemos que llamar a la funcion mul, pasando V y W por parametros a0, a1 y nos devuelve el resultado por a2
		mv a0, t2
		mv a1, t3
		// ya estan a0 y a1 en sus respectivos registros,
		call mul
		// nos devuelve el resultado por a2
		// sumamos al antiguo valor de acc
		lw t0, 12(sp)
		add a3, a2, t0
		// cargamos todo lo guardado en pila

		lw t0, 20(sp)
		lw a2, 16(sp)
		lw a0, 8(sp)
		lw a1, 4(sp)
		lw ra, 0(sp)
		addi sp, sp, 24
		// sumamos uno a i y volvemos a empezar
		addi t0, t0, 1
		j for
	then:
		// devolvemos acc por el registro a3
		ret
