extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "../lib/runtime/pglib/classification_r.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <netinet/tcp.h>
#include <sys/time.h>

using namespace std;

extern struct mbox *mbox_init_classification;
extern struct mbox *mbox_projected_features;
extern struct mbox *mbox_ack_classification;
extern struct mbox *mbox_lda_class_means;

extern "C" void *rt_classification(void *data_) {
	uint32_t addr;
	double* pProjectedFeatures = NULL;
	double* offsets = NULL;
	uint32_t nbrClasses = 0;
	uint32_t nVars = 0;

	int16_t result = 0;

	Classification_R* classifier = new Classification_R();


	while(1) {
		// If available, get Class-Mean-Vectors / offsets
		addr = (uint32_t) mbox_get(mbox_lda_class_means);
		if( addr != 0 ) {
			// Set pointer to data
			offsets = (double*)addr;

			// Get dimension of array
			nbrClasses = mbox_get(mbox_lda_class_means);
			nVars = mbox_get(mbox_lda_class_means);

			classifier->setOffset(offsets);
			classifier->setDimension(nbrClasses);

			// Signal TCP/IP-Server completion
			mbox_put(mbox_ack_classification, 0);
		}
		
		// Try to get new projected features and classify them
		addr = (uint32_t) mbox_get(mbox_projected_features);
		if( addr != 0 ) {
			pProjectedFeatures = (double*)addr;
			
			if( pProjectedFeatures != NULL ) {
				// Classify the data
				result = classifier->classify(pProjectedFeatures);
			}
			else {
				cout << "Classification" << endl << "\tInvalid Feature-Vector" << endl;
			}
		}

		// Give back result of classification
		mbox_put(mbox_ack_classification, (uint32_t)result);
	}

  pthread_exit(0);
}
