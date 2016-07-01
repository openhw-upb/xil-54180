#ifndef CLASSIFICATION_H_R
#define CLASSIFICATION_H_R

#ifdef UNITTESTS
	#include <inttypes.h> /* for uint16 ... TODO: replace with reconos late*/
#else
	extern "C" {
	#include "reconos.h"
	#include "reconos_app.h"
	#include "mbox.h"
}
#endif


#include <iostream>

using namespace std;

class Classification_R {

private:
	uint16_t 	m_dimension; // = number of classes (-1?)
	double*		m_offsets;

public:
	// Constructor
	Classification_R();
	//Destructor
	~Classification_R();

	void setOffset(double* offsets)				{ m_offsets = offsets; }
	void setDimension(uint16_t dim)				{ m_dimension = dim; }

	int16_t classify(const double* data);
	void 	reset();
};

#endif /* CLASSIFICATION_H_R */