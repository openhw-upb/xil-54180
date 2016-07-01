#ifndef LDArne_H
#define LDArne_H

#include <iostream>
#include <vector>
#include "numerics.h"
#include "timediff.h"
#include <stdio.h> /*printf*/
#include <stdlib.h> /*calloc*/
#include "math.h" /*log*/

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

class LDArne {

private:

    /** temporary dataset for the currently processed class **/
    vector<double> m_trainingMatrix;;

    /** the number of classes */
    uint16_t mNumClasses;

    /** the dimension of a feature */
    uint16_t nVars; // = nbrChannels*nbrFeatures

    /** how much features has a specific class 
     *  maybe important for non uniform training sets
     */
    vector<uint16_t> mNumFeatures;

    /** The LDA has a projection matrix known as weights 
     *  and offsets for the classification
     */
    double* mOffsets;

    /** the saved matrix is the transpose of the original one.
     *  This allows easier computation of the discriminants 
     */
    double* mWeightMatrix;
    ProjectionMatrix_R* m_projectionMatrix;

    /** every class can have their own specific label. 
     *  class i have position i in this vector.
     */
    vector<uint16_t> mLabels;

    /** data needed for the calculation of the offset and weights */
    double* mMeanMatrix; //[nVars* mNumClasses];
    double* mCovarianceSum; //[nVars*nVars];

    /** index for the current class starting with 1 */
    uint16_t mCurrentClass;

public:
    /** Constructor */
    LDArne(uint16_t nbrSamples, uint16_t numChannels, uint16_t numFeatures, uint16_t numClasses);
    /**Destructor */
    ~LDArne();

    /* important getters */
    ProjectionMatrix_R*  getProjectionMatrix()         { return m_projectionMatrix; }
    double*            getOffsets()            const { return mOffsets; }
    uint16_t           getNumClasses()         const { return mNumClasses; }
    uint16_t           getDimFeatures()        const { return nVars; }
    vector<uint16_t>   getLabels()             const { return mLabels; }
    double*            getClassMeans()         const { return mMeanMatrix; }
    void               getDimensionsOfClassMeanVectors(uint32_t& nbrClasses, uint32_t& nVars) const { nbrClasses = mNumClasses; nVars = nVars; };

    /* set the class for the upcoming datasets */
    void    setCurrentClass(uint16_t pClass);

    /** add Training data. */
    void    addTrainingDataset(const double* pTrainingData, 
                               uint16_t nbrElements);

    /* Calculate cov() and mean() for class */
    void    processClass();

    // Not needed for LDArne
    void    computeClassMeans();

    /**finish the training and compute the weights and offsets*/
    int16_t train();
    void    reset();
};

#endif /* LDArne_H */