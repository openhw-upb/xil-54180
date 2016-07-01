#ifndef PROJECTION_MATRIX_H_R
#define PROJECTION_MATRIX_H_R

#ifdef UNITTESTS
	#include <inttypes.h> /* for uint16 ... TODO: replace with reconos late*/
#else
	extern "C" {
	#include "reconos.h"
	#include "reconos_app.h"
	#include "mbox.h"
}
#endif
#include <string.h>
#include <algorithm>

using namespace std;

class ProjectionMatrix_R {

private:

	double*  m_projectionMatrix;
	uint32_t mRows;
	uint32_t mCols;

public:
	// Constructor
	ProjectionMatrix_R(const double* data = NULL, uint32_t rows = 0, uint32_t cols = 0);
	// Destructor
	~ProjectionMatrix_R();

	// Getter
	double*  getData()		  { return m_projectionMatrix; }

	uint32_t getRows()	const { return mRows; }
	uint32_t getCols()	const { return mCols; }

	const double*	getProjectionMatrix() { return m_projectionMatrix; }

	const double at(uint32_t row, uint32_t col) const { return m_projectionMatrix[row*mCols + col]; }

	void 	setAt(double value, uint32_t row, uint32_t col) { m_projectionMatrix[row*mCols + col] = value; }
	void	setRows(uint32_t rows);
	void	setCols(uint32_t cols);

	void	reduceDimension(uint16_t cols);
};

#endif /* PROJECTION_MATRIX_H_R */