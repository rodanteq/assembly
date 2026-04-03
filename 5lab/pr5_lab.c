/*---------------------------------------------------------------------
**
**  Fichero:
**    pr5_lab.c  15/01/2025
**
**    (c) J.M. Mendias
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 5_lab
**
**-------------------------------------------------------------------*/
void matrixMul(int n, int x[n][n], int y[n][n],int z[n][n]){
	for(int i = 0; i<n; i++){
		for(int j = 0; j<n; j++){
			z[i][j] = 0;
			for(int k = 0; k<n; k++){
				z[i][j] = z[i][j] + x[i][k] * y[k][j];
			}
		}
	}
}

void matrixDiv (int n, int x[n][n], int d){
	for(int i = 0; i<n; i++){
			for(int j = 0; j<n; j++){
				x[i][j] = x[i][j]/d;
			}
	}

}
