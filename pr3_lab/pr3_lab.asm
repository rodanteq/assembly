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
**	void dotprod(int V[], int W[], int n, int& res) { res va por referencia
**	    int acc = 0;
**	    for (int i = 0; i < n; i++) {
**	        acc = mul(V[i], W[i]); usando RVM
**	    }
**  // hacemos el sw en la propia funcion
**	}
**
**	#define N 4
**	int A[] = {3, 5, 1, 9}
**	int B[] = {1, 6, 2, 3}
**
**	int res;
**
**	void main() {
**	    int normA = dotprod(A, B, N, &res);
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
	li sp, 0x20000
// depurar el llamar de una funcion a otra (ra)
// devolver parametros por a0??
// cuidado alineamiento pila...
// reservar espacio de pila previamente
	la t0, A
	la t1, B
	la a5, res // asi lo pasamos por REFERENCIA
	mv s2, t0
	mv s3, t1
	mv a0, s2
	mv a1, s3
	li a2, N
	call dotprod
	fin:
		j fin


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
		// ahora tenemos que llamar a la funcion mul, pasando V y W por parametros a0, a1 y nos devuelve el resultado por a2
		mv a6, t2
		mv a7, t3
		// ya estan a0 y a1 en sus respectivos registros,
		mul t5, a6, a7
		// nos devuelve el resultado por a2
		// sumamos al antiguo valor de acc
		add a3, t5, a3
		// sumamos uno a i y volvemos a empezar
		addi t0, t0, 1
		j for
	then:
		// devolvemos por REFERENCIA res en a5
		sw a3, 0(a5)
		ret
