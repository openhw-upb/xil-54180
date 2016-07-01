#include "lda_regression.h"

LDArne::LDArne(uint16_t nbrSamples, uint16_t numChannels, uint16_t numFeatures, uint16_t numClasses)
{
    mNumClasses = numClasses;
    nVars = numChannels * numFeatures; // = nbrChannels*nbrFeatures

    /* alloc space for the data needed by the calculation
     * of the weights and offset
     */

    mMeanMatrix =  (double*) calloc(nVars*mNumClasses, sizeof(double));
    mCovarianceSum = (double*) calloc(nVars*nVars, sizeof(double));

    m_projectionMatrix = new ProjectionMatrix_R(NULL,mNumClasses,nVars);

    mCurrentClass = 1;
}

LDArne::~LDArne()
{
    free(mMeanMatrix);
    free(mCovarianceSum);

}

void LDArne::setCurrentClass(uint16_t pClass) {
    mCurrentClass = pClass;
}

/** add single training dataset **/
void LDArne::addTrainingDataset(const double* pTrainingData, uint16_t nbrElements) {
    uint32_t i = 0;
    for(i=0; i < nbrElements; i++) {
        m_trainingMatrix.push_back(pTrainingData[i]);
    }
}

/** Compute mean and covariance matrix for the class **/
void LDArne::processClass()
{
    //cout << "processClass()" << endl;
    /* declarations*/
    double* meanVector;
    double* cov;


    /* calculate how many features are in that dataset.
     * NOTE: pTrainingData is in normally a matrix with numFeatures columns
     * and nVars rows. div should be working without rest
     */ 
    //uint16_t numFeatures = nbrElements/nVars;
    int32_t numFeatures = (int32_t) m_trainingMatrix.size()/nVars;
    mNumFeatures.push_back(numFeatures);
    cout << "numFeatures: " << numFeatures << endl;

    /* got data of a new class, so claculate the covariance 
     *  and add it to the covariance sum. 
     *  Also calculate the new mean and update the mean matrix
     */

    cout << "mean()" << endl;
    meanVector = getMeanVector(m_trainingMatrix.data(), numFeatures, nVars);

    cout << "covariance()" << endl;
    cov = covariance(m_trainingMatrix.data(), meanVector, numFeatures, nVars);

    cout << "add_to_total()" << endl;
    /* add the covariance to the global covariance sum and update the mean matrix */
    addMatrixToMatrix(cov,mCovarianceSum,nVars,nVars);
    copyVectorToColumn(meanVector,mMeanMatrix,nVars,mNumClasses,mCurrentClass-1);
    
    m_trainingMatrix.clear();
    free(meanVector);
    free(cov);
    cout << "Per class calculations done!" << endl;
}

/**finish the training and compute the weights and offsets*/
int16_t LDArne::train()
{
    /* return status*/
    int16_t status = 1;
    double* invCov;
    double* ldaWeights;
    
    /* finish the calculation of the global covariance by division of mNumClasses*/    
    divMatrixByScalar(mNumClasses,mCovarianceSum,nVars,nVars);

        
    /* calc the weights by inverting the global covariance with cholesky*/
    //size [nVars , nVars]
    invCov = choleskyInverse(mCovarianceSum,nVars);

    //size [ nVars , mNumClasses]
    ldaWeights = matrixMultiplication(invCov,nVars,nVars,mMeanMatrix,mNumClasses);

    /* transpose the result for easier computation of the discriminants*/
    //size [mNumClasses, nVars]
    mWeightMatrix = transpose(ldaWeights,nVars,mNumClasses);

    uint32_t i;
    uint32_t j;

    for(i=0; i < mNumClasses; i++) {
        for(j=0; j < nVars; j++) {
            m_projectionMatrix->setAt(mWeightMatrix[i*nVars + j], i, j);
        }
    }

    /* calc the offset */
    mOffsets = multiDimScalarProduct(mMeanMatrix,ldaWeights,nVars,mNumClasses);
    mulMatrixWithScalar(-0.5,mOffsets,1,mNumClasses);
    addScalarToMatrix(log(1.0/((double)mNumClasses)),mOffsets,1,mNumClasses);

    free(invCov);
    free(ldaWeights);

    return status;
}