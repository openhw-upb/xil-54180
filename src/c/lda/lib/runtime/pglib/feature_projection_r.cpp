#include "feature_projection_r.h"

#include <iostream>
#include "numerics.h"

#define WRITE_PROJECTED_FEATURES_BACK_2_FILE	0
#define WRITE_INPUT_FEATURES_BACK_2_FILE		0

using namespace std;

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
FeatureProjection_R::FeatureProjection_R(ProjectionMatrix_R* pm = NULL) :
	m_pProjectionMatrix(pm)
{
	#if (WRITE_PROJECTED_FEATURES_BACK_2_FILE == 1)
		cout << "Feature-Projection" << endl << "\t" << "Projected features will be written back to file." << endl;
	#endif /* WRITE_PROJECTED_FEATURES_BACK_2_FILE */

	#if (WRITE_INPUT_FEATURES_BACK_2_FILE == 1)
		cout << "Feature-Projection" << endl << "\t" << "Input features will be written back to file." << endl;
	#endif /* WRITE_INPUT_FEATURES_BACK_2_FILE */
}

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
FeatureProjection_R::~FeatureProjection_R()
{

}

/**********************************************************************************************************************/
// Project features
/**********************************************************************************************************************/
void FeatureProjection_R::projectFeatures(const double* pInputVec, double* pOutputVec)
{

	double * projection_matrix = (double*) m_pProjectionMatrix->getProjectionMatrix();



	double* result = matrixMultiplication(projection_matrix,
										 m_pProjectionMatrix->getRows(),
										 m_pProjectionMatrix->getCols(),
										 ((double*) pInputVec),1);

	for(int i = 0;i< m_pProjectionMatrix->getRows();i++)
	{
		pOutputVec[i] = result[i];

	}

	#if (WRITE_INPUT_FEATURES_BACK_2_FILE == 1)
		// Write results to csv-file; Just for testing
		FILE* pCsvFileIF;
		pCsvFileIF = fopen("input_features.csv", "a+");
			
		cout << "Write back input features" << endl;
			
		if( pCsvFileIF != NULL ) {
			uint32_t cntElem = 0;
			uint32_t elements = m_pProjectionMatrix->getCols();
			
			cout << "\tElements:" << elements << endl;

		  for(cntElem=0; cntElem < elements; cntElem++) {
			fprintf(pCsvFileIF, "%f,", pInputVec[cntElem]);
		  }
		fprintf(pCsvFileIF, "\r\n");
		  cout << "Wrote back data to file" << endl;
		}
		else {
			cout << "Did not open file!\n";
		}
		fclose(pCsvFileIF);
	#endif /* WRITE_INPUT_FEATURES_BACK_2_FILE */


	#if (WRITE_PROJECTED_FEATURES_BACK_2_FILE == 1)
		// Write results to csv-file; Just for testing
		FILE* pCsvFileOF;
		pCsvFileOF = fopen("projected_features.csv", "a+");
			
		cout << "Write back projected features" << endl;
			
		if( pCsvFileOF != NULL ) {
			uint32_t cntElem = 0;
			uint32_t elements = m_pProjectionMatrix->getCols();
			
			cout << "\tElements:" << elements << endl;

		  for(cntElem=0; cntElem < elements; cntElem++) {
			fprintf(pCsvFileOF, "%f,", pOutputVec[cntElem]);
		  }
		fprintf(pCsvFileOF, "\r\n");
		  cout << "Wrote back data to file" << endl;
		}
		else {
			cout << "Did not open file!\n";
		}
		fclose(pCsvFileOF);
	#endif /* WRITE_PROJECTED_FEATURES_BACK_2_FILE */



}

/**********************************************************************************************************************/
// Project features
/**********************************************************************************************************************/
void FeatureProjection_R::reduceDimension(uint16_t dim)
{
	//m_pProjectionMatrix->reduceDimension(dim);
}