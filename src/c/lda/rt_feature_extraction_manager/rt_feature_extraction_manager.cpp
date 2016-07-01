extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "../lib/runtime/pglib/feature_extraction.h"
#include "../lib/runtime/pglib/sample_window.h"
#include "../lib/runtime/pglib/sample_identifier.h"
#include "../lib/runtime/pglib/extractor_selector.h"
#include "../lib/runtime/pglib/logtime.h"

#include <iostream>

using namespace std;

extern struct mbox *mbox_init_feature_extraction_manger_sw;

extern struct mbox *mbox_sample_window_sw;
extern struct mbox *mbox_feature_window;


extern "C" void *rt_feature_extraction_manager(void *data) {
	double* pMAV = NULL;
	double* pSSC = NULL;
	double* pWFL = NULL;
	double* pZC = NULL;

	int16_t id_class = 0;

	// Init. data
	uint32_t nbrFeaturesHW = mbox_get(mbox_init_feature_extraction_manger_sw);
	uint32_t nbrChannels = (uint32_t)mbox_get(mbox_init_feature_extraction_manger_sw);
	int16_t  threshold   = (int16_t)mbox_get(mbox_init_feature_extraction_manger_sw);
	double* pFeatureWindow = (double*)mbox_get(mbox_init_feature_extraction_manger_sw);
	uint32_t extractorSelector = mbox_get(mbox_init_feature_extraction_manger_sw);

	// Feature-Extraction init.
	// Give pointer to memory for extracted features to the Feature-Extractors
	// In the Feature-Window first the features calculated in HW are stored followed by the features calculated in SW 
	uint32_t cntFeatures = nbrFeaturesHW;
	if( extractorSelector & SEL_MAV ) {
		pMAV = &(pFeatureWindow[ cntFeatures*nbrChannels ]);
		cntFeatures++;
	}
	if( extractorSelector & SEL_SSC ) {
		pSSC = &(pFeatureWindow[ cntFeatures*nbrChannels ]);
		cntFeatures++;
	}
	if( extractorSelector & SEL_WFL ) {
		pWFL = &(pFeatureWindow[ cntFeatures*nbrChannels ]);
		cntFeatures++;
	}
	if( extractorSelector & SEL_ZC ) {
		pZC = &(pFeatureWindow[ cntFeatures*nbrChannels ]);
	}

	const SampleWindow* pSampleWindow = NULL;
	FeatureExtraction extractor = FeatureExtraction(nbrChannels, 0, threshold);

	while( 1 ) {
		// Wait for new id, if needed assigned class & Sample-Window
		id_class = (int16_t)mbox_get(mbox_sample_window_sw);
		//cout << "Feature-Extraction-Manager" << endl << "\t" << "ID: " << id << endl;

		pSampleWindow = (const SampleWindow*)mbox_get(mbox_sample_window_sw);
		extractor.setWindowSize(pSampleWindow->getWindowSize());

		// Extract features
		if( extractorSelector & SEL_MAV  ) {
			extractor.getMeanAbsoluteValue(pSampleWindow->data(), pMAV);
		}
		if( extractorSelector & SEL_SSC  ) {
			extractor.getSlopeSignChanges(pSampleWindow->data(), pSampleWindow->getStart(), pSSC);
		}
		if( extractorSelector & SEL_WFL  ) {
			extractor.getWaveformLength(pSampleWindow->data(), pSampleWindow->getStart(), pWFL);
		}
		if( extractorSelector & SEL_ZC  ) {
			extractor.getZeroCrossings(pSampleWindow->data(), pSampleWindow->getStart(), threshold, pZC);
		}

		// Pass ID of the data
		if( extractorSelector > 0 ) {
			mbox_put(mbox_feature_window, (uint32_t)id_class);
		}
	}

	pthread_exit(0);
}
