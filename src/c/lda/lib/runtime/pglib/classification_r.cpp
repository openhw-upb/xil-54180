#include <inttypes.h> /* for uint16 ... TODO: replace with reconos late*/

#include "classification_r.h"

#include <stdio.h>
#include <float.h>

#define WRITE_RESULTS_BACK_2_FILE	0

using namespace std;


/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
Classification_R::Classification_R()
{
	#if (WRITE_RESULTS_BACK_2_FILE == 1)
		cout << "Classification" << endl << "\t" << "Movements will be written back to file." << endl;
	#endif /* WRITE_RESULTS_BACK_2_FILE */
}

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
Classification_R::~Classification_R()
{

}


/**********************************************************************************************************************/
// Classify the data
/**********************************************************************************************************************/
int16_t Classification_R::classify(const double* data)
{
	uint16_t i;
	double max = 0;
	uint16_t classIndex = 0;

	double t = 0;

	max = m_offsets[0] + data[0];

	// Get the index where data+offset is highest
	for(i=1; i < m_dimension; i++) {
		t = m_offsets[i] + data[i];
		if(t > max) {
			max = t;
			classIndex = i;
		}
	}

	#if (WRITE_RESULTS_BACK_2_FILE == 1)
		// Write results to csv-file; Just for testing
		FILE* pCsvFile;
		pCsvFile = fopen("movements.csv", "a+");
			
		if( pCsvFile != NULL ) {
			fprintf(pCsvFile, "%d,", classIndex);
			fprintf(pCsvFile, "\r\n");
		}
		else {
			cout << "Did not open file!\n";
		}
		fclose(pCsvFile);
	#endif /* WRITE_RESULTS_BACK_2_FILE */

	return classIndex;
}

/**********************************************************************************************************************/
// Reset the classifier
/**********************************************************************************************************************/
void Classification_R::reset()
{

}