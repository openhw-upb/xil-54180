#include "stdio.h"
//#include "evm5515.h"

#include <stdlib.h>
#include <math.h>
#include <iostream>
#include "numerics.h"
#include <sys/time.h>

using namespace std;


timespec start, end, elapsedTime_s;
long elapsedTime;

/**
 * Displays the content of a mxn matrix.
 * \param A a pointer to the matrix array
 * \param m the count of rows
 * \param n the count of columns
 */ 
void show_matrix(double *A, int m, int n) {
    int i,j;
    for (i = 0; i < m; i++) {
        for (j = 0; j < n; j++)
            printf("%2.5f ", A[i * n + j]);
        printf("\n");
    }
}

void writeFeatures(double *out, string fileName, int rows, int cols) {
    FILE *fp;

    fp = fopen(fileName.c_str(),"w");

    for(int i = 0; i < rows; i++) {
        for(int j = 0; j < cols; j++) {
            fprintf(fp,"%f,",out[j+i*cols]);
            // fprintf(stdout,"%4f,",out[j+i*cols]);
        }
        fprintf(fp,"\n");
        // fprintf(stdout,"\n");
    }

    fclose(fp);
}

/**
 * transpose a mxn matrix.
 * \param matrix a pointer to the matrix array
 * \param m the count of rows
 * \param n the count of columns
 */
double* transpose(double *matrix, int m, int n)
{
	int i,j;
    double *result;
	
    result = (double*)calloc(n*m, sizeof(double));
    
    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
        {
        	result[j*m + i] = matrix[i*n + j];
        }
	return result;
}

/**
 * Displays the content of a row or column vector.
 * \param A a pointer to the vector array
 * \param n the count of columns or rows
 */ 
void show_vector(double *v, int n) {
    int i;
    for (i = 0; i < n; i++){
        printf("%2.5f ", v[i]);
        printf("\n");
    }
    printf("\n");

}


/** 
 * a simple matrix-matrix multiplication(MMM) of an mxn matrix with an nxp matrix.
 * The idea was taken from spru422j, see function mmul.
 * \param matrixA a pointer to the first matrix array
 * \param m the count of rows of matrixA
 * \param n the count of columns of matrixA
 * \param matrixB a pointer to the second matrix array
 * \param p the count of columns of matrixB
 */
double* matrixMultiplication(double* matrixA,int m,int n,double* matrixB,int p)
{
    int i,k,j;
    double * result;
    double temp;

    result = (double*)calloc(m*p, sizeof(double));
    if (result == NULL)
        exit(EXIT_FAILURE);

    for (i=0;i<m;i++)
    {
        for (k=0;k<p;k++)
        {
            temp = 0;
            for (j=0;j<n;j++)
                temp = temp + (matrixA[i*n + j] * matrixB[j*p + k]);
            result[i*p + k] = temp;
        }
    }

    return result;

}

/** Calculate the scalar product of two mxn matrices.
 * The scalar product is calcuted like matlab, column by column.
 * \param matrixA a pointer to the first matrix array
 * \param matrixB a pointer to the second matrix array
 * \param m the count of rows of matrixA and matrixB
 * \param n the count of columns of matrixA and matrix
 */
double* multiDimScalarProduct(double* matrixA,double* matrixB,int m,int n)
{
    int i,j;
    double* result;

    result = (double*)calloc(n, sizeof(double));
    if (result == NULL)
        exit(EXIT_FAILURE);

    for (j=0;j<n;j++)
    {
        result[j]=0;
        for (i=0;i<m;i++)
        {
            result[j]+= matrixA[i*n+j]*matrixB[i*n+j];
        }
    }

    return result;
}

/** based on an algo from wikipedia */
double* choleskyEvaluate(double* L, double* b,int n)
{
  // Ax = b -> LUx = b. Then y is defined to be Ux
    int i = 0;
    int j = 0;
	double* x;
	double* y;
    x = (double*)calloc(n, sizeof(double));
    if (x == NULL)
        exit(EXIT_FAILURE);

    y = (double*)calloc(n, sizeof(double));
    if (y == NULL)
        exit(EXIT_FAILURE);

    // Forward solve Ly = b
    for (i = 0; i < n; i++)
    {
        y[i] = b[i];
        for (j = 0; j < i; j++)
        {
            y[i] -= L[i*n +j] * y[j];
        }
        y[i] /= L[i*n +i];
    }
    // Backward solve Ux = y
    for (i = n - 1; i >= 0; i--)
    {
        x[i] = y[i];
        for (j = i + 1; j < n; j++)
        {
            //becuase we use the transpose of L we switched i and j for L
            x[i] -= L[j*n +i] * x[j];
        }
        x[i] /= L[i*n +i];
    }

    free(y);

    return x;
}

/** Get a column mean Vector of size n, for a given mxn matrix */
double * getMeanVector(double* matrix,int m,int n)
{
    int i,j;
    double *mx;

    mx = (double*)calloc(n, sizeof(double));
    if (mx == NULL)
        exit(EXIT_FAILURE);

    for( j = 0; j< n; j++)
    {
        mx [j] = 0;
        for( i = 0; i< m; i++)
        {
            mx[j] = mx [j] + matrix[i*n + j];
        }
        mx[j] = (mx[j] / m);
    }

    return mx;
}


/** Get a covariance matrix of size nxn, for a given mxn matrix */
double *covariance(double* matrix, double* mx, int m,int n)
{
    int i,j,k;
    double *cov;

    cov = (double*) calloc(n* n, sizeof(double));
    if (cov == NULL)
        exit(EXIT_FAILURE);

    //mx = (double* )getMeanVector(matrix,m,n);

    for( k = 0; k< m; k++)
    {
        for( i = 0; i< n; i++)
        {
            for( j = n-1; j > i-1 ;j--)
            {
                cov[i*n + j] = cov[i*n + j] + (matrix[k*n + i] - mx[i])*(matrix[k*n + j]-mx[j]);
            }
        }
    }

    for( i = 0; i< n; i++)
    {
        for( j = n-1; j > i-1 ;j--)
        {
            cov[i*n + j] = cov[i*n + j] / (m-1);
            cov[j*n + i] = cov[i*n + j];
        }
    }
    //free(mx);

    return cov;
}

/**from http://rosettacode.org/wiki/Rosetta_Code */
double *cholesky(double *matrix, int n) {
    int i,j,k;
    double s;
    double *L;

    L = (double*)calloc(n * n, sizeof(double));
    if (L == NULL)
        exit(EXIT_FAILURE);

    for (i = 0; i < n; i++)
        for (j = 0; j < (i+1); j++) {
            s = 0;
            for (k = 0; k < j; k++) {
                s += L[i * n + k] * L[j * n + k];
                // if (i == 526 && j == 526)
                // {  
                //     cout.precision(25);
                //     cout << "s += L[i * n + k] * L[j * n + k]: " << L[i * n + k] << " * " << L[j * n + k] << " += " << s << endl; 
                // }
            }

            if (i == j){
                // cout.precision(25);
                // cout << "matrix: " << matrix[i * n + j] << " s: " << s << " diff: " <<  (matrix[i * n + j] - s) << endl;
                if ((matrix[i * n + i] - s) < 0) {
                    cout << "ERROR: sqrt of negative number! at position: " << i * n + j << endl;
                    cout.precision(25);
                    cout << "matrix[i * n + i] - s =  " << matrix[i * n + j] << " - " << s << " = " << matrix[i * n + i] - s << endl;
                }
                L[i * n + j] = sqrt(matrix[i * n + j] - s);
            }
            else {
                if (L[j * n + j] * (matrix[i * n + j] - s) == 0) {
                    cout << "ERROR: division by zero!" << endl;
                    cout.precision(25);
                    cout << "L[j * n + j] * (matrix[i * n + j] - s) = " << L[j * n + j] << " * (" << matrix[i * n + j] << " - " << s << ") = " << L[j * n + j] * (matrix[i * n + j] - s) << endl; 
                }
                L[i * n + j] = (1.0 / L[j * n + j]) * ((matrix[i * n + j] - s));
            }

            // Same in short form:
            // L[i * n + j] = (i == j) ?
            //               sqrt(matrix[i * n + i] - s) :
            //               (1.0 / L[j * n + j] * (matrix[i * n + j] - s));
        }

    return L;
}

/** invert a nxn matrix with cholesky */
double *choleskyInverse(double *matrix, int n)
{
    double *x;
    double *y;
    double *L;
    double *result;
    int i,j;

    result = (double*) calloc(n* n, sizeof(double));
    if (result == NULL)
        exit(EXIT_FAILURE);

    x = (double*) calloc(n, sizeof(double));
    if (x == NULL)
        exit(EXIT_FAILURE);

    L = cholesky(matrix,n);

    // ########################### DEBUG ###########################
    // writeFeatures(matrix,"cholesky_matrix.csv",n,n);
    // writeFeatures(L,"cholesky_L.csv",n,n);
    // ########################### END DEBUG #######################

    for (i=0;i<n;i++)
    {
        x[i] = 1;
        /* foward -backward substitution */
        y = choleskyEvaluate(L,x,n);
        /* copy the vector in a column of the result matrix */
        for (j=0;j<n;j++)
            result[j*n + i] = y[j];

        free(y);
        x[i] = 0;
    }

    // ########################### DEBUG ###########################
    // writeFeatures(result,"cholesky_result.csv",n,n);
    // ########################### END DEBUG #######################


    free(x);
    free(L);

    return result;
}

/** add a mxn matrix to an mxn matrix */
void addMatrixToMatrix(double* srcMatrix,double* destMatrix,int m, int n)
{
    int i,j;

    for(i=0;i<m;i++)
    {
        for(j=0;j<n;j++)
        {
            destMatrix[i*n + j] += srcMatrix[i*n + j];
        }
    }
}

/** ad a scalar to all entries of the mxn matrix */
void addScalarToMatrix(double scalar,double* matrix,int m,int n)
{
    int i,j;

    for(i=0;i<m;i++)
    {
        for(j=0;j<n;j++)
        {
            matrix[i*n + j] += scalar;
        }
    }

}

/** multiply a scalar to all entries of the mxn matrix */
void mulMatrixWithScalar(double scalar,double* matrix,int m,int n)
{
    int i,j;

    for(i=0;i<m;i++)
    {
        for(j=0;j<n;j++)
        {
            matrix[i*n + j] *= scalar;
        }
    }

}

/** div all entries of the mxn matrix by a scalar*/
void divMatrixByScalar(double scalar,double* matrix,int m,int n)
{
    int i,j;

    for(i=0;i<m;i++)
    {
        for(j=0;j<n;j++)
        {
            matrix[i*n + j] /= scalar;
        }
    }

}

/** copy a vector to an column of a mxn matrix.
 * The row index is starting by 0.
 * \param vector a point er to the vector which data is copied.
 * \param matrix a pointer to the matrix array
 * \param m the count of rows of the matrix
 * \param n the count of columns of the matrix
 */ 
 void copyVectorToColumn(double*vector,double* matrix,int m,int n,int row)
 {
    int i;

    for(i=0;i<m;i++)
    {
        matrix[i*n + row] = vector[i];
    }
 }
