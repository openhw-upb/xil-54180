#ifndef NUMERICS_H_
#define NUMERICS_H_

#include "logtime.h"
#include "timediff.h"
#include <string>

/**
 * Displays the content of a mxn matrix.
 * \param A a pointer to the matrix array
 * \param m the count of rows
 * \param n the count of columns
 */ 
void show_matrix(double *A, int m, int n);

void writeFeatures(double *out, std::string fileName, int rows, int cols);

/**
 * transpose a mxn matrix.
 * \param matrix a pointer to the matrix array
 * \param m the count of rows
 * \param n the count of columns
 */
double* transpose(double *matrix, int m, int n);

/**
 * Displays the content of a row or column vector.
 * \param A a pointer to the vector array
 * \param n the count of columns or rows
 */ 
void show_vector(double *v, int n);

/** 
 * a simple matrix-matrix multiplication(MMM) of an mxn matrix with an nxp matrix.
 * The idea was taken from spru422j, see function mmul.
 * \param matrixA a pointer to the first matrix array
 * \param m the count of rows of matrixA
 * \param n the count of columns of matrixA
 * \param matrixB a pointer to the second matrix array
 * \param p the count of columns of matrixB
 */
double* matrixMultiplication(double* matrixA,int m,int n,double* matrixB,int p);

/** Calculate the scalar product of two mxn matrices.
 * The scalar product is calcuted like matlab, column by column.
 * \param matrixA a pointer to the first matrix array
 * \param matrixB a pointer to the second matrix array
 * \param m the count of rows of matrixA and matrixB
 * \param n the count of columns of matrixA and matrix
 */
double* multiDimScalarProduct(double* matrixA,double* matrixB,int m,int n);

/** based on an algo from wikipedia */
double* choleskyEvaluate(double* L, double* b,int n);

/** Get a column mean Vector of size n, for a given mxn matrix */
double * getMeanVector(double* matrix,int m,int n);

/** Get a covariance matrix of size nxn, for a given mxn matrix */
double *covariance(double* matrix, double* mx, int m,int n);

/**from http://rosettacode.org/wiki/Rosetta_Code */
double *cholesky(double *matrix, int n);

/** invert a nxn matrix with cholesky */
double *choleskyInverse(double *matrix, int n);
void addMatrixToMatrix(double* srcMatrix,double* destMatrix,int m, int n);
void addScalarToMatrix(double scalar,double* matrix,int m,int n);
void mulMatrixWithScalar(double scalar,double* matrix,int m,int n);
void divMatrixByScalar(double scalar,double* matrix,int m,int n);
void copyVectorToColumn(double*vector,double* matrix,int m,int n,int row);

#endif /*NUMERICS_H_*/
