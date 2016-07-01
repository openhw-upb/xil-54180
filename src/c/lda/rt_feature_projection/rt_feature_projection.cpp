extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}


#include "../lib/runtime/pglib/feature_projection_r.h"
#include "../lib/runtime/pglib/sample_identifier.h"
#include "../lib/runtime/pglib/extractor_selector.h"
#include "../lib/runtime/pglib/logtime.h"

#include <iostream>
#include <stdio.h>
#include <sys/time.h>

#define REDUCED_DIM		7

using namespace std;

extern struct mbox *mbox_init_feature_projection;

extern struct mbox *mbox_mav_mav;

extern struct mbox *mbox_feature_window;
extern struct mbox *mbox_projected_features;

extern struct mbox *mbox_lda_training_dataset;
extern struct mbox *mbox_lda_projection_matrix;

extern struct mbox *mbox_lda_class_means;

extern struct mbox *mbox_ack_classification;

extern "C" void *rt_feature_projection(void *data_) {
	int16_t resultTraining = -1;
	uint32_t id = 0;
	int16_t assignedClass = 0;
	int16_t mav = 0;
	double* pFeatureWindow = NULL;
	const uint32_t* pFeatureWindowHW = NULL;

	ProjectionMatrix_R* pProjectionMatrix = NULL;

	// Init. data
	uint32_t windowSize = (uint32_t)mbox_get(mbox_init_feature_projection);
	uint32_t nbrFeaturesHW = (uint32_t)mbox_get(mbox_init_feature_projection);
	uint32_t nbrChannels = (uint32_t)mbox_get(mbox_init_feature_projection);
	pFeatureWindow = (double*)mbox_get(mbox_init_feature_projection);
	pFeatureWindowHW = (uint32_t*)mbox_get(mbox_init_feature_projection);
	double* pProjectedFeatures = (double*)mbox_get(mbox_init_feature_projection);
	uint32_t extractorSelectorSW = mbox_get(mbox_init_feature_projection);
	uint32_t extractorSelectorHW = mbox_get(mbox_init_feature_projection);
	
	FeatureProjection_R* projector = new FeatureProjection_R(pProjectionMatrix);

	while(1) {
		uint32_t id_class;
		
		id_class = mbox_get(mbox_feature_window);
		
		if(extractorSelectorSW > 0) {

			// If MAV is calculated in SW get MAV-MAV here and pass it afterwards to the TCP/IP-Server
			if( extractorSelectorSW & SEL_MAV ) {
				uint32_t o = 0;
				mav = 0;
				for(o=0; o < nbrChannels; o++) {
					mav += pFeatureWindowHW[nbrFeaturesHW*nbrChannels + o];
				}
				mav /= nbrChannels;
			}
		}

		if(extractorSelectorHW > 0) {

			uint16_t offsetHWFeature = 0;
			uint16_t i = 0;

			// Copy features extracted in HW into Feature-Window of Feature-Window of SW (cast into double needed until now)
			if( extractorSelectorHW & SEL_MAV ) {
				// If MAV is calculated in SW get MAV-MAV here and pass it afterwards to the TCP/IP-Server
				mav = 0;
				for(i=0; i < nbrChannels; i++) {
					pFeatureWindow[i] = (double)pFeatureWindowHW[i]/windowSize;
					mav += pFeatureWindow[i];
				}
				offsetHWFeature += nbrChannels;
				mav /= nbrChannels;
			}

			if( extractorSelectorHW & SEL_SSC ) {
				for(i=0; i < nbrChannels; i++) {
					pFeatureWindow[offsetHWFeature + i] = (double)pFeatureWindowHW[offsetHWFeature + i];
				}
				offsetHWFeature += nbrChannels;
			}

			if( extractorSelectorHW & SEL_WFL ) {
				for(i=0; i < nbrChannels; i++) {
					pFeatureWindow[offsetHWFeature + i] = (double)pFeatureWindowHW[offsetHWFeature + i];
				}
				offsetHWFeature += nbrChannels;
			}

			if( extractorSelectorHW & SEL_ZC ) {
				for(i=0; i < nbrChannels; i++) {
					pFeatureWindow[offsetHWFeature + i] = (double)pFeatureWindowHW[offsetHWFeature + i];
				}
			}
		}

		// Pass MAV-MAV back to TCP/IP-Server
		mbox_put(mbox_mav_mav, (uint32_t)mav);

		// Extract ID
		id = id_class & 0x00ff;
		
		//cout << "Feature-Projection" << endl << "\t" << "ID: " << id << endl;

		switch(id) {
			case ID_TRAIN:
				// Get assigned class
				assignedClass = ((id_class & 0xff00) >> 8);

				// Pass data to LDA
				// Pass ID of the data
				mbox_put(mbox_lda_training_dataset, (uint32_t)id);
				// Pass address to data
				mbox_put(mbox_lda_training_dataset, (uint32_t)pFeatureWindow);
				// Give assigned class to training
				mbox_put(mbox_lda_training_dataset, (uint32_t)assignedClass);

				// Wait for LDA to add data
				mbox_get(mbox_lda_projection_matrix);

				mbox_put(mbox_projected_features, 0);
			break;

			case ID_TRAIN_AND_FINISH:
				cout << "Feature-Projection" << endl << "\t" << "ID: " << id << endl;
				// Get assigned class
				assignedClass = ((id_class & 0xff00) >> 8);

				// Pass data to LDA and trigger Training-Function
				// Pass ID of the data
				mbox_put(mbox_lda_training_dataset, (uint32_t)id);
				// Pass address to data
				mbox_put(mbox_lda_training_dataset, (uint32_t)pFeatureWindow);
				// Give assigned class to training
				mbox_put(mbox_lda_training_dataset, (uint32_t)assignedClass);

				// Wait for training to be finished and get Projection-Matrix

				// If training was successful get pointer to Projection-Matrix and give it to Feature-Projection
				resultTraining = (int16_t)mbox_get(mbox_lda_projection_matrix);
				// Check if training was successful and store Projection-Matrix if so
				if( resultTraining >= 0 ) {
					pProjectionMatrix = (ProjectionMatrix_R*)mbox_get(mbox_lda_projection_matrix);

					cout << "f: got projection matrix" << endl;

					projector->setProjectionMatrix(pProjectionMatrix);
					projector->reduceDimension(REDUCED_DIM);
				}
				mbox_put(mbox_projected_features, 0);
			break;

			case ID_CLASSIFY:
				// Project data and pass them to classifier
				// Project the features
				if( projector->getProjectionMatrix() != NULL ) {
						projector->projectFeatures(pFeatureWindow, pProjectedFeatures);
				}
				else {
					cout << "FP" << endl << "\tInvalid Projection-Matrix " << endl;
				}

				// Send projected features to classifier
				mbox_put(mbox_lda_class_means, 0);
				mbox_put(mbox_projected_features, (uint32_t)pProjectedFeatures);
			break;

			default:
				cout << "Wrong ID!" << endl;
			break;
		}
	}

	pthread_exit(0);
}
