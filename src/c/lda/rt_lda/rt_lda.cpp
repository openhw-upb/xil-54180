extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "../lib/runtime/pglib/lda_regression.h"
#include "../lib/runtime/pglib/sample_identifier.h"
#include "../lib/runtime/pglib/timediff.h"

#include <iostream>
#include <sys/time.h>
#include <sys/types.h>

#define NBR_SAMPLES_4_TRAINING 	10000

using namespace std;

extern struct mbox *mbox_init_lda;

extern struct mbox *mbox_lda_training_dataset;
extern struct mbox *mbox_lda_projection_matrix;
extern struct mbox *mbox_lda_class_means; // also used for offsets

extern "C" void *rt_lda(void *data_) {
	int16_t resultTraining = -1;
	uint32_t id = 0;
	const double* pTrainingData = NULL;
	uint32_t nVars = 0;
	int16_t assignedClass = 1;
	int16_t lastClass = 1;

	// Init. data
	uint32_t nbrFeatures = (uint32_t)mbox_get(mbox_init_lda);
	uint32_t nbrChannels = (uint32_t)mbox_get(mbox_init_lda);
	uint32_t nbrClasses  = (uint32_t)mbox_get(mbox_init_lda);

	uint32_t nbrElements = nbrChannels*nbrFeatures;

	double* offsets = NULL;
	
	// Create an LDA
	LDArne* lda = new LDArne(NBR_SAMPLES_4_TRAINING, nbrChannels, nbrFeatures, nbrClasses);

	while(1) {
		// Get ID of the incomming-data
		id = mbox_get(mbox_lda_training_dataset);

		switch(id) {
			case ID_TRAIN:
				// Get Training-Data
				pTrainingData = (const double*)mbox_get(mbox_lda_training_dataset);
				// Get assigned class
				assignedClass = (int16_t)mbox_get(mbox_lda_training_dataset);

				// If we got the last class sample: perform class preprocessing
				if(lastClass != assignedClass) {
					cout << "Current class: " << lastClass << endl;

					lda->processClass();
				}

				// Add Training-Data
				lda->setCurrentClass((uint16_t)assignedClass);
				lda->addTrainingDataset(pTrainingData, nbrElements);

				lastClass = assignedClass;
				// Signal completion to Feature-Projection
				mbox_put(mbox_lda_projection_matrix, 0);
				// Signal completion to classification
				mbox_put(mbox_lda_class_means, 0);
			break;

			case ID_TRAIN_AND_FINISH:
				cout << "LDA" << endl << "\t" << "ID: " << id << endl;
				
				// Get Training-Data
				pTrainingData = (const double*)mbox_get(mbox_lda_training_dataset);
				// Get assigned class
				assignedClass = (int16_t)mbox_get(mbox_lda_training_dataset);

				// Add Training-Data
				lda->setCurrentClass((uint16_t)assignedClass); // probably not necessary
				lda->addTrainingDataset(pTrainingData, nbrElements);

				cout << "Current class: " << assignedClass << endl;

				lda->processClass();

				// Train LDA
				cout << "LDA" << endl << "\tTrain..." << endl;

				// Measure time of training
				struct timespec start, end;
				struct timespec elapsedTime_s;
				double elapsedTime;

				clock_gettime(CLOCK_ID, &start);

				resultTraining = lda->train();

				clock_gettime(CLOCK_ID, &end);

				elapsedTime_s = getTimeDiff(start, end);
				elapsedTime = elapsedTime_s.tv_sec + (double)elapsedTime_s.tv_nsec/NANO;
				cout << "\tTime for training: " << elapsedTime << " sec" << endl;

				// Pass result of training
				mbox_put(mbox_lda_projection_matrix, (uint32_t)resultTraining);

				// If training was successful pass pointer to Projection-Matrix, otherwise pass not
				if( resultTraining >= 0 ) {
					// Display result
					cout << "LDA" << endl << "\tResult training = " << resultTraining;
					switch(resultTraining) {
						case 1:
							cout << ": Task has been solved." << endl;
							break;
						case 2:
							cout << ": There was a multicollinearity in training set, but task has been solved." << endl;
							break;
					}

					// Compute Mean-Vectors for classifier and afterwards pass pointer to it with the dimension

					offsets = lda->getOffsets();
					mbox_put(mbox_lda_class_means, (uint32_t)offsets);

					mbox_put(mbox_lda_class_means, (uint32_t)nbrClasses);
					mbox_put(mbox_lda_class_means, (uint32_t)nVars);

					// Pass Projection-Matrix to Feature-Projection
					mbox_put(mbox_lda_projection_matrix, (uint32_t)(lda->getProjectionMatrix()));
				}
				else {
					// Signal completion to classification
					mbox_put(mbox_lda_class_means, 0);
				}

			break;

			case ID_CLASSIFY:
				cout << "Data took wrong path! Data for classifying in trainingpath!" << endl;
			break;

			default:
				cout << "Wrong ID!" << endl;
			break;
			}
	}

	pthread_exit(0);
}
