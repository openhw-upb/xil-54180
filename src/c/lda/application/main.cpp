extern "C" {
	#include "reconos.h"
	#include "reconos_app.h"
	#include "mbox.h"
}

#include "../lib/runtime/pglib/extractor_selector.h"

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

using namespace std;

// mboxes for inter-thread communication
struct mbox *mbox_init_server                       	= &resources_inittcpipserver_s;
struct mbox *mbox_init_feature_extraction_manger_sw 	= &resources_initfeatureextractionmanagersw_s;
struct mbox *mbox_init_feature_extraction_manger_hw 	= &resources_initfeatureextractionmanagerhw_s;
struct mbox *mbox_init_feature_projection           	= &resources_initfeatureprojection_s;
struct mbox *mbox_init_lda                          	= &resources_initlda_s;
struct mbox *mbox_init_classification               	= &resources_initclassification_s;

struct mbox *mbox_sample_window_sw    = &resources_samplewindowsw_s;
struct mbox *mbox_sample_window_hw    = &resources_samplewindowhw_s;
struct mbox *mbox_mav_mav  			  = &resources_mavmav_s;
struct mbox *mbox_feature_window      = &resources_featurewindow_s;
struct mbox *mbox_projected_features  = &resources_projectedfeatures_s;
struct mbox *mbox_ack_classification  = &resources_acknowledgementclassification_s;

struct mbox *mbox_lda_training_dataset  = &resources_ldatrainingdataset_s;
struct mbox *mbox_lda_projection_matrix  = &resources_ldaprojectionmatrix_s;
struct mbox *mbox_lda_class_means  = &resources_ldaclassmeans_s;

void print_help() {
	printf("ReconOS LDA-Classifier.\n"
				 "\n"
				 "Usage:\n"
				 "    lda <Port-no> <Window-Size> <Window-Shift> <Threshold> <#Channels> <#Classes> \n"
	);
}


int main(int argc, char **argv) {

	// Extractor-Selector
	uint32_t extractorSelectorHW = 0;
	uint32_t extractorSelectorSW = 0;
	
	// Enable Feature-Extractors in HW
	extractorSelectorHW |= SEL_MAV | SEL_SSC | SEL_WFL | SEL_ZC;

	// Enable Feature-Extractors in SW
	// extractorSelectorSW |= SEL_MAV | SEL_SSC | SEL_WFL | SEL_ZC;

	// Init.-Data
	uint32_t portno;
	uint32_t windowSize;
	uint32_t windowShift;
	int16_t threshold;
	uint16_t nbrFeaturesSW = 0;
	uint16_t nbrFeaturesHW = 0;
	uint16_t nbrFeatures = 0;
	uint16_t nbrChannels;
	uint32_t nbrChannelsNbrFeatures = 0;
	uint32_t nbrClasses;

	// Pointer for data-memory
	int16_t* pSampleWindow = NULL;
	double* pFeatureWindow = NULL;
	uint32_t* pFeatureWindowHW = NULL;
	double* pProjectedFeatures = NULL;

	// Parse command line arguments
	if (argc != 7) {
		print_help();
		return 0;
	}

	portno = atoi(argv[1]);
	windowSize = atoi(argv[2]);
	windowShift = atoi(argv[3]);
	if( windowShift == 0 ) {
		printf("Limit-Warning:\tChanged Window-Shift from 0 to 1\n");
		windowShift = 1;
	}
	threshold = atoi(argv[4]);
	nbrChannels = atoi(argv[5]);
	if( nbrChannels == 0 ) {
		printf("Limit-Warning:\tChanged #Channels from 0 to 1\n");
		nbrChannels = 1;
	}
	nbrClasses = atoi(argv[6]);

	// Initialize ReconOS
	reconos_init();
	reconos_app_init();
	
	// Create hardware/software threads
	printf("Creating HW-Threads:\n");
	if( extractorSelectorHW > 0 ) {
		printf("\tFeature-Extraction-Manager (HW)\n");
		reconos_thread_create_hwt_feature_extraction_manager();
		if( extractorSelectorHW & SEL_MAV  ) {
			printf("\t\tFeature: Mean-Absolute-Value\n");
			nbrFeaturesHW++;
		}
		if( extractorSelectorHW & SEL_SSC  ) {
			printf("\t\tFeature: Slope-Sign-Changes\n");
			nbrFeaturesHW++;
		}
		if( extractorSelectorHW & SEL_WFL  ) {
			printf("\t\tFeature: Waveformlength\n");
			nbrFeaturesHW++;
		}
		if( extractorSelectorHW & SEL_ZC  ) {
			printf("\t\tFeature: Zero-Crossings\n");
			nbrFeaturesHW++;
		}
	}
	printf("\n");

	printf("Creating SW-Threads:\n");
	printf("\tTCP/IP server\n");
	reconos_thread_create_swt_tcp_ip_server();

	if( extractorSelectorSW > 0 ) {
		printf("\tFeature-Extraction-Manager (SW)\n");
		reconos_thread_create_swt_feature_extraction_manager();
		if( extractorSelectorSW & SEL_MAV  ) {
			printf("\t\tFeature: Mean-Absolute-Value\n");
			nbrFeaturesSW++;
		}
		if( extractorSelectorSW & SEL_SSC  ) {
			printf("\t\tFeature: Slope-Sign-Changes\n");
			nbrFeaturesSW++;
		}
		if( extractorSelectorSW & SEL_WFL  ) {
			printf("\t\tFeature: Waveformlength\n");
			nbrFeaturesSW++;
		}
		if( extractorSelectorSW & SEL_ZC  ) {
			printf("\t\tFeature: Zero-Crossings\n");
			nbrFeaturesSW++;
		}
	}
	nbrFeatures = nbrFeaturesHW + nbrFeaturesSW;


	printf("\tFeature-Projection\n");
	reconos_thread_create_swt_feature_projection();

	printf("\tLDA\n");
	reconos_thread_create_swt_lda();

	printf("\tClassification\n");
	reconos_thread_create_swt_classification();

	printf("\n");

	// Allocate memory for data
	// Allocate memory for Sample-Window
	pSampleWindow = new int16_t[nbrChannels*windowSize];
	memset(pSampleWindow, 0, sizeof(pSampleWindow[0])*nbrChannels*windowSize);

	// Allocate memory for Feature-Window
	// SW
	pFeatureWindow = new double[nbrChannels*nbrFeatures];
	memset(pFeatureWindow, 0, sizeof(pFeatureWindow[0])*nbrChannels*nbrFeatures);
	// HW
	pFeatureWindowHW = new uint32_t[nbrChannels*nbrFeaturesHW];
	memset(pFeatureWindowHW, 0, sizeof(pFeatureWindowHW[0])*nbrChannels*nbrFeaturesHW);

	// Allocate memory for projected features
	pProjectedFeatures = new double[nbrChannels*nbrFeatures];
	memset(pProjectedFeatures, 0, sizeof(pProjectedFeatures[0])*nbrChannels*nbrFeatures);

	// Pass Init.-Parameter via mbox to TCP/IP-Server
	mbox_put(mbox_init_server, portno);
	mbox_put(mbox_init_server, windowSize);
	mbox_put(mbox_init_server, windowShift);
	mbox_put(mbox_init_server, (uint32_t)nbrChannels);
	mbox_put(mbox_init_server, (uint32_t)nbrClasses);
	mbox_put(mbox_init_server, (uint32_t)pSampleWindow);
	mbox_put(mbox_init_server, extractorSelectorSW);
	mbox_put(mbox_init_server, extractorSelectorHW);

	// Pass Init.-Parameter via mbox to Feature-Extraction-Manager-SW
	mbox_put(mbox_init_feature_extraction_manger_sw, (uint32_t)nbrFeaturesHW);
	mbox_put(mbox_init_feature_extraction_manger_sw, (uint32_t)nbrChannels);
	mbox_put(mbox_init_feature_extraction_manger_sw, (uint32_t)threshold);
	mbox_put(mbox_init_feature_extraction_manger_sw, (uint32_t)pFeatureWindow);
	mbox_put(mbox_init_feature_extraction_manger_sw, extractorSelectorSW);

	// Pass Init.-Parameter via mbox to Feature-Extraction-Manager-HW
	mbox_put(mbox_init_feature_extraction_manger_hw, extractorSelectorHW);
	nbrChannelsNbrFeatures = ((nbrChannels)<<16) | (nbrFeaturesHW);
	mbox_put(mbox_init_feature_extraction_manger_hw, nbrChannelsNbrFeatures);
	mbox_put(mbox_init_feature_extraction_manger_hw, windowSize);
	if( extractorSelectorHW & SEL_ZC ) {
		mbox_put(mbox_init_feature_extraction_manger_hw, threshold);
	}
	mbox_put(mbox_init_feature_extraction_manger_hw, (uint32_t)pSampleWindow);
	mbox_put(mbox_init_feature_extraction_manger_hw, (uint32_t)pFeatureWindowHW);

	// Pass Init.-Parameter via mbox to Feature-Projection
	mbox_put(mbox_init_feature_projection, windowSize);
	mbox_put(mbox_init_feature_projection, (uint32_t)nbrFeaturesHW);
	mbox_put(mbox_init_feature_projection, (uint32_t)nbrChannels);
	mbox_put(mbox_init_feature_projection, (uint32_t)pFeatureWindow);
	mbox_put(mbox_init_feature_projection, (uint32_t)pFeatureWindowHW);
	mbox_put(mbox_init_feature_projection, (uint32_t)pProjectedFeatures);
	mbox_put(mbox_init_feature_projection, extractorSelectorSW);
	mbox_put(mbox_init_feature_projection, extractorSelectorHW);

	// Pass Init.-Parameter via mbox to LDA
	mbox_put(mbox_init_lda, (uint32_t)nbrFeatures);
	mbox_put(mbox_init_lda, (uint32_t)nbrChannels);
	mbox_put(mbox_init_lda, (uint32_t)nbrClasses);

	while( 1 ) {
		
	}

	// ReconOS clean-up
	reconos_app_cleanup();
	reconos_cleanup();

	return 0;
}