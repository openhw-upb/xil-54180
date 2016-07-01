#include "projection_matrix_r.h"

using namespace std;


/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
ProjectionMatrix_R::ProjectionMatrix_R(const double* pData, uint32_t rows, uint32_t cols) 
{
	uint32_t i;
	uint32_t j;

	if (rows != 0 && cols != 0)
		m_projectionMatrix = (double*) calloc(rows*cols,sizeof(double));

	if (pData != NULL)
	{
		for(i=0; i<rows; i++) {
			for(j=0; j<cols; j++) {
				m_projectionMatrix[i*cols+j] = pData[i*cols+j];
			}
		}
	}
	mRows = rows;
	mCols = cols;
}

/**********************************************************************************************************************/
// Destructor
/**********************************************************************************************************************/
ProjectionMatrix_R::~ProjectionMatrix_R()
{	
	free(m_projectionMatrix);
}

/**********************************************************************************************************************/
// Reduce the dimension by deleting the last <cols> projection vectors
/**********************************************************************************************************************/
void ProjectionMatrix_R::reduceDimension(uint16_t cols) {
	
}

void ProjectionMatrix_R::setRows(uint32_t rows) 
{ 
	mRows = rows; 
	free(m_projectionMatrix);
	if (mRows != 0 && mCols != 0)
		m_projectionMatrix = (double*) calloc(mRows*mCols,sizeof(double));

}
void ProjectionMatrix_R::setCols(uint32_t cols)
{ 
	mCols = cols;
	free(m_projectionMatrix);
	if (mRows != 0 && mCols != 0)
		m_projectionMatrix = (double*) calloc(mRows*mCols,sizeof(double));

}