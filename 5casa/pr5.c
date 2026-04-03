/*---------------------------------------------------------------------
**
**  Fichero:
**    pr5.c  15/01/2025
**
**    (c) J.M. Mendias
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 5
**
**-------------------------------------------------------------------*/

#define N     5   //número de nodos del grafo
#define STEPS 3   //número de escalas del camino
#define ORG	  0   //nodo origen
#define DST	  3   //nodo destino

extern void matrixPow(int n, int [n][n], int, int [n][n]);

int graph[N][N] =   //matriz de adyacencia del grafo
{
    {0, 1, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {1, 0, 0, 0, 1},
    {1, 0, 1, 0, 1},
    {0, 0, 0, 1, 1}
};
int z[N][N];        //matriz resultado del algoritmo
int paths;

void main() {

    matrixPow(N, graph, STEPS, z);

    paths = z[ORG][DST];

	while(1);
}
