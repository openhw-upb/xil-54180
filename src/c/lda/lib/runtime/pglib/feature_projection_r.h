#ifndef FEATURE_PROJECTION_H_R
#define FEATURE_PROJECTION_H_R

#ifdef UNITTESTS
	#include <inttypes.h> /* for uint16 ... TODO: replace with reconos late*/
#else
	extern "C" {
	#include "reconos.h"
	#include "reconos_app.h"
	#include "mbox.h"
}
#endif
#include "projection_matrix_r.h"

using namespace std;

class FeatureProjection_R {

private:

	ProjectionMatrix_R* m_pProjectionMatrix;

public:
	// Constructor
	FeatureProjection_R(ProjectionMatrix_R* pm);
	FeatureProjection_R();
	//Destructor
	~FeatureProjection_R();

	// Getter
	uint16_t getRows()	const { return m_pProjectionMatrix->getRows(); }
	uint16_t getCols()	const { return m_pProjectionMatrix->getCols(); }

	ProjectionMatrix_R* getProjectionMatrix()	const { return m_pProjectionMatrix; }

	// Setter
	void setProjectionMatrix(ProjectionMatrix_R* pm)	{ m_pProjectionMatrix = pm; }

	// Feature projection
	void projectFeatures(const double* pInputVec, double* pOutputVec);

	void reduceDimension(uint16_t dim);
};

#endif /* FEATURE_PROJECTION_H_R */